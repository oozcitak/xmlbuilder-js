suite 'Text Processing', ->
  test 'Nothing gets escaped', ->
    eq(
      xml('comment', {}, {}, { headless: true })
        .comment('<>\'"&\t\n\r').end()
      '<comment><!-- <>\'"&\t\n\r --></comment>'
    )
