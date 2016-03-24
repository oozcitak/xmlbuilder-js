suite 'Creating XML with stream writer:', ->
  hook = null
  setup 'hook stdout.write', ->
    hook = captureStream(process.stdout)
    return
  teardown 'unhook stdout.write', ->
    hook.unhook()
    return

  test 'Plain text writer', ->
    xml('root')
      .dtd('hello.dtd', 'sys')
          .ins('pub_border', 'thin')
          .ele('img', 'EMPTY')
          .com('Image attributes follow')
          .att('img', 'height', 'CDATA', '#REQUIRED')
          .att('img', 'visible', '(yes|no)', '#DEFAULT', "yes")
          .not('fs', { sysID: 'http://my.fs.com/reader' })
          .not('fs-nt', { pubID: 'FS Network Reader 1.0' })
          .not('fs-nt', { pubID: 'FS Network Reader 1.0', sysID: 'http://my.fs.com/reader' })
          .att('img', 'src', 'NOTATION (fs|fs-nt)', '#REQUIRED')
          .dat('<owner>John</owner>')
          .ele('node')
          .ent('ent', 'my val')
          .ent('ent', { sysID: 'http://www.myspec.com/ent' })
          .ent('ent', { pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent' })
          .ent('ent', { sysID: 'http://www.myspec.com/ent', nData: 'entprg' })
          .ent('ent', { pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent', nData: 'entprg' })
          .pent('ent', 'my val')
          .pent('ent', { sysID: 'http://www.myspec.com/ent' })
          .pent('ent', { pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent' })
          .ele('nodearr', ['a', 'b'])
      .root()
      .ele('xmlbuilder', {'for': 'node-js' })
          .com('CoffeeScript is awesome.')
          .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
          .up()
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
      .end(builder.streamWriter(process.stdout))

    eq(
      hook.captured()

      '<?xml version="1.0"?>' +
      '<!DOCTYPE root PUBLIC "hello.dtd" "sys" [' +
          '<?pub_border thin?>' +
          '<!ELEMENT img EMPTY>' +
          '<!-- Image attributes follow -->' +
          '<!ATTLIST img height CDATA #REQUIRED>' +
          '<!ATTLIST img visible (yes|no) "yes">' +
          '<!NOTATION fs SYSTEM "http://my.fs.com/reader">' +
          '<!NOTATION fs-nt PUBLIC "FS Network Reader 1.0">' +
          '<!NOTATION fs-nt PUBLIC "FS Network Reader 1.0" "http://my.fs.com/reader">' +
          '<!ATTLIST img src NOTATION (fs|fs-nt) #REQUIRED>' +
          '<![CDATA[<owner>John</owner>]]>' +
          '<!ELEMENT node (#PCDATA)>' +
          '<!ENTITY ent "my val">' +
          '<!ENTITY ent SYSTEM "http://www.myspec.com/ent">' +
          '<!ENTITY ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent">' +
          '<!ENTITY ent SYSTEM "http://www.myspec.com/ent" NDATA entprg>' +
          '<!ENTITY ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent" NDATA entprg>' +
          '<!ENTITY % ent "my val">' +
          '<!ENTITY % ent SYSTEM "http://www.myspec.com/ent">' +
          '<!ENTITY % ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent">' +
          '<!ELEMENT nodearr (a,b)>' +
      ']>' +
      '<root>' +
          '<xmlbuilder for="node-js">' +
              '<!-- CoffeeScript is awesome. -->' +
              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
          '</xmlbuilder>' +
          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
          '<raw>&<>&</raw>' +
          '<atttest att="val">text</atttest>' +
          '<atttest att="val">text</atttest>' +
      '</root>'
    )

  test 'Plain text writer set()', ->
    xml('root')
      .ele('xmlbuilder')
      .end(builder.streamWriter(process.stdout, { pretty: true }).set({ pretty: false }))

    eq(
      hook.captured()

      '<?xml version="1.0"?>' +
      '<root>' +
          '<xmlbuilder/>' +
      '</root>'
    )

  test 'Pretty printing', ->
    xml('root')
      .dtd('hello.dtd')
          .ins('pub_border', 'thin')
          .ele('img', 'EMPTY')
          .com('Image attributes follow')
          .att('img', 'height', 'CDATA', '#REQUIRED')
          .att('img', 'visible', '(yes|no)', '#DEFAULT', "yes")
          .not('fs', { sysID: 'http://my.fs.com/reader' })
          .not('fs-nt', { pubID: 'FS Network Reader 1.0' })
          .not('fs-nt', { pubID: 'FS Network Reader 1.0', sysID: 'http://my.fs.com/reader' })
          .att('img', 'src', 'NOTATION (fs|fs-nt)', '#REQUIRED')
          .dat('<owner>John</owner>')
          .ele('node')
          .ent('ent', 'my val')
          .ent('ent', { sysID: 'http://www.myspec.com/ent' })
          .ent('ent', { pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent' })
          .ent('ent', { sysID: 'http://www.myspec.com/ent', nData: 'entprg' })
          .ent('ent', { pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent', nData: 'entprg' })
          .pent('ent', 'my val')
          .pent('ent', { sysID: 'http://www.myspec.com/ent' })
          .pent('ent', { pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent' })
          .ele('nodearr', ['a', 'b'])
      .root()
      .ele('xmlbuilder', {'for': 'node-js' })
          .com('CoffeeScript is awesome.')
          .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
            .ins('target', 'val')
          .up()
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
          .up()
      .ele('empty')
      .end(builder.streamWriter(process.stdout, { pretty: true, allowEmpty: true, indent: '    ' } ))

    eq(
      hook.captured()

      """
      <?xml version="1.0"?>
      <!DOCTYPE root SYSTEM "hello.dtd" [
          <?pub_border thin?>
          <!ELEMENT img EMPTY>
          <!-- Image attributes follow -->
          <!ATTLIST img height CDATA #REQUIRED>
          <!ATTLIST img visible (yes|no) "yes">
          <!NOTATION fs SYSTEM "http://my.fs.com/reader">
          <!NOTATION fs-nt PUBLIC "FS Network Reader 1.0">
          <!NOTATION fs-nt PUBLIC "FS Network Reader 1.0" "http://my.fs.com/reader">
          <!ATTLIST img src NOTATION (fs|fs-nt) #REQUIRED>
          <![CDATA[<owner>John</owner>]]>
          <!ELEMENT node (#PCDATA)>
          <!ENTITY ent "my val">
          <!ENTITY ent SYSTEM "http://www.myspec.com/ent">
          <!ENTITY ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent">
          <!ENTITY ent SYSTEM "http://www.myspec.com/ent" NDATA entprg>
          <!ENTITY ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent" NDATA entprg>
          <!ENTITY % ent "my val">
          <!ENTITY % ent SYSTEM "http://www.myspec.com/ent">
          <!ENTITY % ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent">
          <!ELEMENT nodearr (a,b)>
      ]>
      <root>
          <xmlbuilder for="node-js">
              <!-- CoffeeScript is awesome. -->
              <repo type="git">
                  git://github.com/oozcitak/xmlbuilder-js.git
                  <?target val?>
              </repo>
          </xmlbuilder>
          <cdata>
              <![CDATA[<test att="val">this is a test</test>
      Second line]]>
          </cdata>
          <raw>&<>&</raw>
          <atttest att="val">text</atttest>
          <atttest att="val">text</atttest>
          <empty></empty>
      </root>
      """
    )

  test 'Pretty printing with offset', ->
    xml('root')
      .ele('xmlbuilder', {'for': 'node-js' })
          .com('CoffeeScript is awesome.')
          .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
          .up()
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
      .end(builder.streamWriter(process.stdout).set( { pretty: true, indent: '    ', offset : 1 } ))

    eq(
      hook.captured()

      """
        TEMPORARY_INDENT
            <?xml version="1.0"?>
            <root>
                <xmlbuilder for="node-js">
                    <!-- CoffeeScript is awesome. -->
                    <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
                </xmlbuilder>
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
    xml('root')
      .ele('xmlbuilder', {'for': 'node-js' })
          .com('CoffeeScript is awesome.')
          .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
          .up()
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
      .root()
      .commentBefore('pre').commentAfter('post')
      .instructionBefore('pre' ,'val1').instructionAfter('post', 'val2')
      .end(builder.streamWriter(process.stdout, { pretty: true, indent: '' } ))

    eq(
      hook.captured()

      """
      <?xml version="1.0"?>
      <!-- pre -->
      <?pre val1?>
      <root>
      <xmlbuilder for="node-js">
      <!-- CoffeeScript is awesome. -->
      <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
      </xmlbuilder>
      <cdata>
      <![CDATA[<test att="val">this is a test</test>
      Second line]]>
      </cdata>
      <raw>&<>&</raw>
      <atttest att="val">text</atttest>
      <atttest att="val">text</atttest>
      </root>
      <?post val2?>
      <!-- post -->
      """
    )

  test 'Throw with unknown node types', ->
    err(
      () ->
        root = xml('test4')
        root.children.push(new String("Invalid node"))
        root.end(builder.streamWriter(process.stdout))
      /Unknown XML node type: String/
    )
    err(
      () ->
        dtd = xml('test4').dtd()
        dtd.children.push(new String("Invalid DTD node"))
        dtd.end(builder.streamWriter(process.stdout))
      /Unknown DTD node type: String/
    )
