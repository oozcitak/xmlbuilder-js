suite 'attribute() Guards:', ->
  test 'Throw if null attribute (ele)', ->
    err(
      () -> xml('test4', { headless: true }).ele('node', 'element', {"first": null, "second":"2"})
      Error
      "Missing attribute value. attribute: {first}, parent: <node>"
    )

  test 'Throw if null attribute (att)', ->
    err(
      () -> xml('test4', { headless: true }).ele('node').att("first")
      Error
      "Missing attribute value. attribute: {first}, parent: <node>"
    )

  test 'Throw if null attribute name (att)', ->
    err(
      () -> xml('test4', { headless: true }).ele('node').att(null, "first")
      Error
      "Missing attribute name. parent: <node>"
    )

  test 'Throw if null attribute value (att)', ->
    err(
      () -> xml('test4', { headless: true }).ele('node').att("first", null)
      Error
      "Missing attribute value. attribute: {first}, parent: <node>"
    )

  test 'Throw if null attribute (JSON)', ->
    err(
      () -> xml('test4', { headless: true }).ele({'@first': null})
      Error
      "Missing attribute value. attribute: {first}, parent: <test4>"
    )
