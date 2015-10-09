suite 'DTDNotation Guards:', ->
  test 'constructor', ->
    testCases = [
      () -> xml('test').dtd().not()
      () -> xml('test').dtd().not('name', { invalid: "obj" })
    ]

    results = [
      /Missing notation name/
      /Public or system identifiers are required for an external entity/
    ]

    err(
      testCases[i]
      results[i]
    ) for i in [0..testCases.length-1]

