suite 'Tests specific to issues:', ->
  test 'Issue #117 (0 as element value) in create()', ->
    eq(
      xml('root').ele('test', 0).end()
      '<?xml version="1.0"?><root><test>0</test></root>'
    )

  test 'Issue #117 (0 as element value) in begin()', ->
    r = ''
    doc((c) -> r += c).ele('root').ele('test', 0).end()

    eq(
      r
      '<root><test>0</test></root>'
    )

