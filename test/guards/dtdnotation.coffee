suite 'DTDNotation Guards:', ->
  test 'constructor', ->
    testCases = [
      () -> xml('test').dtd().not()
      () -> xml('test').dtd().not('name', { invalid: "obj" })
    ]

    results = [
      "Missing DTD notation name. parent: <!DOCTYPE>"
      "Public or system identifiers are required for an external entity. node: <name>, parent: <!DOCTYPE>"
    ]

    err(
      testCases[i]
      Error
      results[i]
    ) for i in [0..testCases.length-1]

