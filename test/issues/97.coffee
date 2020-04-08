obj =
  root:
    '@att': 'attribute value with &amp; and &#38;'
    '#text': 'XML entities for ampersand are &amp; and &#38;.'

suite 'Tests specific to issues:', ->
  test 'Issue #97 (No double encoding)', ->
    eq(
      xml(obj, { noDoubleEncoding: true }).end()
      '<?xml version="1.0"?>' +
      '<root att="attribute value with &amp; and &amp;#38;">' +
        'XML entities for ampersand are &amp; and &amp;#38;.' +
      '</root>'
    )

  test 'Issue #97 (Double encoding - default behavior)', ->
    eq(
      xml(obj).end()
      '<?xml version="1.0"?>' +
      '<root att="attribute value with &amp;amp; and &amp;#38;">' +
        'XML entities for ampersand are &amp;amp; and &amp;#38;.' +
      '</root>'
    )

