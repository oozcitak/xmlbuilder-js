suite 'DTDAttList Guards:', ->
  test 'constructor', ->
    testCases = [
      () -> xml('test').dtd().att()
      () -> xml('test').dtd().att('ele')
      () -> xml('test').dtd().att('ele', 'att')
      () -> xml('test').dtd().att('ele', 'att', 'type')
      () -> xml('test').dtd().att('ele', 'att', 'type', 'INVALID')
      () -> xml('test').dtd().att('ele', 'att', 'type', 'REQUIRED', 'def')
    ]

    results = [
      "Missing DTD element name. parent: <test>"
      "Missing DTD attribute name. node: <ele>, parent: <test>"
      "Missing DTD attribute type. node: <ele>, parent: <test>"
      "Missing DTD attribute default. node: <ele>, parent: <test>"
      "Invalid default value type; expected: #REQUIRED, #IMPLIED, #FIXED or #DEFAULT. node: <ele>, parent: <test>"
      "Default value only applies to #FIXED or #DEFAULT. node: <ele>, parent: <test>"
    ]

    err(
      testCases[i]
      Error
      results[i]
    ) for i in [0..testCases.length-1]

