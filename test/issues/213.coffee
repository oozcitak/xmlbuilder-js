suite 'Tests specific to issues:', ->
  test 'Issue #213: importDocument created from begin()', ->
    boldDoc = xml('b').text('Hello World')
    emptyDoc = doc().importDocument(boldDoc)
    main = xml('p', { headless: true }).importDocument(emptyDoc)

    eq(
      main.end()
      '<p><b>Hello World</b></p>'
    )

