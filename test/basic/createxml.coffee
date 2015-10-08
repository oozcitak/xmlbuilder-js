suite 'Creating XML:', ->
  test 'Long form', ->
    eq(
      xml('root')
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
        .end()

      '<?xml version="1.0"?>' +
      '<root>' +
          '<xmlbuilder for="node-js">' +
              '<!-- CoffeeScript is awesome. -->' +
              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
          '</xmlbuilder>' +
          '<test escaped="chars &lt;>\'&quot;&amp;\t\n\r">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>' +
          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
          '<raw>&<>&</raw>' +
          '<atttest att="val">text</atttest>' +
          '<atttest>text</atttest>' +
      '</root>'
    )

  test 'Long form with attributes', ->
    eq(
      xml('root')
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
        .end()

      '<?xml version="1.0"?>' +
      '<root>' +
          '<xmlbuilder for="node-js">' +
              '<!-- CoffeeScript is awesome. -->' +
              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
          '</xmlbuilder>' +
          '<test escaped="chars &lt;>\'&quot;&amp;\t\n\r">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>' +
          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
          '<raw>&<>&</raw>' +
          '<atttest att="val">text</atttest>' +
          '<atttest att="val">text</atttest>' +
      '</root>'
    )

  test 'Pretty printing', ->
    eq(
      xml('root')
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
        .end({ pretty: true, indent: '    ' })

      """
      <?xml version="1.0"?>
      <root>
          <xmlbuilder for="node-js">
              <!-- CoffeeScript is awesome. -->
              <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
          </xmlbuilder>
          <test escaped="chars &lt;>\'&quot;&amp;\t\n\r">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>
          <cdata>
              <![CDATA[<test att="val">this is a test</test>
      Second line]]>
          </cdata>
          <raw>&<>&</raw>
          <atttest att="val">text</atttest>
          <atttest att="val">text</atttest>
      </root>
      """
    )

  test 'Pretty printing with offset', ->
    eq(
      xml('root')
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
        .end({ pretty: true, indent: '    ', offset : 1 })

      """
        TEMPORARY_INDENT
            <?xml version="1.0"?>
            <root>
                <xmlbuilder for="node-js">
                    <!-- CoffeeScript is awesome. -->
                    <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
                </xmlbuilder>
                <test escaped="chars &lt;>\'&quot;&amp;\t\n\r">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>
                <cdata>
                    <![CDATA[<test att="val">this is a test</test>
        Second line]]>
                </cdata>
                <raw>&<>&</raw>
                <atttest att="val">text</atttest>
                <atttest att="val">text</atttest>
            </root>
      """.replace(
        ///
          TEMPORARY_INDENT\n
        ///
        ''
      ) #Heredoc format indenting is based on the first non-whitespace character, so we add extra, then replace it
    )

  test 'Pretty printing with empty indent', ->
    eq(
      xml('root')
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
        .end({ pretty: true, indent: '' })

      """
      <?xml version="1.0"?>
      <root>
      <xmlbuilder for="node-js">
      <!-- CoffeeScript is awesome. -->
      <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
      </xmlbuilder>
      <test escaped="chars &lt;>\'&quot;&amp;\t\n\r">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>
      <cdata>
      <![CDATA[<test att="val">this is a test</test>
      Second line]]>
      </cdata>
      <raw>&<>&</raw>
      <atttest att="val">text</atttest>
      <atttest att="val">text</atttest>
      </root>
      """
    )

  test 'Short form with attributes', ->
    eq(
      xml('root')
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
        .e('atttest')
          .a('att2', 'val2')
          .i('pi', 'pival')
          .t('text2')
        .end()

      '<?xml version="1.0"?>' +
      '<root>' +
          '<xmlbuilder for="node-js">' +
              '<!-- CoffeeScript is awesome. -->' +
              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
          '</xmlbuilder>' +
          '<test escaped="chars &lt;>\'&quot;&amp;\t\n\r">complete 100%&lt;&gt;\'"&amp;\t\n&#xD;</test>' +
          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
          '<raw>&<>&</raw>' +
          '<atttest att="val">text</atttest>' +
          '<?pi pival?>' +
          '<atttest att2="val2">text2</atttest>' +
      '</root>'
    )

  test 'create() without arguments', ->
    eq(
      xml('test14').ele('node').txt('test').end()
      '<?xml version="1.0"?><test14><node>test</node></test14>'
    )

  test 'create() with arguments', ->
    eq(
      xml('test14', { 'version': '1.1' }).ele('node').txt('test').end()
      '<?xml version="1.1"?><test14><node>test</node></test14>'
    )

  test 'create() with merged arguments', ->
    eq(
      xml('test14', { version: '1.1', encoding: 'UTF-8', standalone: true, sysID: 'hello.dtd' })
        .ele('node').txt('test').end()
      '<?xml version="1.1" encoding="UTF-8" standalone="yes"?>' +
      '<!DOCTYPE test14 SYSTEM "hello.dtd"><test14><node>test</node></test14>'
    )
  
    eq(
      xml('test14', { headless: true, version: '1.1', encoding: 'UTF-8', standalone: true, sysID: 'hello.dtd' })
        .ele('node').txt('test').end()
      '<test14><node>test</node></test14>'
    )

