vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Navigation')
    .addBatch
        'Doc':
            topic: () ->
                xmlbuilder.create('test7', {}, {}, { headless: true })
                    .ele('nodes')
                    .ele('node', '1').up()
                    .ele('node', '2').up()
                    .ele('node', '3')

            'resulting XML': (topic) ->
                xml = '<test7><nodes><node>1</node><node>2</node><node>3</node></nodes></test7>'
                assert.strictEqual topic.doc().toString(), xml

    .export(module)

