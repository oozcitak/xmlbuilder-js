suite 'begin() with callbacks Guards:', ->
  test 'node', ->
    testCases = [
      () -> doc(() ->).node()
      () -> doc(() ->).node('root1').up().node('root2')
      () -> doc(() ->).node('root').ele('node').up().att('att', 'val')
      () -> doc(() ->).node('root').dec()
      () -> doc(() ->).dtd()
      () -> doc(() ->).node('root').dtd('root')
      () -> doc(() ->).node('root').up().up()
    ]

    results = [
      "Missing node name."
      "Document can only have one root node. node: <root2>"
      "att() can only be used immediately after an ele() call in callback mode. node: <att>"
      "declaration() must be the first node."
      "Missing root node name."
      "dtd() must come before the root node."
      "The document node has no parent."
    ]

    err(
      testCases[i]
      Error
      results[i]
    ) for i in [0..testCases.length-1]
