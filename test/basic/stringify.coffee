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

  test 'Invalid chars', ->
    err () -> xml('test').node('node with invalid char \u{0000} in node name')
    err () -> xml('test').node('node with invalid char \u{D800} in node name')
    err () -> xml('test').node('node with invalid char \u{DFFF} in node name')
    err () -> xml('test').node('node with invalid char \u{FFFE} in node name')
    err () -> xml('test').node('node with invalid char \u{FFFF} in node name')
    
