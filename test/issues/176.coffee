suite 'Tests specific to issues:', ->
  test 'Issue #176 (valueOf fails for Object.Create(null)', ->
    obj = Object.create(null)
    obj.root = 'node'

    eq(
      xml(obj).end()
      '<?xml version="1.0"?>' +
      '<root>node</root>'
    )

