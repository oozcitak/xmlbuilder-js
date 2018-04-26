suite 'Comment Guards:', ->
  test 'constructor', ->
    err(
      () -> xml('test').com()
      Error
      "Missing comment text. parent: <test>"
    )

