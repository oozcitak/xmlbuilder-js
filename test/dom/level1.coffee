suite 'DOM Level 1:', ->
  test 'DOMImplementation', ->
    ok( builder.implementation.hasFeature "XML", "1.0" )

  test 'Document', ->
    doc = xml('root').dtd('pubID', 'sysID').doc()

    eq( doc.doctype.type, builder.nodeType.DocType )
    ok( doc.implementation.hasFeature "XML", "1.0" )
    eq( doc.documentElement.type, builder.nodeType.Element )
    eq( doc.documentElement.nodeName, 'root' )

  test 'Node Types', ->
    # we check integer values here to ensure
    # strict compliance with the spec
    eq( xml('root').nodeType, 1 ) # Element : 1
    eq( xml('root').att('att', 'val').attribs['att'].nodeType, 2 ) # Attribute : 2
    eq( xml('root').txt('text').children[0].nodeType, 3 ) # Text : 3
    eq( xml('root').dat('text').children[0].nodeType, 4 ) # CData : 4
    # EntityReference : 5
    eq( xml('root').dtd().ent('text', 'val').children[0].nodeType, 6 ) # EntityDeclaration : 6
    eq( xml('root').dtd().pent('text', 'val').children[0].nodeType, 6 ) # EntityDeclaration : 6
    eq( xml('root').ins('text').children[0].nodeType, 7 ) # ProcessingInstruction : 7
    eq( xml('root').com('text').children[0].nodeType, 8 ) # Comment : 8
    eq( xml('root').doc().nodeType, 9 ) # Document : 9
    eq( xml('root').dtd().nodeType, 10 ) # DocType : 10
    # DocumentFragment : 11
    eq( xml('root').dtd().not('text', { pubID: 'test' } ).children[0].nodeType, 12 ) # NotationDeclaration : 12
    eq( xml('root').doc().children[0].nodeType, 201 ) # Declaration : 201
    eq( xml('root').raw('text').children[0].nodeType, 202 ) # Raw : 202
    eq( xml('root').dtd().att('img', 'src', 'NOTATION (fs|fs-nt)', '#REQUIRED').children[0].nodeType, 203 ) # AttributeDeclaration : 203
    eq( xml('root').dtd().ele('text').children[0].nodeType, 204 ) # ElementDeclaration : 204
    # Dummy : 205

  test 'Node', ->
    node = xml('root').ele('node')
    node.att('att1', 'val1').att('att2', 'val2')
    node.ele('child1').up().ele('child2').up().ele('child3')
    child = node.children[1]

    eq( node.nodeName, 'node' )
    eq( node.nodeType, builder.nodeType.Element )
    eq( node.parentNode.nodeName, 'root' )
    eq( node.childNodes.length, 3 )
    eq( node.childNodes.item(0).nodeName, 'child1' )
    eq( node.childNodes.item(1).nodeName, 'child2' )
    eq( node.firstChild.nodeName, 'child1' )
    eq( node.lastChild.nodeName, 'child3' )
    eq( child.previousSibling.nodeName, 'child1' )
    eq( child.nextSibling.nodeName, 'child3' )
    eq( child.previousSibling.previousSibling, null )
    eq( child.nextSibling.nextSibling, null )
    eq( node.attributes.length, 2 )
    eq( node.attributes.item(0).name, 'att1' )
    eq( node.attributes.item(1).value, 'val2' )
    eq( node.ownerDocument.type, builder.nodeType.Document )

  test 'NodeList', ->
    node = xml('root')
    node.ele('child1').up().ele('child2').up().ele('child3')

    eq( node.childNodes.length, 3 )
    eq( node.childNodes.item(0).nodeName, 'child1' )
    eq( node.childNodes.item(1).nodeName, 'child2' )
    eq( node.childNodes.item(2).nodeName, 'child3' )
    eq( node.childNodes.item(3), null )

  test 'NamedNodeMap', ->
    node = xml('root')
    node.att('att1', 'val1').att('att2', 'val2').att('att3', 'val3')

    eq( node.attributes.length, 3 )
    eq( node.attributes.item(0).name, 'att1' )
    eq( node.attributes.item(1).name, 'att2' )
    eq( node.attributes.item(2).name, 'att3' )
    eq( node.attributes.item(0).value, 'val1' )
    eq( node.attributes.item(1).value, 'val2' )
    eq( node.attributes.item(2).value, 'val3' )
    eq( node.attributes.item(3), null )

  test 'CharacterData', ->
    node = xml('root').txt('text').children[0]

    eq( node.data, 'text' )
    eq( node.length, 4 )

  test 'Attr', ->
    node = xml('root')
    node.att('att1', 'val1')

    eq( node.attributes.item(0).name, 'att1' )
    eq( node.attributes.item(0).value, 'val1' )
    eq( node.attributes.item(0).specified, true )

  test 'Element', ->
    node = xml('root')

    eq( node.tagName, 'root' )

  test 'DocumentType', ->
    dtd = xml('root').dtd()
      .ent('text1', 'val1')
      .pent('text2', 'val2')
      .not('text1', { pubID: 'test1' } )
      .not('text2', { sysID: 'test2' } )
      .not('text3', { sysID: 'test3' } )

    eq( dtd.name, 'root' )
    eq( dtd.entities.length, 1 )
    eq( dtd.entities.item(0).nodeType, builder.nodeType.EntityDeclaration )
    eq( dtd.entities.item(0).nodeName, 'text1' )
    eq( dtd.entities.item(1), null )
    eq( dtd.notations.length, 3 )
    eq( dtd.notations.item(0).nodeType, builder.nodeType.NotationDeclaration )
    eq( dtd.notations.item(0).nodeName, 'text1' )
    eq( dtd.notations.item(1).nodeType, builder.nodeType.NotationDeclaration )
    eq( dtd.notations.item(1).nodeName, 'text2' )
    eq( dtd.notations.item(3), null )

  test 'Notation', ->
    node = xml('root').dtd().not('text1', { pubID: 'pub', sysID: 'sys' } ).children[0]
    eq( node.nodeType, builder.nodeType.NotationDeclaration )
    eq( node.publicId, 'pub' )
    eq( node.systemId, 'sys' )

  test 'Entity', ->
    ent = xml('root').dtd().ent('ent', { pubID: 'pub', sysID: 'sys', nData: 'entprg' }).children[0]
    pent = xml('root').dtd().pent('ent', { pubID: 'pub', sysID: 'sys' }).children[0]
    eq( ent.nodeType, builder.nodeType.EntityDeclaration )
    eq( ent.publicId, 'pub' )
    eq( ent.systemId, 'sys' )
    eq( ent.notationName, 'entprg' )
    eq( pent.nodeType, builder.nodeType.EntityDeclaration )
    eq( pent.publicId, 'pub' )
    eq( pent.systemId, 'sys' )
    eq( pent.notationName, null )

  test 'ProcessingInstruction', ->
    node = xml('root').ins('target', 'value').children[0]

    eq( node.target, 'target' )
    eq( node.data, 'value' )
