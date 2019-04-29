path = require('path')
fs = require('fs')

suite 'Tests specific to issues:', ->
  test 'Writer events not triggered: Issue 208', ->

    errorReportObj = error:
      code: 500
      message: "failed"
    xmlPath = path.join __dirname, '208.xml'
    stream = fs.createWriteStream(xmlPath, { flags : 'w' })
    writer = builder.streamWriter(stream, { pretty: true, allowEmpty: false})
    builder.create(errorReportObj, {
      encoding: 'utf-8',
    }).end(writer)
    stream.end()
      
    stream.on('end', () ->
      eq(
        fs.readFileSync(xmlPath, 'utf8')

        """
        <?xml version="1.0" encoding="utf-8"?>
        <error>
          <code>500</code>
          <message>failed</message>
        <error>
        """
      )
    )

