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

nodeCount = (obj) ->
    total = 0
    if _.isArray obj
        for item in obj
            total += nodeCount item
    else if _.isObject obj
        for own key, val of obj
            total += nodeCount val
    else
        total += 1
    return total

doTest = (file, rep) ->
    rep ?= 100
    console.log 'Testing: ' + file
    console.log '    Repeats: ' + rep

    hdmain = new memwatch.HeapDiff()

    data = fs.readFileSync file, { encoding: 'utf8' }
    obj = JSON.parse data
    dataSize = Buffer.byteLength data, 'utf8'
    console.log '    JSON Node Count: ' + nodeCount(obj)
    console.log '    JSON String Size: ' + fmtSize(dataSize)

    buildTime = 0
    buildMem = 0
    buildMemMax = 0
    stringTime = 0
    stringMem = 0
    stringMemMax = 0
    strSize = 0
    elapsed()
    i = rep
    while i--
        memwatch.gc()
        hd = new memwatch.HeapDiff()
        xml = xmlbuilder.create(obj)
        hde = hd.end()
        buildTime += elapsed()
        buildMem += hde.change.size_bytes
        buildMemMax = Math.max buildMemMax, hde.after.size_bytes

        hd = new memwatch.HeapDiff()
        str = xml.end({pretty: true})
        hde = hd.end()
        stringTime += elapsed()
        stringMem += hde.change.size_bytes
        stringMemMax = Math.max stringMemMax, hde.after.size_bytes
        if not strSize
            strSize = Buffer.byteLength str, 'utf8'
            console.log '    XML String Size: ' + fmtSize(strSize)

        xml = null
        str = null

    buildTime /= rep
    buildMem /= rep
    stringTime /= rep
    stringMem /= rep

    data = null
    obj = null
    memwatch.gc()
    hde = hdmain.end()

    console.log '    Memory Before: ' + fmtSize(hde.before.size_bytes)
    console.log '    Build XML: ' + fmtTime(buildTime) + ' -> ' +
        fmtSize(buildMem, true) + ' (' + fmtSize(buildMemMax) + ' max)'
    console.log '    Convert to String: ' + fmtTime(stringTime) + ' -> ' +
        fmtSize(stringMem, true) + ' (' + fmtSize(stringMemMax) + ' max)'
    console.log '    Memory After: ' + fmtSize(hde.after.size_bytes)

doTest __dirname + '/test.json', 10

