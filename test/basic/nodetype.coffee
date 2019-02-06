NodeType = require '../../src/NodeType'

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

    eq(doc.type, NodeType.Document)
    eq(doc.children[0].type, NodeType.Declaration)
    eq(doc.children[1].type, NodeType.DocType)
    eq(root.type, NodeType.Element)
    eq(root.children[0].type, NodeType.Raw)
    eq(root.children[1].type, NodeType.Text)
    eq(root.children[2].type, NodeType.CData)
    eq(root.children[3].type, NodeType.Comment)
    eq(root.children[4].type, NodeType.ProcessingInstruction)
    eq(root.children[5].type, NodeType.Dummy)

  test 'DTD node types', ->
    dtd = xml('root', { headless: true }).dtd()
      .att('img', 'height', 'CDATA', '#REQUIRED')
      .ele('img', 'EMPTY')
      .ent('ent', 'my val')
      .pent('ent', 'my val')
      .not('fs', { sysID: 'http://my.fs.com/reader' })

    eq(dtd.type, NodeType.DocType)
    eq(dtd.children[0].type, NodeType.AttributeDeclaration)
    eq(dtd.children[1].type, NodeType.ElementDeclaration)
    eq(dtd.children[2].type, NodeType.EntityDeclaration)
    eq(dtd.children[3].type, NodeType.EntityDeclaration)
    eq(dtd.children[4].type, NodeType.NotationDeclaration)
