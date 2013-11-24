vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Clone')
    .addBatch
        'Test the clone() method (not deep clone)':
            topic: () ->
                test = xmlbuilder.create('test11', {}, {}, { headless: true})
                    .ele('nodes')
                        .ele('node', '1')
                    .root()

                testcloned = test.root().clone()
                testcloned.ele('added', '3')

                { original: test, cloned: testcloned }

            'resulting XML':
                'original should remain unchanged': (topic) ->
                    xml = '<test11><nodes><node>1</node></nodes></test11>'
                    assert.strictEqual topic.original.doc().toString(), xml
                'cloned should contain added node only': (topic) ->
                    xml = '<test11><added>3</added></test11>'
                    assert.strictEqual topic.cloned.toString(), xml

        'Test the clone() method (deep clone)':
            topic: () ->
                test = xmlbuilder.create('test11', {}, {}, { headless: true})
                    .ele('nodes')
                        .ele('node', '1').up()
                        .ele('node', '2')
                    .root()

                testcloned = test.root().clone(true)
                testcloned.ele('added', '3')

                { original: test, cloned: testcloned }

            'resulting XML':
                'original should remain unchanged': (topic) ->
                    xml = '<test11><nodes><node>1</node><node>2</node></nodes></test11>'
                    assert.strictEqual topic.original.doc().toString(), xml
                'cloned should contain all nodes including added node': (topic) ->
                    xml = '<test11><nodes><node>1</node><node>2</node></nodes><added>3</added></test11>'
                    assert.strictEqual topic.cloned.toString(), xml

    .export(module)

