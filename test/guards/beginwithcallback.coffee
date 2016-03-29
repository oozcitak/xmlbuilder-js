suite 'begin() with callbacks Guards:', ->
  test 'node', ->
    err(
      () -> doc(() ->).node()
      /Missing node name/
    )

    err(
      () -> doc(() ->).node('root1').up().node('root2')
      /Document can only have one root node/
    )

  test 'att', ->
    err(
      () -> doc(() ->).node('root').ele('node').up().att('att', 'val')
      /att\(\) can only be used immediately after an ele\(\) call in callback mode/
    )

  test 'att', ->
    err(
      () -> doc(() ->).node('root').dec()
      /declaration\(\) must be the first node/
    )

  test 'doctype', ->
    err(
      () -> doc(() ->).dtd()
      /Missing root node name/
    )

    err(
      () -> doc(() ->).node('root').dtd('root')
      /dtd\(\) must come before the root node/
    )

    err(
      () -> doc(() ->).node('root').up().up()
      /The document node has no parent/
    )
