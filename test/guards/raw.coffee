suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').raw()
      /Missing raw text/
    )

