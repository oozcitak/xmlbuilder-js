suite 'Stringify Guards:', ->
  test 'defaults', ->
    testCases = [
      () -> xml('test').com('--')
      () -> xml('test').ins('pi', '?>')
      () -> xml('test', { encoding: "A#" })
      () -> xml('test', { version: "A.B" })
    ]

    results = [
      /Comment text cannot contain double-hypen: --/
      /Invalid processing instruction value: \?>/
      /Invalid encoding: A#/
      /Invalid version number: A.B/
    ]

    err(
      testCases[i]
      results[i]
    ) for i in [0..testCases.length-1]

