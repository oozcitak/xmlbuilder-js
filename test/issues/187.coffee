suite 'Tests specific to issues:', ->
  test 'skipNullNodes returning null node as undefined node (JSON): Issue 187', ->

    dataJson = [
      { user: 'barney', age: 36, active: true, city: null },
      { user: 'fred', age: 40, active: false, city: '' },
      { user: 'pebbles', age: 1, active: true, city: 'Dubai' },
    ]

    doc = xml(dataJson, { headless: true, skipNullNodes: true, separateArrayItems: true })

    eq(
      doc.end()
      '<user>barney</user>' +
      '<age>36</age>' +
      '<active>true</active>' +
      '<user>fred</user>' +
      '<age>40</age>' +
      '<active>false</active>' +
      '<city/>' +
      '<user>pebbles</user>' +
      '<age>1</age>' +
      '<active>true</active>' +
      '<city>Dubai</city>'
    )


  test 'skipNullNodes returning null node as undefined node (JSON with root): Issue 187', ->

    dataJson = root: [
      { user: 'barney', age: 36, active: true, city: null },
      { user: 'fred', age: 40, active: false, city: '' },
      { user: 'pebbles', age: 1, active: true, city: 'Dubai' },
    ]

    doc = xml(dataJson, { headless: true, skipNullNodes: true, separateArrayItems: true })

    eq(
      doc.end()
      '<root>' +
        '<user>barney</user>' +
        '<age>36</age>' +
        '<active>true</active>' +
        '<user>fred</user>' +
        '<age>40</age>' +
        '<active>false</active>' +
        '<city/>' +
        '<user>pebbles</user>' +
        '<age>1</age>' +
        '<active>true</active>' +
        '<city>Dubai</city>' +
      '</root>'
    )


  test 'skipNullNodes returning null node as undefined node: Issue 187', ->

    dataJson = [
      { user: 'barney', age: 36, active: true, city: null },
      { user: 'fred', age: 40, active: false, city: '' },
      { user: 'pebbles', age: 1, active: true, city: 'Dubai' },
    ]

    doc = xml('root', { headless: true, skipNullNodes: true, separateArrayItem: true })
      .ele('user', 'barney').up()
      .ele('age', 36).up()
      .ele('active', true).up()
      .ele('city', null).up()
      .ele('user', 'fred').up()
      .ele('age', 40).up()
      .ele('active', false).up()
      .ele('city', '').up()
      .ele('user', 'pebbles').up()
      .ele('age', 1).up()
      .ele('active', true).up()
      .ele('city', 'Dubai').up()

    eq(
      doc.end()
      '<root>' +
        '<user>barney</user>' +
        '<age>36</age>' +
        '<active>true</active>' +
        '<user>fred</user>' +
        '<age>40</age>' +
        '<active>false</active>' +
        '<city/>' +
        '<user>pebbles</user>' +
        '<age>1</age>' +
        '<active>true</active>' +
        '<city>Dubai</city>' +
      '</root>'
    )

