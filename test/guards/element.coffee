suite 'XMLElement Guards:', ->
  test 'constructor and removeAttribute', ->
    testCases = [
      () -> xml('test').nod()
      () -> xml('test').ele('node').removeAttribute()
    ]

    results = [
      /Missing element name/
      /Missing attribute name/
    ]

    err(
      testCases[i]
      results[i]
    ) for i in [0..testCases.length-1]

