suite 'Document Type Declaration:', ->
  test 'SYSTEM dtd from create()', ->
    eq(
      xml('root', { sysID: 'hello.dtd' }).ele('node').txt('test').end()
      '<?xml version="1.0"?><!DOCTYPE root SYSTEM "hello.dtd"><root><node>test</node></root>'
    )

  test 'Public dtd from create()', ->
    eq(
      xml('HTML', {
        pubID: '-//W3C//DTD HTML 4.01//EN'
        sysID: 'http://www.w3.org/TR/html4/strict.dtd'
      }).end()
      '<?xml version="1.0"?>' +
      '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" ' +
                            '"http://www.w3.org/TR/html4/strict.dtd">' +
      '<HTML/>'
    )

  test 'Empty dtd from create()', ->
    eq(
      xml('root', { sysID: '' }).ele('node').txt('test').end()
      '<?xml version="1.0"?><!DOCTYPE root><root><node>test</node></root>'
    )

  test 'Internal and external dtd', ->
    eq(
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
          .ele('node').txt('test')
          .end()

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
      '<root><node>test</node></root>'
    )

  test 'Internal and external dtd (pretty print)', ->
    eq(
      xml('root')
          .dtd('hello.dtd')
              .ins('pub_border', 'thin')
              .ele('img', 'EMPTY')
              .com('Image attributes follow')
              .att('img', 'height', 'CDATA', '#REQUIRED')
              .att('img', 'visible', '(yes|no)', '#DEFAULT', "yes")
              .not('fs', { sysID: 'http://my.fs.com/reader' })
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
          .root()
          .ele('node').txt('test')
          .end({ pretty: true })

      """
      <?xml version="1.0"?>
      <!DOCTYPE root SYSTEM "hello.dtd" [
        <?pub_border thin?>
        <!ELEMENT img EMPTY>
        <!-- Image attributes follow -->
        <!ATTLIST img height CDATA #REQUIRED>
        <!ATTLIST img visible (yes|no) "yes">
        <!NOTATION fs SYSTEM "http://my.fs.com/reader">
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
      ]>
      <root>
        <node>test</node>
      </root>
      """
    )

