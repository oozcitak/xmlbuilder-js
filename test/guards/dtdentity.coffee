suite 'DTDEntity Guards:', ->
  test 'constructor', ->
    testCases = [
      () -> xml('test').dtd().ent()
      () -> xml('test').dtd().ent('name')
      () -> xml('test').dtd().ent('name', { invalid: "obj" })
      () -> xml('test').dtd().ent('name', { pubID: "obj" })
      () -> xml('test').dtd().pent('name', { sysID: "obj", nData: "val" })
    ]

    results = [
      "Missing DTD entity name. parent: <!DOCTYPE>"
      "Missing DTD entity value. node: <name>, parent: <!DOCTYPE>"
      "Public and/or system identifiers are required for an external entity. node: <name>, parent: <!DOCTYPE>"
      "System identifier is required for a public external entity. node: <name>, parent: <!DOCTYPE>"
      "Notation declaration is not allowed in a parameter entity. node: <name>, parent: <!DOCTYPE>"
    ]

    err(
      testCases[i]
      Error
      results[i]
    ) for i in [0..testCases.length-1]

