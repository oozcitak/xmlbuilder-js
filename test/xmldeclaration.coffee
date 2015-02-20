suite 'XML Declaration:', ->
  test 'From create() without arguments', ->
    eq(
      xml('test').end()
      '<?xml version="1.0"?><test/>'
    )

  test 'From create() with arguments', ->
    eq(
      xml('test', { version: '1.1', encoding: 'UTF-8', standalone: true }).end()
      '<?xml version="1.1" encoding="UTF-8" standalone="yes"?><test/>'
    )
    
  test 'From dec() without arguments', ->
    eq(
      xml('test', { headless: true }).dec().ele('node').end()
      '<?xml version="1.0"?><test><node/></test>'
    )

  test 'From dec() with arguments', ->
    eq(
      xml('test').dec({ version: '1.1', encoding: 'UTF-8', standalone: true }).ele('node').end()
      '<?xml version="1.1" encoding="UTF-8" standalone="yes"?><test><node/></test>'
    )

