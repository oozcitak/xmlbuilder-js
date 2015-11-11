suite 'Tests specific to issues:', ->
  test 'Issue #96 (Seperate array items)', ->
    obj =
        data:
            article_data: [
                { article: 'somedata' },
                { article: 'somedata' }
            ]

    eq(
      xml(obj, { separateArrayItems: true }).end()
      '<?xml version="1.0"?>' +
      '<data>' +
        '<article_data>' +
          '<article>somedata</article>' +
          '<article>somedata</article>' +
        '</article_data>' +
      '</data>'
    )

