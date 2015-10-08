suite 'DTDElement Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').dtd().ele()
      /Missing DTD element name/
    )

