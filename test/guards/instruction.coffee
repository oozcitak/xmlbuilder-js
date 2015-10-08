suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').ins()
      /Missing instruction target/
    )

