vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Clone')
    .addBatch
        'Test the clone() method':
            topic: () ->
                test = xmlbuilder.create('test11', {}, {}, { headless: true})
                    .att('att', 'val')
                    .ele('nodes')
                        .ele('node', '1').up()
                        .ele('node', '2')
                            .att('att2', 'val2')
                    .root()

                testcloned = test.root().clone()
                testcloned.ele('added', '3')

                { original: test, cloned: testcloned }

            'resulting XML':
                'original should remain unchanged': (topic) ->
                    xml = '<test11 att="val"><nodes><node>1</node><node att2="val2">2</node></nodes></test11>'
                    assert.strictEqual topic.original.doc().toString(), xml
                'cloned should contain all nodes including added node': (topic) ->
                    xml = '<test11 att="val"><nodes><node>1</node><node att2="val2">2</node></nodes><added>3</added></test11>'
                    assert.strictEqual topic.cloned.toString(), xml

    .export(module)

