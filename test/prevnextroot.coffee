suite 'Navigation:', ->
  test 'Prev/next/root', ->
    eq(
      xml('test5', {}, {}, { headless: true })
        .e('node','1')
        .up()
        .e('node','element')
        .up()
        .e('node','2')
        .prev()
        .prev()
        .att('prev','yes')
        .next()
        .next()
        .att('next','yes')
        .root()
        .att('root', 'yes')
        .end()
      '<test5 root="yes"><node prev="yes">1</node><node>element</node><node next="yes">2</node></test5>'
    )
