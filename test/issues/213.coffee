suite 'Tests specific to issues:', ->
  test 'Issue #213: importDocument created from begin()', ->
    boldDoc = xml('b').text('Hello World')
    doc = doc().importDocument(boldDoc)
    main = xml({ headless: true }, 'p').importDocument(doc)

    eq(
      main.end()
      '<p><b>Hello World</b></p>'
    )

