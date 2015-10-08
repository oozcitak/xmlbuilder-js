suite 'DTDEntity Guards:', ->
  test 'constructor', ->
    testCases = [
      () -> xml('test', { headless: true}).dtd().ent()
      () -> xml('test', { headless: true}).dtd().ent('name')
      () -> xml('test', { headless: true}).dtd().ent('name', { invalid: "obj" })
      () -> xml('test', { headless: true}).dtd().ent('name', { pubID: "obj" })
      () -> xml('test', { headless: true}).dtd().pent('name', { sysID: "obj", nData: "val" })
    ]

    results = [
      /Missing entity name/
      /Missing entity value/
      /Public and\/or system identifiers are required for an external entity/
      /System identifier is required for a public external entity/
      /Notation declaration is not allowed in a parameter entity/
    ]

    err(
      testCases[i]
      results[i]
    ) for i in [0..testCases.length-1]

