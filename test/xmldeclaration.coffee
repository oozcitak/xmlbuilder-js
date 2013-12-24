vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('XML Declaration')
    .addBatch
        'From create() without arguments':
            topic: () ->
                xmlbuilder.create('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?><test/>'
                assert.strictEqual topic.end(), xml

        'From create() with arguments':
            topic: () ->
                xmlbuilder.create('test', { version: '1.1', encoding: 'UTF-8', standalone: true })

            'resulting XML': (topic) ->
                xml = '<?xml version="1.1" encoding="UTF-8" standalone="yes"?><test/>'
                assert.strictEqual topic.end(), xml

        'From dec() without arguments':
            topic: () ->
                xmlbuilder.create('test', { headless: true }).dec().ele('node')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?><test><node/></test>'
                assert.strictEqual topic.end(), xml

        'From dec() with arguments':
            topic: () ->
                xmlbuilder.create('test').dec({ version: '1.1', encoding: 'UTF-8', standalone: true }).ele('node')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.1" encoding="UTF-8" standalone="yes"?><test><node/></test>'
                assert.strictEqual topic.end(), xml

    .export(module)

