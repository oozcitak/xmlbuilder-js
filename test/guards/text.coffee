suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').txt()
      /Missing element text/
    )

