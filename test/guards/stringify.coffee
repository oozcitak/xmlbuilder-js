suite 'Stringify Guards:', ->
  test 'defaults', ->
    testCases = [
      () -> xml('test', { headless: true}).dat(']]>')
      () -> xml('test', { headless: true}).com('--')
      () -> xml('test', { headless: true}).ins('pi', '?>')
      () -> xml('test', { encoding: "A#" })
    ]

    results = [
      /Invalid CDATA text: ]]>/
      /Comment text cannot contain double-hypen: --/
      /Invalid processing instruction value: \?>/
      /Invalid encoding: A#/
    ]

    err(
      testCases[i]
      results[i]
    ) for i in [0..testCases.length-1]

