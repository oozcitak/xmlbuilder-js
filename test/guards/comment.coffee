suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').com()
      /Missing comment text/
    )

