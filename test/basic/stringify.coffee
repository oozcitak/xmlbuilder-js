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
    obj = { '-ele-name': { '@--att-name': 'val' }}
    eq(
      xml(obj, { headless: true, textCase: 'camel' }).end()
      '<eleName attName="val"/>'
    )
    eq(
      xml(obj, { headless: true, textCase: 'kebab' }).end()
      '<ele-name att-name="val"/>'
    )
    eq(
      xml(obj, { headless: true, textCase: 'lower' }).end()
      '<ele-name att-name="val"/>'
    )
    eq(
      xml(obj, { headless: true, textCase: 'upper' }).end()
      '<ELE-NAME ATT-NAME="val"/>'
    )
    eq(
      xml(obj, { headless: true, textCase: 'snake' }).end()
      '<ele_name att_name="val"/>'
    )
    eq(
      xml(obj, { headless: true, textCase: 'title' }).end()
      '<EleName AttName="val"/>'
    )
