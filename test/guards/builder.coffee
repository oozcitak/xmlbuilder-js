suite 'CDATA Guards:', ->
  test 'constructor', ->
    err(
      () -> xml()
      /Root element needs a name/
    )

