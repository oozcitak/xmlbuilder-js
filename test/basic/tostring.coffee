suite 'Test toString() function with built-in XML writer:', ->
  test 'Nodes', ->
    eq xml('root').doc().toString(), '<?xml version="1.0"?><root/>'
    eq xml('root').toString(), '<root/>'
    eq xml('root').att('att', 'val').attributes['att'].toString(), ' att="val"'
    eq xml('root').dat('val').children[0].toString(), '<![CDATA[val]]>'
    eq xml('root').com('val').children[0].toString(), '<!-- val -->'
    eq xml('root').ins('target', 'val').children[0].toString(), '<?target val?>'
    eq xml('root').raw('val').children[0].toString(), 'val'
    eq xml('root').text('val').children[0].toString(), 'val'

  test 'DTD', ->
    eq(
      xml('root').dtd({pubID: 'pub', sysID: 'sys'}).toString()
      '<!DOCTYPE root PUBLIC "pub" "sys">'
    )
    eq(
      xml('root').dtd().att('img', 'visible', '(yes|no)', '#DEFAULT', "yes").children[0].toString()
      '<!ATTLIST img visible (yes|no) "yes">'
    )
    eq(
      xml('root').dtd().ele('img', 'EMPTY').children[0].toString()
      '<!ELEMENT img EMPTY>'
    )
    eq(
      xml('root').dtd().ent('ent', 'my val').children[0].toString()
      '<!ENTITY ent "my val">'
    )
    eq(
      xml('root').dtd().not('fs', { sysID: 'http://my.fs.com/reader' }).children[0].toString()
      '<!NOTATION fs SYSTEM "http://my.fs.com/reader">'
    )

  test 'XML Declaration', ->
    eq(
      xml('root').dec().doc().children[0].toString()
      '<?xml version="1.0"?>'
    )
