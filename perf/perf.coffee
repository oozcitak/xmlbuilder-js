_ = require 'underscore'
memwatch = require 'memwatch'
fs = require 'fs'

xmlbuilder = require '../src/index.coffee'

start = new Date()
elapsed = () ->
    ms = new Date() - start
    start = new Date()
    ms

fmtTime = (ms) ->
    if ms < 1000
        ms + ' ms'
    else
        (ms / 1000).toFixed(2) + ' s'

fmtSize = (size, delta) ->
    sign = if delta and size > 0 then '+' else ''
    if size < 1024
        sign + size + ' bytes'
    else if size < 1024 * 1024
        sign + (size / 1024).toFixed(2) + ' kB'
    else if size < 1024 * 1024 * 1024
        sign + (size / (1024 * 1024)).toFixed(2) + ' MB'
    else
        sign + (size / (1024 * 1024 * 1024)).toFixed(2) + ' GB'

arrMin = (arr) ->
    Math.min.apply null, arr

arrMax = (arr) ->
    Math.max.apply null, arr

arrAve = (arr) ->
    sum = 0
    sum += n for n in arr
    sum / arr.length

fmtArr = (arr, fmt) ->
    fmt(arrMin(arr)) + ' min. ~ ' +
    fmt(arrMax(arr)) + ' max. : ' +
    fmt(arrAve(arr)) + ' ave.'

jsonNodeCount = (obj) ->
    total = 0
    if _.isArray obj
        for item in obj
            total += jsonNodeCount item
    else if _.isObject obj
        total += _.size obj
        for own key, val of obj
            total += jsonNodeCount val
    else
        total += 1
    return total

xmlNodeCount = (obj) ->
    total = 1
    if obj.attributes
        total += _.size obj.attributes
    if obj.instructions
        total += obj.instructions.length
    if obj.children
        for item in obj.children
            total += xmlNodeCount item
    return total

doTest = (file, options) ->
    options = _.extend { repeat: 10, time: true, mem: true }, options
    console.log '    XMLBuilder v' + require('../package.json').version
    console.log '    Testing: ' + file
    console.log '    Repeats: ' + options.repeat

    data = fs.readFileSync file, { encoding: 'utf8' }
    obj = JSON.parse data
    dataSize = Buffer.byteLength data, 'utf8'
    console.log '    JSON Node Count: ' + jsonNodeCount(obj)
    console.log '    JSON String Size: ' + fmtSize(dataSize)

    buildTime = []
    buildMem = []
    stringTime = []
    stringMem = []
    nodeCount = 0
    strSize = 0
    i = options.repeat
    while i--
        xml = null
        str = null
        memwatch.gc() if options.mem

        hd = new memwatch.HeapDiff() if options.mem
        elapsed() if options.time
        xml = xmlbuilder.create(obj)
        buildTime.push elapsed() if options.time
        hde = hd.end() if options.mem
        buildMem.push hde.change.size_bytes if options.mem

        hd = new memwatch.HeapDiff() if options.mem
        elapsed() if options.time
        str = xml.end({pretty: true})
        stringTime.push elapsed() if options.time
        hde = hd.end() if options.mem
        stringMem.push hde.change.size_bytes if options.mem

        if not nodeCount
            nodeCount = xmlNodeCount xml.root()
            console.log '    XML Node Count: ' + nodeCount
        if not strSize
            strSize = Buffer.byteLength str, 'utf8'
            console.log '    XML String Size: ' + fmtSize(strSize)

    console.log '    Build XML:' if options.time or options.mem
    console.log '        Time: ' + fmtArr(buildTime, fmtTime) if options.time
    console.log '        Memory: ' + fmtArr(buildMem, fmtSize)if options.mem
    console.log '    Convert to String:' if options.time or options.mem
    console.log '        Time: ' + fmtArr(stringTime, fmtTime) if options.time
    console.log '        Memory: ' + fmtArr(stringMem, fmtSize) if options.mem

doTest __dirname + '/test.json', { repeat: 2 }

