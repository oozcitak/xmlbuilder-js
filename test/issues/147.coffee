suite 'Tests specific to issues:', ->
  test 'Issue #147 (unicode characters)', ->
    eq(
      xml('root').ele('test', '💩💩💩💩').end()
      '<?xml version="1.0"?><root><test>💩💩💩💩</test></root>'
    )

  test 'Issue #147 (invalid character replacement) - 1', ->
    eq(
      xml('root', { invalidCharReplacement: '' }).ele('hello\u0000').txt('\u0001world').end()
      '<?xml version="1.0"?><root><hello>world</hello></root>'
    )

  test 'Issue #147 (invalid character replacement) - 2', ->
    eq(
      xml('root', { invalidCharReplacement: 'x' }).ele('hello\u0000').txt('\u0001world').end()
      '<?xml version="1.0"?><root><hellox>xworld</hellox></root>'
    )
