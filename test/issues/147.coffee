suite 'Tests specific to issues:', ->
  test 'Issue #147 (unicode characters)', ->
    eq(
      xml('root').ele('test', '💩💩💩💩').end()
      '<?xml version="1.0"?><root><test>💩💩💩💩</test></root>'
    )

