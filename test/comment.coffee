vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Text Processing')
    .addBatch
        'Nothing gets escaped':
            topic: () ->
                xmlbuilder.create('comment', {}, {}, { headless: true })
                    .comment('<>\'"&\t\n\r')

            'resulting XML': (topic) ->
                xml = '<comment><!-- <>\'"&\t\n\r --></comment>'
                assert.strictEqual topic.doc().toString(), xml

    .export(module)

