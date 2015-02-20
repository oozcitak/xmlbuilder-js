stringWithIssues = '\uD841\uDF0E\uD841\uDF0E'

suite 'Surrogate Pairs:', ->
  test 'Should throw if surrogates are used when not allowed', ->
    err(
      () -> xml('test15', {allowSurrogateChars: false}).ele('node').txt(stringWithIssues)
    )

  test 'Should pass if surrogates are used and are allowed', ->
    noterr(
      () -> xml('test16', {allowSurrogateChars: true}).ele('node').txt(stringWithIssues)
    )
