path = require('path')
fs = require('fs')

suite 'Tests specific to issues:', ->
  test 'Issue #239: Not possible to build a list of non-unique elements non-contiguously with JSON', ->

    obj = root:
      '#text1': [
        { node: 'value1' }
        { node: 'value2' }
      ]
      '#comment': 'comment node'
      '#text2': [
        { node: 'value3' }
        { node: 'value4' }
      ]

    doc = xml(obj, { headless: true })

    eq(
      doc.end({ pretty: true })
      """
      <root>
        <node>value1</node>
        <node>value2</node>
        <!-- comment node -->
        <node>value3</node>
        <node>value4</node>
      </root>
      """
    )