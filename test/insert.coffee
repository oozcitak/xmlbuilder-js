vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Editing')
    .addBatch
        'Insert':
            topic: () ->
                xmlbuilder.create('test6', {}, {}, { headless: true })
                    .e('node','last')
                    .insertBefore('node','1')
                    .insertAfter('node','2')

            'resulting XML': (topic) ->
                xml = '<test6><node>1</node><node>2</node><node>last</node></test6>'
                assert.strictEqual topic.end(), xml

    .export(module)

