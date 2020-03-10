path = require('path')
fs = require('fs')

suite 'Tests specific to issues:', ->
  test 'Issue #235: Maximum call stack size exceeded while create XML', ->

    jsonPath = path.join __dirname, '235.json'
    jsonText = fs.readFileSync jsonPath, { encoding: 'utf8' }
    replacedText = jsonText.replace /\$ref/g, 'ref'

    err(
      () => builder.create(JSON.parse(jsonText))
    )

    noterr(
      () => builder.create(JSON.parse(replacedText))
    )



