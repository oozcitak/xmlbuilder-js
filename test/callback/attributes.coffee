suite 'Attributes:', ->

  result = ''
  data = (chunk) ->
    result += chunk

  doc(data)
    .node('test4')
      .ele('node', {"first":"1", "second":"2"})
        .att("third", "3")
      .up()
      .ele('node').att({"first":"1", "second":"2"}).up()
    .up()
    .end()

  test 'All forms of att() usage', ->
    eq(
      result

      '<test4>' +
        '<node first="1" second="2" third="3"/>' +
        '<node first="1" second="2"/>' +
      '</test4>'
    )

