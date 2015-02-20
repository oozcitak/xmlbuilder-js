suite 'Text Processing:', ->
  test 'Escape "', ->
    eq(
      xml('test8', {}, {}, { headless: true }).ele('node', '"').end()
      '<test8><node>"</node></test8>'
    )

  test 'Text node with empty string', ->
    eq(
      xml('test9', {}, {}, { headless: true }).text('').end()
      '<test9/>'
    )
    
  test 'Text node with empty string (pretty print)', ->
    eq(
      xml('test10', {}, {}, { headless: true }).text('').end()
      '<test10/>'
    )
    

