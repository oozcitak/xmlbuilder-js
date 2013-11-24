vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Processing Instructions')
    .addBatch
        'Simple':
            topic: () ->
                xmlbuilder.create('test17', { 'version': '1.1' } )
                    .ins('pi', 'mypi')
                    .ele('node')
                        .txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.1"?><?pi mypi?><test17><node>test</node></test17>'
                assert.strictEqual topic.end(), xml

        'Complex':
            topic: () ->
                xmlbuilder.create('test18', { 'version': '1.1' } )
                    .ins('renderCache.subset', '"Verdana" 0 0 ISO-8859-1 4 268 67 "#(),-./')
                    .ele('node')
                    .ins('pitarget', 'pivalue')
                    .txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.1"?><?renderCache.subset "Verdana" 0 0 ISO-8859-1 4 268 67 "#(),-./?><test18><?pitarget pivalue?><node>test</node></test18>'
                assert.strictEqual topic.end(), xml


    .export(module)

