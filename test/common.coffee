global.builder = require('../src/index')
global.assert = require('assert')

global.xml = builder.create
global.doc = builder.begin
global.writer = builder.stringWriter

global.xpath = require('xpath')

global.ok = assert.ok
global.eq = assert.strictEqual
global.err = assert.throws
global.noterr = assert.doesNotThrow
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

global.xmleleend = (arg) ->
  builder.create('root', { headless: true }).ele(arg).end()
