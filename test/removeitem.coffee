vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Editing')
    .addBatch
        'Remove item':
            topic: () ->
                xmlbuilder.create('test3', {}, {}, { headless: true })
                    .e('node', 'first instance')
                    .u()
                    .e('node', 'second instance')
                    .remove()
                    .e('node', 'third instance')

            'resulting XML': (topic) ->
                xml = '<test3><node>first instance</node><node>third instance</node></test3>'
                assert.strictEqual topic.end(), xml

    .export(module)

