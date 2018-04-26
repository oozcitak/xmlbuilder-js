suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').ins()
      Error
      "Missing instruction target. parent: <test>"
    )

