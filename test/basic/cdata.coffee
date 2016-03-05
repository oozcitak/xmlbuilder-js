suite 'CDATA', ->
  test 'Nested CDATA', ->
    eq(
      xml('test', {}, {}, { headless: true })
        .cdata('foo and <![CDATA[<foo>bar</foo>]]> bar')
      .end()
      '<test><![CDATA[foo and <![CDATA[<foo>bar</foo>]]]]><![CDATA[> bar]]></test>'
    )
