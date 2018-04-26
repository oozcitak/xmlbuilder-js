suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').cdata()
      Error
      "Missing CDATA text. parent: <test>"
    )

