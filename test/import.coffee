vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Edit')
    .addBatch
        'Import':
            topic: () ->
                test13imported = xmlbuilder.create('test13imported', {}, {}, { headless: true })
                    .ele('node', 'imported')
                xmlbuilder.create('test13', {}, {}, { headless: true })
                   .importXMLBuilder(test13imported.doc())

            'resulting XML': (topic) ->
                xml = '<test13><test13imported><node>imported</node></test13imported></test13>'
                assert.strictEqual topic.doc().toString(), xml

    .export(module)

