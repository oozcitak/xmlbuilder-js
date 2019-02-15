suite 'DOM Level 3:', ->
  test 'DOMImplementation', ->
    ok( builder.implementation.hasFeature "XML", "3.0" )

  test 'Document', ->
    node = xml('root', { version: '1.1', encoding: 'UTF-8', standalone: true })

    eq( node.doc().xmlEncoding, 'UTF-8' )
    eq( node.doc().xmlVersion, '1.1' )
    eq( node.doc().xmlStandalone, true )

  test 'Node', ->
    node = xml('root').ele('node').txt('text1').txt('text2')

    eq( node.textContent, 'text1text2' )

  test 'Text', ->
    node = xml('root').ele('node').txt('text1').txt('text2')

    eq( node.children[0].wholeText, 'text1text2' )
