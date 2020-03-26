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

  test 'Issue #147 (invalid character replacement) - 3', ->
    obj =
      root:
        'node\x00': 'text\x08content'

    eq(
      xml(obj, { invalidCharReplacement: (c) -> if c is '\x00' then '' else '_' }).end()
      '<?xml version="1.0"?><root><node>text_content</node></root>'
    )
