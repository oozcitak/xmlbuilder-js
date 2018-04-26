suite 'begin() Guards:', ->
  test 'constructor', ->
    err(
      () -> xml()
      Error
      "Root element needs a name."
    )

