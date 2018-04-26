suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').raw()
      Error
      "Missing raw text. parent: <test>"
    )

