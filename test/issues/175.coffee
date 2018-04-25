suite 'Tests specific to issues:', ->
  test 'importDocument overwrites parent declaration: Issue 175', ->

    doc = xml({ factura: {'@id':'comprabante','@version':'2.1.0' }}, {encoding: 'UTF-8'})
      .ele('identificacionComprador', '1303963712')
    doc.ele('node')

    for i in [1..3]
      person = xml('person').att('id', i)
      doc.importDocument(person)
      
    eq(
      doc.end()
      '<?xml version="1.0" encoding="UTF-8"?>' +
      '<factura id="comprabante" version="2.1.0">' +
        '<identificacionComprador>' +
          '1303963712' +
          '<node/>' +
          '<person id="1"/>' +
          '<person id="2"/>' +
          '<person id="3"/>' +
        '</identificacionComprador>' +
      '</factura>'
    )

