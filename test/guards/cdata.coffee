suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').cdata()
      /Missing CDATA text/
    )

