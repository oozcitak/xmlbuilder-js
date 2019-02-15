suite 'Tests specific to issues:', ->
  test 'Get node elements by name. Issue 122', ->

    doc = xml('clients')
      .ele('client').att('city', '').up()
      .ele('client').att('city', 'CA').up()
      .ele('client').att('city', 'FL').up()
      .ele('client').up()
      .doc()

    nodes = xpath.select('//client', doc)
    nodes.forEach (node) ->
      node.att("city","NY")

    eq(nodes[0].attributes.item(0).value, "NY")
    eq(nodes[1].attributes.item(0).value, "NY")
    eq(nodes[2].attributes.item(0).value, "NY")
    eq(nodes[3].attributes.item(0).value, "NY")

