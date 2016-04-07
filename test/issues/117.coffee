suite 'Tests specific to issues:', ->
  test 'Issue #117 (0 as element value)', ->
    eq(
      xml('root').ele('test', 0).end()
      '<?xml version="1.0"?><root><test>0</test></root>'
    )

