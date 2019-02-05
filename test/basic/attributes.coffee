suite 'Attributes:', ->
  test 'Add attribute (single with object argument)', ->
    eq(
      xml('test4', { headless: true })
        .ele('node', 'element', {"first":"1", "second":"2"})
          .att("third", "3")
        .end()
      '<test4><node first="1" second="2" third="3">element</node></test4>'
    )

  test 'Add attribute (multiple with object argument)', ->
    eq(
      xml('test4', { headless: true })
        .ele('node').att({"first":"1", "second":"2"})
        .end()
      '<test4><node first="1" second="2"/></test4>'
    )

  test 'Remove attribute', ->
    eq(
      xml('test4', { headless: true })
        .ele('node', 'element', {"first":"1", "second":"2", "third":"3"})
          .removeAttribute("second")
        .end()
      '<test4><node first="1" third="3">element</node></test4>'
    )

  test 'Remove multiple attributes', ->
    eq(
      xml('test4', { headless: true })
        .ele('node', 'element', {"first":"1", "second":"2", "third":"3"})
          .removeAttribute(["second", "third"])
        .end()
      '<test4><node first="1">element</node></test4>'
    )

  test 'Skip if null attribute (ele)', ->
    eq(
      xml('test4', { headless: true })
        .ele('node', 'element', {"first": null, "second": '2'})
        .end()
      '<test4><node second="2">element</node></test4>'
    )

  test 'Skip if null attribute (att)', ->
    eq(
      xml('test4', { headless: true })
        .ele('node').att("first")
        .end()
      '<test4><node/></test4>'
    )

  test 'Skip if null attribute (JSON)', ->
    eq(
      xml('test4', { headless: true })
        .ele({'@first': null, '@second': '2'})
        .end()
      '<test4 second="2"/>'
    )

  test 'Keep null attribute (ele)', ->
    eq(
      xml('test4', { headless: true, keepNullAttributes: true })
        .ele('node', 'element', {"first": null, "second": '2'})
        .end()
      '<test4><node first="" second="2">element</node></test4>'
    )

  test 'Keep null attribute (att)', ->
    eq(
      xml('test4', { headless: true, keepNullAttributes: true })
        .ele('node').att("first")
        .end()
      '<test4><node first=""/></test4>'
    )

  test 'Keep null attribute (JSON)', ->
    eq(
      xml('test4', { headless: true, keepNullAttributes: true })
        .ele({'@first': null, '@second': '2'})
        .end()
      '<test4 first="" second="2"/>'
    )