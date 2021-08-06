path = require('path')
fs = require('fs')

suite 'Tests specific to issues:', ->
  test 'Issue #249: separateArrayItems ', ->

    obj = p:
      "@someattr": "something"
      '#text': [
        { span: { "@someattr2": "something2", "#text": "line1" } }
        { br: "" }
        { span: { "@someattr2": "something2", "#text": "line2" } }
      ]

    doc = xml(obj, { headless: true })

    eq(
      doc.end({ pretty: true })
      """
      <p someattr="something">
        <span someattr2="something2">line1</span>
        <br/>
        <span someattr2="something2">line2</span>
      </p>
      """
    )