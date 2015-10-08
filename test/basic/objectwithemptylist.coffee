suite 'Creating XML:', ->
  test 'From JS object (empty #list decorator should be ignored)', ->
    testCases = [
      { 'root':
          '#list': []
      }
      { 'root':
          'node': 'val'
          '#list': []
      }
      { 'root':
          '#list': []
          'node': 'val'
      }
      { 'root':
          'node1': 'val1'
          '#list': []
          'node2': 'val2'
      }
      { 'root':
          '#list': []
          'node1': 'val1'
          '#list': []
          'empty': []
          'node2': 'val2'
          '#list': []
      }
    ]
    results = [
      '<root/>'
      '<root><node>val</node></root>'
      '<root><node>val</node></root>'
      '<root><node1>val1</node1><node2>val2</node2></root>'
      '<root><node1>val1</node1><empty/><node2>val2</node2></root>'
    ]

    eq(
      xml(testCases[i], { headless: true }).end()
      results[i]
    ) for i in [0..testCases.length-1]

