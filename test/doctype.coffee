vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Document Type Declaration')
    .addBatch
        'SYSTEM dtd from create()':
            topic: () ->
                xmlbuilder.create('root', { sysID: 'hello.dtd' })
                    .ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                       '<!DOCTYPE root SYSTEM "hello.dtd">' +
                       '<root><node>test</node></root>'
                assert.strictEqual topic.end(), xml

        'Empty dtd from create()':
            topic: () ->
                xmlbuilder.create('root', { sysID: '' })
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

        'Internal and external dtd':
            topic: () ->
                xmlbuilder.create('root')
                    .dtd('hello.dtd')
                        .ele('img', 'EMPTY')
                        .att('img', 'height', 'CDATA', '#REQUIRED')
                        .att('img', 'visible', '(yes|no)', '#DEFAULT', "yes")
                        .ele('node')
                    .root()
                    .ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                       '<!DOCTYPE root SYSTEM "hello.dtd" [' +
                           '<!ELEMENT img EMPTY>' +
                           '<!ATTLIST img height CDATA #REQUIRED>' +
                           '<!ATTLIST img visible (yes|no) "yes">' +
                           '<!ELEMENT node (#PCDATA)>' +
                       ']>' +
                       '<root><node>test</node></root>'
                assert.strictEqual topic.end(), xml


    .export(module)

