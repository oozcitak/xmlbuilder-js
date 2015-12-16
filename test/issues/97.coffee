obj =
  root:
    '@att': 'attribute value with &num; and &#35;'
    '#text': 'HTML entities for umlaut are &uuml; and &#252;.'

suite 'Tests specific to issues:', ->
  test 'Issue #97 (No double encoding)', ->
    eq(
      xml(obj, { noDoubleEncoding: true }).end()
      '<?xml version="1.0"?>' +
      '<root att="attribute value with &num; and &#35;">' +
        'HTML entities for umlaut are &uuml; and &#252;.' +
      '</root>'
    )

  test 'Issue #97 (Double encoding - default behavior)', ->
    eq(
      xml(obj).end()
      '<?xml version="1.0"?>' +
      '<root att="attribute value with &amp;num; and &amp;#35;">' +
        'HTML entities for umlaut are &amp;uuml; and &amp;#252;.' +
      '</root>'
    )

