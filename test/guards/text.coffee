suite 'Text Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').txt()
      Error
      "Missing element text. parent: <test>"
    )

