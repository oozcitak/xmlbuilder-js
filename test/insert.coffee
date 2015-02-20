suite 'Editing:', ->
  test 'Insert', ->
    eq(
      xml('test6', {}, {}, { headless: true })
        .e('node','last')
        .insertBefore('node','1')
        .insertAfter('node','2')
        .end()
      '<test6><node>1</node><node>2</node><node>last</node></test6>'
    )

