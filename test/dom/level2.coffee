suite 'DOM Level 2:', ->
  test 'DOMImplementation', ->
    ok( builder.implementation.hasFeature "Core", "2.0" )
    ok( builder.implementation.hasFeature "XML", "2.0" )

  test 'Attr', ->
    node = xml('root')
    node.att('att1', 'val1')

    eq( node.attributes.item(0).ownerElement.nodeName, 'root' )

  test 'Node', ->
    node = xml('root').ele('node')
    node.att('att1', 'val1').att('att2', 'val2')
    node.ele('child1').up().ele('child2').up().ele('child3')
    child = node.children[1]

    ok( node.isSupported("XML", "2.0") )
    eq( node.hasAttributes(), true )
    eq( node.namespaceURI, '' )
    eq( node.prefix, '' )
    eq( node.localName, 'node' )

  test 'Element', ->
    node = xml('root')
    node.att('att1', 'val1')

    eq( node.tagName, 'root' )
    eq( node.hasAttribute('att1'), true )

  test 'DocumentType', ->
    dtd = xml('root').dtd('pub', 'sys')

    eq( dtd.publicId, 'pub' )
    eq( dtd.systemId, 'sys' )
