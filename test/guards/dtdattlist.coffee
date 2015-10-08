suite 'DTDAttList Guards:', ->
  test 'constructor', ->
    testCases = [
      () -> xml('test', { headless: true}).dtd().att()
      () -> xml('test', { headless: true}).dtd().att('ele')
      () -> xml('test', { headless: true}).dtd().att('ele', 'att')
      () -> xml('test', { headless: true}).dtd().att('ele', 'att', 'type')
      () -> xml('test', { headless: true}).dtd().att('ele', 'att', 'type', 'INVALID')
      () -> xml('test', { headless: true}).dtd().att('ele', 'att', 'type', 'REQUIRED', 'def')
    ]

    results = [
      /Missing DTD element name/
      /Missing DTD attribute name/
      /Missing DTD attribute type/
      /Missing DTD attribute default/
      /Invalid default value type; expected: #REQUIRED, #IMPLIED, #FIXED or #DEFAULT/
      /Default value only applies to #FIXED or #DEFAULT/
    ]

    err(
      testCases[i]
      results[i]
    ) for i in [0..testCases.length-1]

