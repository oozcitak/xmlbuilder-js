suite 'Element:', ->

  test 'Skip if null (ele)', ->
    eq(
      xml('test', { headless: true })
        .ele('node1', 'val1').up()
        .ele('node2', null).up()
        .ele('node3', undefined).up()
        .ele('node4', 'val4').up()
        .ele('node5', '').up()
        .ele('node6', {att: 'val'}).up()
        .end()
      '<test>' +
        '<node1>val1</node1>' +
        '<node3/>' +
        '<node4>val4</node4>' +
        '<node5/>' +
        '<node6 att="val"/>' +
      '</test>'
    )

  test 'Skip if null (JSON)', ->
    eq(
      xml('test', { headless: true })
        .ele( { node1: 'val1', node2: null, node3: undefined, node4: 'val4', node5: '' })
        .end()
      '<test>' +
        '<node1>val1</node1>' +
        '<node3/>' +
        '<node4>val4</node4>' +
        '<node5/>' +
      '</test>'
    )

  test 'Keep if null (ele) with keepNullNodes', ->
    eq(
      xml('test', { headless: true, keepNullNodes: true })
        .ele('node1', 'val1').up()
        .ele('node2', null).up()
        .ele('node3', undefined).up()
        .ele('node4', 'val4').up()
        .ele('node5', '').up()
        .end()
      '<test>' +
        '<node1>val1</node1>' +
        '<node2/>' +
        '<node3/>' +
        '<node4>val4</node4>' +
        '<node5/>' +
      '</test>'
    )

  test 'Keep if null (JSON) with keepNullNodes', ->
    eq(
      xml('test', { headless: true, keepNullNodes: true })
        .ele( { node1: 'val1', node2: null, node3: undefined, node4: 'val4', node5: '' })
        .end()
      '<test>' +
        '<node1>val1</node1>' +
        '<node2/>' +
        '<node3/>' +
        '<node4>val4</node4>' +
        '<node5/>' +
      '</test>'
    )