suite 'XMLElement Guards:', ->
  test 'constructor and removeAttribute', ->
    testCases = [
      () -> xml('test', { headless: true}).nod()
      () -> xml('test', { headless: true}).ele('node').removeAttribute()
    ]

    results = [
      /Missing element name/
      /Missing attribute name/
    ]

    err(
      testCases[i]
      results[i]
    ) for i in [0..testCases.length-1]

