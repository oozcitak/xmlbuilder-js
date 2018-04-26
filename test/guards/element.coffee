suite 'XMLElement Guards:', ->
  test 'constructor and removeAttribute', ->
    testCases = [
      () -> xml('test').nod()
      () -> xml('test').ele('node').removeAttribute()
    ]

    results = [
      "Missing element name. parent: <test>"
      "Missing attribute name. parent: <test>"
    ]

    err(
      testCases[i]
      Error
      results[i]
    ) for i in [0..testCases.length-1]

