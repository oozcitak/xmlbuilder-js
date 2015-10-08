xmloriginal = xml('test', { headless: true})
  .att('att', 'val')
  .ele('nodes')
    .ele('node', '1').up()
    .ele('node', '2')
      .att('att2', 'val2')
  .root()

xmlcloned = xmloriginal.root().clone()
xmlcloned.ele('added', '3')

suite 'Clone:', ->
  test 'Original should remain unchanged', ->
    eq(
      xmloriginal.end()
      '<test att="val"><nodes><node>1</node><node att2="val2">2</node></nodes></test>'
    )

  test 'Cloned should contain all nodes including added node', ->
    eq(
      xmlcloned.toString()
      '<test att="val"><nodes><node>1</node><node att2="val2">2</node></nodes><added>3</added></test>'
    )

  test 'Clone each node type', ->
    org = xml('test', { headless: true})
      .cdata('val1')
      .raw('val2')
      .ele('node')
        .ins('pi', 'target')
        .com('comment')
    eq(
      org.root().clone().toString()
      '<test><![CDATA[val1]]>val2<?pi target?><node><!-- comment --></node></test>'
    )

