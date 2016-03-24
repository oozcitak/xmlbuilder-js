suite 'Comments', ->
  test 'Nothing gets escaped', ->
    eq(
      xml('comment', { headless: true })
        .comment('<>\'"&\t\n\r').end()
      '<comment><!-- <>\'"&\t\n\r --></comment>'
    )

  test 'Comments before and after root', ->
    eq(
      xml('comment', { headless: true })
        .commentBefore('pre').commentAfter('post').end()
      '<!-- pre --><comment/><!-- post -->'
    )
