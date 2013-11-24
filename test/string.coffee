vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Convert to String')
    .addBatch
        'end() method':
            topic: () ->
                xmlbuilder.create('test16', { 'version': '1.1' } ).ele('node').txt('test').end()

            'resulting XML': (topic) ->
                xml = '<?xml version="1.1"?><test16><node>test</node></test16>'
                assert.strictEqual topic, xml

    .export(module)

