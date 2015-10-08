global.xml = require('../src/index.coffee').create
global.eq = require('assert').strictEqual
global.err = require('assert').throws
global.noterr = require('assert').doesNotThrow
global.isan = (obj, type) ->
  clas = obj.constructor.name
  eq(clas, type)
