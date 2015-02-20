suite 'Processing Instructions:', ->
  test 'Simple', ->
    eq(
      xml('test17', { headless: true }).ins('pi', 'mypi').end()
      '<?pi mypi?><test17/>'
    )

  test 'From object', ->
    eq(
      xml('test17', { headless: true }).ins({'pi': 'mypi', 'pi2': 'mypi2', 'pi3': null}).end()
      '<?pi mypi?><?pi2 mypi2?><?pi3?><test17/>'
    )

  test 'From array', ->
    eq(
      xml('test17', { headless: true }).ins(['pi', 'pi2']).end()
      '<?pi?><?pi2?><test17/>'
    )

  test 'Complex', ->
    eq(
      xml('test18', { headless: true })
        .ins('renderCache.subset', '"Verdana" 0 0 ISO-8859-1 4 268 67 "#(),-./')
        .ins('pitarget', () -> 'pivalue')
        .end()
      '<?renderCache.subset "Verdana" 0 0 ISO-8859-1 4 268 67 "#(),-./?><?pitarget pivalue?><test18/>'
    )

