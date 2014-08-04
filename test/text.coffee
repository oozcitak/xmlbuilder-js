vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Text Processing')
    .addBatch
        'Escape "':
            topic: () ->
                xmlbuilder.create('test8', {}, {}, { headless: true })
                    .ele('node', '"')

            'resulting XML': (topic) ->
                xml = '<test8><node>"</node></test8>'
                assert.strictEqual topic.doc().toString(), xml

        'Text node with empty string':
            topic: () ->
                xmlbuilder.create('test9', {}, {}, { headless: true })
                    .text('')

            'resulting XML': (topic) ->
                xml = '<test9></test9>'
                assert.strictEqual topic.doc().toString(), xml

        'Text node with empty string (pretty print)':
            topic: () ->
                xmlbuilder.create('test10', {}, {}, { headless: true })
                    .text('')

            'resulting XML': (topic) ->
                xml = '<test10></test10>'
                assert.strictEqual topic.doc().toString({ pretty: true }), xml

    .export(module)

