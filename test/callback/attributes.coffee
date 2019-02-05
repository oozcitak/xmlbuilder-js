suite 'Attributes:', ->

  result = ''
  data = (chunk, level) ->
    result += chunk

  test 'All forms of att() usage', ->
    result = ''
    doc(data)
      .node('test4')
        .ele('node', {"first":"1", "second":"2"})
          .att("third", "3")
        .up()
        .ele('node').att({"first":"1", "second":"2"}).up()
      .up()
      .end()
  
      eq(
        result
  
        '<test4>' +
          '<node first="1" second="2" third="3"/>' +
          '<node first="1" second="2"/>' +
        '</test4>'
      )

  test 'Skip null attributes', ->
    result = ''
    doc(data)
      .node('test')
        .ele('node', {"first": null})
          .att("third", null)
        .up()
        .ele('node').att({"first": null}).up()
      .up()
      .end()

    eq(
      result

      '<test>' +
        '<node/>' +
        '<node/>' +
      '</test>'
    )

  test 'Keep null attributes', ->
    result = ''
    doc({ keepNullAttributes: true }, data)
      .node('test')
        .ele('node', {"first": null})
          .att("second", null)
        .up()
        .ele('node').att({"first": null}).up()
      .up()
      .end()

    eq(
      result

      '<test>' +
        '<node first="" second=""/>' +
        '<node first=""/>' +
      '</test>'
    )
