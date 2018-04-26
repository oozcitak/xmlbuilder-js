suite 'DTDElement Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').dtd().ele()
      Error
      "Missing DTD element name. parent: <test>"
    )

