vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Stringify')
    .addBatch
        'Custom function':
            topic: () ->
                addns = (val) ->
                    'my:' + val

                xmlbuilder.create('test7', { headless: true, stringify: { eleName: addns } })
                    .ele('nodes')
                    .ele('node', '1').up()
                    .ele('node', '2').up()
                    .ele('node', '3')

            'resulting XML': (topic) ->
                xml = '<my:test7><my:nodes><my:node>1</my:node><my:node>2</my:node><my:node>3</my:node></my:nodes></my:test7>'
                assert.strictEqual topic.end(), xml

    .export(module)

