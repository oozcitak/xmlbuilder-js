vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Document Type Declaration')
    .addBatch
        'SYSTEM dtd from create()':
            topic: () ->
                xmlbuilder.create('root', { dtd: { sysID: 'hello.dtd' }})
                    .ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                       '<!DOCTYPE root SYSTEM "hello.dtd">' +
                       '<root><node>test</node></root>'
                assert.strictEqual topic.end(), xml

        'SYSTEM dtd from create() with dtd as string':
            topic: () ->
                xmlbuilder.create('root', { dtd: 'hello.dtd' })
                    .ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                       '<!DOCTYPE root SYSTEM "hello.dtd">' +
                       '<root><node>test</node></root>'
                assert.strictEqual topic.end(), xml

        'Empty dtd from create()':
            topic: () ->
                xmlbuilder.create('root', { dtd: {} })
                    .ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                       '<!DOCTYPE root>' +
                       '<root><node>test</node></root>'
                assert.strictEqual topic.end(), xml

        'Empty dtd from create() with dtd as string':
            topic: () ->
                xmlbuilder.create('root', { dtd: '' })
                    .ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                       '<!DOCTYPE root>' +
                       '<root><node>test</node></root>'
                assert.strictEqual topic.end(), xml

        'SYSTEM dtd from create() with legacy ext attribute':
            topic: () ->
                xmlbuilder.create('root', { ext: 'hello.dtd' })
                    .ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                       '<!DOCTYPE root SYSTEM "hello.dtd">' +
                       '<root><node>test</node></root>'
                assert.strictEqual topic.end(), xml


    .export(module)

