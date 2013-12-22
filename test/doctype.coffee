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
                        .ins('pub_border', 'thin')
                        .ele('img', 'EMPTY')
                        .com('Image attributes follow')
                        .att('img', 'height', 'CDATA', '#REQUIRED')
                        .att('img', 'visible', '(yes|no)', '#DEFAULT', "yes")
                        .not('fs', 'FS Reader 1.0')
                        .not('fs-nt', 'PUBLIC', 'FS Network Reader 1.0', 'http://my.fs.com/reader')
                        .att('img', 'src', 'NOTATION (fs|fs-nt)', '#REQUIRED')
                        .dat('<owner>John</owner>')
                        .ele('node')
                    .root()
                    .ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                       '<!DOCTYPE root SYSTEM "hello.dtd" [' +
                           '<?pub_border thin?>' +
                           '<!ELEMENT img EMPTY>' +
                           '<!-- Image attributes follow -->' +
                           '<!ATTLIST img height CDATA #REQUIRED>' +
                           '<!ATTLIST img visible (yes|no) "yes">' +
                           '<!NOTATION fs SYSTEM "FS Reader 1.0">' +
                           '<!NOTATION fs-nt PUBLIC "FS Network Reader 1.0" "http://my.fs.com/reader">' +
                           '<!ATTLIST img src NOTATION (fs|fs-nt) #REQUIRED>' +
                           '<![CDATA[<owner>John</owner>]]>' +
                           '<!ELEMENT node (#PCDATA)>' +
                       ']>' +
                       '<root><node>test</node></root>'
                assert.strictEqual topic.end(), xml


    .export(module)

