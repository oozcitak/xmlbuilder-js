suite 'Implicit Conversion to Primitives:', ->
  test 'String', ->
    eq(
      xml('test', {}, {}, { headless: true })
        .ele('node', 'hello')
        .nod('node', 'hello')
        .ins('node', 'hello')
        .end()
      xml('test', {}, {}, { headless: true })
        .ele('node', new String('hello'))
        .nod('node', new String('hello'))
        .ins('node', new String('hello'))
        .end()
    )

  test 'Boolean', ->
    eq(
      xml('test', {}, {}, { headless: true })
        .ele('node', true)
        .end()
      xml('test', {}, {}, { headless: true })
        .ele('node', new Boolean(true))
        .end()
    )

  test 'Number', ->
    eq(
      xml('test', {}, {}, { headless: true })
        .ele('node', 123)
        .end()
      xml('test', {}, {}, { headless: true })
        .ele('node', new Number(123))
        .end()
    )

