suite 'XPath:', ->
  test 'Simple XPath usage', ->

    doc = xml('book', { headless: true }).ele('title').txt('Harry Potter').doc()
    nodes = xpath.select("//title", doc)

    eq("title", nodes[0].localName)
    eq("Harry Potter", nodes[0].firstChild.data)
    eq("<title>Harry Potter</title>", nodes[0].toString())
