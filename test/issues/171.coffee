suite 'Tests specific to issues:', ->
  test 'Inline elements within Text Decorator throws error. Issue 171', ->
    obj = {
      pc: {
        '#text': [
          'Hello ',
          { mrk: { '#text': 'World', '@id': 'm1', '@type': 'term' } },
          '!',
        ],
        '@id': 1,
      },
    }

    eq(
      xml(obj, { headless: true }).end()

      '<pc id="1">' +
        'Hello ' +
        '<mrk id="m1" type="term">World</mrk>' +
        '!' +
      '</pc>'
    )

  test 'Nested mixed-content', ->
    obj = {
      pc: {
        '#text': [
          'Hello ',
          { nested: { nestedagain: { '#text': 'World' }, '#text': '!' } }
          '!',
        ],
        '@id': 1,
      },
    }

    eq(
      xml(obj, { headless: true }).end()

      '<pc id="1">' +
        'Hello ' +
        '<nested><nestedagain>World</nestedagain>!</nested>' +
        '!' +
      '</pc>'
    )