suite 'Processing Instructions:', ->

  result = ''
  data = (chunk) ->
    result += chunk

  doc(data)
    .ins('pre' ,'val1')
    .node('test17')
      .ins('pi', 'mypi')
    .  ins({'pi': 'mypi', 'pi2': 'mypi2', 'pi3': null})
      .ins(['pi', 'pi2'])
    .up()
    .ins('post', 'val2')
    .end()

  test 'All forms of ins() usage', ->
    eq(
      result

      '<?pre val1?>' +
      '<test17>' +
        '<?pi mypi?>' +
        '<?pi mypi?><?pi2 mypi2?><?pi3?>' +
        '<?pi?><?pi2?>' +
      '</test17>' +
      '<?post val2?>'
    )


