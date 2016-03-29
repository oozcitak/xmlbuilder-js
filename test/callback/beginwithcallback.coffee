suite 'Creating XML using begin() callbacks:', ->
  test 'Long form', ->

    result = ''
    data = (chunk) ->
      result += chunk

    doc(data)
      .dec()
      .dtd('root', 'hello.dtd')
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
      .up()
      .ele('root')
        .ele('xmlbuilder', {'for': 'node-js' })
          .com('CoffeeScript is awesome.')
          .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git').up()
          .nod('repo', 'git://github.com/oozcitak/xmlbuilder-js.git', {'type': 'git'}).up()
        .up()
        .ele('cdata')
          .att('att', 'val')
          .dat('<test att="val">this is a test</test>\nSecond line')
          .txt('text node')
          .ins('target', 'value')
        .up()
        .ele('raw')
          .raw('&<>&')
          .up()
        .ele('atttest', { 'att': 'val' }, 'text')
        .end()

    eq(
      result

      '<?xml version="1.0"?>' +
      '<!DOCTYPE root SYSTEM "hello.dtd" [' +
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
              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
          '</xmlbuilder>' +
          '<cdata att="val">' +
              '<![CDATA[<test att="val">this is a test</test>\nSecond line]]>' +
              'text node' +
              '<?target value?>' +
          '</cdata>' +
          '<raw>&<>&</raw>' +
          '<atttest att="val">text</atttest>' +
      '</root>'
    )

  test 'Short form', ->

    result = ''
    data = (chunk) ->
      result += chunk

    doc(data)
      .dec()
      .dtd('root', 'hello.dtd')
        .ins('pub_border', 'thin')
        .ele('img', 'EMPTY')
        .com('Image attributes follow')
        .a('img', 'height', 'CDATA', '#REQUIRED')
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
      .up()
      .e('root')
        .e('xmlbuilder', {'for': 'node-js' })
          .c('CoffeeScript is awesome.')
          .n('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
          .up()
        .up()
        .e('cdata')
          .a('att', 'val')
          .d('<test att="val">this is a test</test>\nSecond line')
          .t('text node')
          .i('target', 'value')
        .up()
        .e('raw')
          .r('&<>&')
          .up()
        .e('atttest', { 'att': 'val' }, 'text')
        .end()

    eq(
      result

      '<?xml version="1.0"?>' +
      '<!DOCTYPE root SYSTEM "hello.dtd" [' +
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
          '<cdata att="val">' +
              '<![CDATA[<test att="val">this is a test</test>\nSecond line]]>' +
              'text node' +
              '<?target value?>' +
          '</cdata>' +
          '<raw>&<>&</raw>' +
          '<atttest att="val">text</atttest>' +
      '</root>'
    )

  test 'Test public DTD', ->

    result = ''
    data = (chunk) ->
      result += chunk

    doc(data)
      .dtd('root', 'hello.dtd', 'value')
      .up()
      .ele('root')
      .end()

    eq(
      result

      '<!DOCTYPE root PUBLIC "hello.dtd" "value">' +
      '<root/>'
    )

  test 'Pretty printing', ->

    result = ''
    data = (chunk) ->
      result += chunk

    doc({ writer: { pretty: true, indent: '    ' } }, data)
      .dec()
      .ele('root')
        .ele('node')
      .end()

    eq(
      result

      """
      <?xml version="1.0"?>
      <root>
          <node/>
      </root>

      """
    )
