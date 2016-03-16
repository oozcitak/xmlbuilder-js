global.builder = require('../src/index.coffee')
global.xml = builder.create
global.eq = require('assert').strictEqual
global.err = require('assert').throws
global.noterr = require('assert').doesNotThrow
global.isan = (obj, type) ->
  clas = obj.constructor.name
  eq(clas, type)
