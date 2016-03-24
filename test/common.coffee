global.builder = require('../src/index.coffee')
global.xml = builder.create
global.doc = builder.begin
global.writer = builder.stringWriter
global.eq = require('assert').strictEqual
global.err = require('assert').throws
global.noterr = require('assert').doesNotThrow
global.isan = (obj, type) ->
  clas = obj.constructor.name
  eq(clas, type)

global.captureStream = (stream) ->
  oldWrite = stream.write
  buf = ''
  stream.write = (chunk, encoding, callback) ->
    buf += chunk.toString()
    # oldWrite.apply(stream, arguments)

  return {
    unhook: ->
      stream.write = oldWrite
    captured: ->
      buf
  }
