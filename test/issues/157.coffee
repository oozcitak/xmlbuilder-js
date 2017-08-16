suite 'Creating XML with string writer:', ->
  test 'Plain text writer', ->
    eq(
      xml('root')
        .dtd('hello.dtd')
            .ins('pub_border', 'thin')
            .ele('img', 'EMPTY')
            .att('img', 'height', 'CDATA', '#REQUIRED')
            .not('fs', { sysID: 'http://my.fs.com/reader' })
            .ent('ent', 'my val')
            .pent('ent', 'my val')
        .root()
        .ins('a', 'b')
        .ele('xmlbuilder')
        .end({ pretty: true, spacebeforeslash: ' ' })

      """
      <?xml version="1.0" ?>
      <!DOCTYPE root SYSTEM "hello.dtd" [
        <?pub_border thin ?>
        <!ELEMENT img EMPTY >
        <!ATTLIST img height CDATA #REQUIRED >
        <!NOTATION fs SYSTEM "http://my.fs.com/reader" >
        <!ENTITY ent "my val" >
        <!ENTITY % ent "my val" >
      ] >
      <root>
        <?a b ?>
        <xmlbuilder />
      </root>
      """
    )

  test 'Fragment', ->
    eq(
      xml('root').toString({ spacebeforeslash: true })

      '<root />'
    )

