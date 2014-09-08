vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Creating XML')
    .addBatch
        'Long form':
            topic: () ->
                xmlbuilder.create('root')
                    .ele('xmlbuilder')
                        .att('for', 'node-js')
                        .com('CoffeeScript is awesome.')
                        .nod('repo')
                        .att('type', 'git')
                        .txt('git://github.com/oozcitak/xmlbuilder-js.git')
                        .up()
                    .up()
                    .ele('test')
                        .att('escaped', 'chars <>\'"&\t\n\r')
                        .txt('complete 100%<>\'"&\t\n\r')
                    .up()
                    .ele('cdata')
                        .cdata('<test att="val">this is a test</test>\nSecond line')
                    .up()
                    .ele('raw')
                        .raw('&<>&')
                        .up()
                    .ele('atttest', { 'att': 'val' }, 'text')
                        .up()
                    .ele('atttest', 'text')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root>' +
                          '<xmlbuilder for="node-js">' +
                              '<!-- CoffeeScript is awesome. -->' +
                              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
                          '</xmlbuilder>' +
                          '<test escaped="chars &lt;>\'&quot;&amp;&#x9;&#xA;&#xD;">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>' +
                          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
                          '<raw>&<>&</raw>' +
                          '<atttest att="val">text</atttest>' +
                          '<atttest>text</atttest>' +
                      '</root>'
                assert.strictEqual topic.end(), xml

        'Long form with attributes':
            topic: () ->
                xmlbuilder.create('root')
                    .ele('xmlbuilder', {'for': 'node-js' })
                        .com('CoffeeScript is awesome.')
                        .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
                        .up()
                    .up()
                    .ele('test', {'escaped': 'chars <>\'"&\t\n\r'}, 'complete 100%<>\'"&\t\n\r')
                    .up()
                    .ele('cdata')
                        .cdata('<test att="val">this is a test</test>\nSecond line')
                    .up()
                    .ele('raw')
                        .raw('&<>&')
                        .up()
                    .ele('atttest', { 'att': 'val' }, 'text')
                        .up()
                    .ele('atttest', 'text')
                        .att('att', () -> 'val')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root>' +
                          '<xmlbuilder for="node-js">' +
                              '<!-- CoffeeScript is awesome. -->' +
                              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
                          '</xmlbuilder>' +
                          '<test escaped="chars &lt;>\'&quot;&amp;&#x9;&#xA;&#xD;">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>' +
                          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
                          '<raw>&<>&</raw>' +
                          '<atttest att="val">text</atttest>' +
                          '<atttest att="val">text</atttest>' +
                      '</root>'
                assert.strictEqual topic.end(), xml

        'Pretty printing':
            topic: () ->
                xmlbuilder.create('root')
                    .ele('xmlbuilder', {'for': 'node-js' })
                        .com('CoffeeScript is awesome.')
                        .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
                        .up()
                    .up()
                    .ele('test', {'escaped': 'chars <>\'"&\t\n\r'}, 'complete 100%<>\'"&\t\n\r')
                    .up()
                    .ele('cdata')
                        .cdata('<test att="val">this is a test</test>\nSecond line')
                    .up()
                    .ele('raw')
                        .raw('&<>&')
                        .up()
                    .ele('atttest', { 'att': 'val' }, 'text')
                        .up()
                    .ele('atttest', 'text')
                        .att('att', () -> 'val')

            'resulting XML': (topic) ->
                xml = """
                      <?xml version="1.0"?>
                      <root>
                          <xmlbuilder for="node-js">
                              <!-- CoffeeScript is awesome. -->
                              <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
                          </xmlbuilder>
                          <test escaped="chars &lt;>\'&quot;&amp;&#x9;&#xA;&#xD;">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>
                          <cdata>
                              <![CDATA[<test att="val">this is a test</test>
                      Second line]]>
                          </cdata>
                          <raw>&<>&</raw>
                          <atttest att="val">text</atttest>
                          <atttest att="val">text</atttest>
                      </root>
                      """
                assert.strictEqual topic.end({ pretty: true, indent: '    ' }), xml

        'Pretty printing with offset':
            topic: () ->
                xmlbuilder.create('root')
                    .ele('xmlbuilder', {'for': 'node-js' })
                        .com('CoffeeScript is awesome.')
                        .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
                        .up()
                    .up()
                    .ele('test', {'escaped': 'chars <>\'"&\t\n\r'}, 'complete 100%<>\'"&\t\n\r')
                    .up()
                    .ele('cdata')
                        .cdata('<test att="val">this is a test</test>\nSecond line')
                    .up()
                    .ele('raw')
                        .raw('&<>&')
                        .up()
                    .ele('atttest', { 'att': 'val' }, 'text')
                        .up()
                    .ele('atttest', 'text')
                        .att('att', () -> 'val')

            'resulting XML': (topic) ->
                xml = """
                    TEMPORARY_INDENT
                        <?xml version="1.0"?>
                        <root>
                            <xmlbuilder for="node-js">
                                <!-- CoffeeScript is awesome. -->
                                <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
                            </xmlbuilder>
                            <test escaped="chars &lt;>\'&quot;&amp;&#x9;&#xA;&#xD;">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>
                            <cdata>
                                <![CDATA[<test att="val">this is a test</test>
                    Second line]]>
                            </cdata>
                            <raw>&<>&</raw>
                            <atttest att="val">text</atttest>
                            <atttest att="val">text</atttest>
                        </root>
                  """
                pattern = ///
                  TEMPORARY_INDENT\n
                ///

                #Heredoc format indenting is based on the first non-whitespace character, so we add extra, then replace it
                xml = xml.replace pattern,''

                assert.strictEqual topic.end({ pretty: true, indent: '    ', offset : 1 }), xml

        'Pretty printing with empty indent':
            topic: () ->
                xmlbuilder.create('root')
                    .ele('xmlbuilder', {'for': 'node-js' })
                        .com('CoffeeScript is awesome.')
                        .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
                        .up()
                    .up()
                    .ele('test', {'escaped': 'chars <>\'"&\t\n\r'}, 'complete 100%<>\'"&\t\n\r')
                    .up()
                    .ele('cdata')
                        .cdata('<test att="val">this is a test</test>\nSecond line')
                    .up()
                    .ele('raw')
                        .raw('&<>&')
                        .up()
                    .ele('atttest', { 'att': 'val' }, 'text')
                        .up()
                    .ele('atttest', 'text')
                        .att('att', () -> 'val')

            'resulting XML': (topic) ->
                xml = """
                      <?xml version="1.0"?>
                      <root>
                      <xmlbuilder for="node-js">
                      <!-- CoffeeScript is awesome. -->
                      <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
                      </xmlbuilder>
                      <test escaped="chars &lt;>\'&quot;&amp;&#x9;&#xA;&#xD;">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>
                      <cdata>
                      <![CDATA[<test att="val">this is a test</test>
                      Second line]]>
                      </cdata>
                      <raw>&<>&</raw>
                      <atttest att="val">text</atttest>
                      <atttest att="val">text</atttest>
                      </root>
                      """
                assert.strictEqual topic.end({ pretty: true, indent: '' }), xml

        'Short form with attributes':
            topic: () ->
                xmlbuilder.create('root')
                    .e('xmlbuilder', {'for': 'node-js' })
                        .c('CoffeeScript is awesome.')
                        .n('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
                        .u()
                    .u()
                    .e('test', {'escaped': 'chars <>\'"&\t\n\r'}, 'complete 100%<>\'"&\t\n\r')
                    .u()
                    .e('cdata')
                        .d('<test att="val">this is a test</test>\nSecond line')
                    .u()
                    .e('raw')
                        .r('&<>&')
                        .u()
                    .e('atttest', { 'att': 'val' }, 'text')
                        .u()
                    .e('atttest', 'text')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root>' +
                          '<xmlbuilder for="node-js">' +
                              '<!-- CoffeeScript is awesome. -->' +
                              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
                          '</xmlbuilder>' +
                          '<test escaped="chars &lt;>\'&quot;&amp;&#x9;&#xA;&#xD;">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>' +
                          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
                          '<raw>&<>&</raw>' +
                          '<atttest att="val">text</atttest>' +
                          '<atttest>text</atttest>' +
                      '</root>'
                assert.strictEqual topic.end(), xml

        'create() without arguments':
            topic: () ->
                xmlbuilder.create('test14').ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?><test14><node>test</node></test14>'
                assert.strictEqual topic.end(), xml

        'create() with arguments':
            topic: () ->
                xmlbuilder.create('test14', { 'version': '1.1' }).ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.1"?><test14><node>test</node></test14>'
                assert.strictEqual topic.end(), xml

        'create() with merged arguments':
            topic: () ->
                xml1 = xmlbuilder.create('test14', { version: '1.1', encoding: 'UTF-8', standalone: true, sysID: 'hello.dtd' })
                    .ele('node').txt('test')
                xml2 = xmlbuilder.create('test14', { headless: true, version: '1.1', encoding: 'UTF-8', standalone: true, sysID: 'hello.dtd' })
                    .ele('node').txt('test')
                [xml1, xml2]

            'resulting XML1': (topic) ->
                xml1 = '<?xml version="1.1" encoding="UTF-8" standalone="yes"?>' +
                       '<!DOCTYPE test14 SYSTEM "hello.dtd"><test14><node>test</node></test14>'
                assert.strictEqual topic[0].end(), xml1

            'resulting XML2': (topic) ->
                xml2 = '<test14><node>test</node></test14>'
                assert.strictEqual topic[1].end(), xml2


    .export(module)

