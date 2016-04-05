_ = require 'lodash'
memwatch = require 'memwatch-next'
fs = require 'fs'

xmlbuilder = require '../src/index.coffee'

start = new Date()
elapsed = () ->
    ms = new Date() - start
    start = new Date()
    ms

startForTotal = new Date()
elapsedTotal = () ->
    new Date() - startForTotal

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
    options = _.extend { repeat: 10 }, options
    console.log '    XMLBuilder v' + require('../package.json').version
    console.log '    Testing: ' + file
    console.log '    Repeats: ' + options.repeat

    data = fs.readFileSync file, { encoding: 'utf8' }
    obj = JSON.parse data
    dataSize = Buffer.byteLength data, 'utf8'
    console.log '    JSON Node Count: ' + jsonNodeCount(obj)
    console.log '    JSON String Size: ' + fmtSize(dataSize)

    i = options.repeat
    n = 0
    while i--
        process.nextTick -> doTestOnce ++n, obj


doTestOnce = (n, obj) ->
    hd = new memwatch.HeapDiff()

    elapsed()
    xml = xmlbuilder.create(obj)
    buildTime = elapsed()

    elapsed()
    str = xml.end({pretty: true})
    stringTime = elapsed()

    diff = hd.end()

    console.log '    Heap Diff: before ' + diff.before.size + ', after ' + diff.after.size + ', change ' + diff.change.size


memwatch.on 'leak', (info) ->
    console.log "!!! Leak Detected: ", info


doTest __dirname + '/test.json', { repeat: 20 }
