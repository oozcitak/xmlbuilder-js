suite 'Tests specific to issues:', ->
  test 'importDocument overwrites parent declaration: Issue 175', ->
    imported = xml('import', { version: "1.0", encoding: "utf-8" })
      .ele('node', 'imported')

    eq(
      xml('test', {version : "1.1", encoding: "de-de"})
        .importDocument(imported)
        .end()
      '<?xml version="1.1" encoding="de-de"?>' +
        '<test>' +
          '<import>' +
            '<node>imported</node>' +
          '</import>' +
        '</test>'
    )

