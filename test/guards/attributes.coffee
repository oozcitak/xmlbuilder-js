suite 'attribute() Guards:', ->
  test 'Throw if null attribute (att)', ->
    err(
      () -> xml('test4', { headless: true }).ele('node').att(null, '')
      Error
      "Missing attribute name. parent: <node>"
    )
