suite 'Check node type:', ->
  test 'Document node types', ->
    obj =
        root:
            '@age': 35
            '#raw': ''
            '#text': ''
            '#cdata': ''
            '#comment': ''
            '?pi': ''

    doc = xml(obj, { sysID: 'hello.dtd' }).doc()
    root = doc.root()
    root.dummy()

    eq(doc.type, builder.nodeType.Document)
    eq(doc.children[0].type, builder.nodeType.Declaration)
    eq(doc.children[1].type, builder.nodeType.DocType)
    eq(root.type, builder.nodeType.Element)
    eq(root.children[0].type, builder.nodeType.Raw)
    eq(root.children[1].type, builder.nodeType.Text)
    eq(root.children[2].type, builder.nodeType.CData)
    eq(root.children[3].type, builder.nodeType.Comment)
    eq(root.children[4].type, builder.nodeType.ProcessingInstruction)
    eq(root.children[5].type, builder.nodeType.Dummy)

  test 'DTD node types', ->
    dtd = xml('root', { headless: true }).dtd()
      .att('img', 'height', 'CDATA', '#REQUIRED')
      .ele('img', 'EMPTY')
      .ent('ent', 'my val')
      .pent('ent', 'my val')
      .not('fs', { sysID: 'http://my.fs.com/reader' })

    eq(dtd.type, builder.nodeType.DocType)
    eq(dtd.children[0].type, builder.nodeType.AttributeDeclaration)
    eq(dtd.children[1].type, builder.nodeType.ElementDeclaration)
    eq(dtd.children[2].type, builder.nodeType.EntityDeclaration)
    eq(dtd.children[3].type, builder.nodeType.EntityDeclaration)
    eq(dtd.children[4].type, builder.nodeType.NotationDeclaration)
