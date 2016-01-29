suite 'Stringify:', ->
  test 'Custom function', ->
    addns = (val) -> 'my:' + val
    eq(
      xml('test7', { headless: true, stringify: { eleName: addns } })
        .ele('nodes')
        .ele('node', '1').up()
        .ele('node', '2').up()
        .ele('node', '3')
        .end()
      '<my:test7><my:nodes><my:node>1</my:node><my:node>2</my:node><my:node>3</my:node></my:nodes></my:test7>'
    )

  test 'textCase option', ->
    textCase = 'kebab'
    eq(
      xml('test1000', { headless: true, textCase })
        .ele('nodes', { propA: 'foo', _prop_b_: 'foo' })
        .end()
      '<test-1000><nodes prop-a="foo" prop-b="foo"/></test-1000>'
    )
