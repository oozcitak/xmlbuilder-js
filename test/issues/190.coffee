suite 'Tests specific to issues:', ->
  test 'Empty Array from JSON generates Element. Issue 190. `item: []` should produce no nodes.', ->
    eq(
      xmleleend { item: [] }
      '<root/>'
    )

  test 'Empty Array from JSON generates Element. Issue 190. `item: {}` should produce one node.', ->
    eq(
      xmleleend { item: {} }
      '<root><item/></root>'
    )

  test 'Empty Array from JSON generates Element. Issue 190. `item: [{}]` should produce one node.', ->
    eq(
      xmleleend { item: [{}] }
      '<root><item/></root>'
    )
