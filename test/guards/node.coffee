suite 'Node Guards:', ->
  test 'Invalid operations', ->
    testCases = [
      () -> xml('test').insertBefore()
      () -> xml('test').insertAfter()
      () -> xml('test').remove()
      () -> xml('test').up()
      () -> xml('test').ele('first').prev()
      () -> xml('test').ele('first').up().ele('last').next()
      () -> xml('root').ele([])
    ]

    results = [
      "Cannot insert elements at root level. parent: <?xml>"
      "Cannot insert elements at root level. parent: <?xml>"
      "Cannot remove the root element. parent: <?xml>"
      "The root node has no parent. Use doc() if you need to get the document object."
      "Already at the first node. parent: <?xml>"
      "Already at the last node. parent: <?xml>"
      "Could not create any elements with: . parent: <?xml>"
    ]

    err(
      testCases[i]
      Error
      results[i]
    ) for i in [0..testCases.length-1]

