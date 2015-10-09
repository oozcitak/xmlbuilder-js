suite 'Node Guards:', ->
  test 'Invalid operations', ->
    testCases = [
      () -> xml('test').insertBefore()
      () -> xml('test').insertAfter()
      () -> xml('test').remove()
      () -> xml('test').up()
      () -> xml('test').prev()
      () -> xml('test').next()
      () -> xml('test').ele('first').prev()
      () -> xml('test').ele('first').up().ele('last').next()
      () -> xml('root').ele([])
    ]

    results = [
      /Cannot insert elements at root level/
      /Cannot insert elements at root level/
      /Cannot remove the root element/
      /The root node has no parent\. Use doc\(\) if you need to get the document object\./
      /Root node has no siblings/
      /Root node has no siblings/
      /Already at the first node/
      /Already at the last node/
      /Could not create any elements with: /
    ]

    err(
      testCases[i]
      results[i]
    ) for i in [0..testCases.length-1]

