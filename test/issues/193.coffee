suite 'Tests specific to issues:', ->
  test 'use of writer modification in .end(). Issue 193', ->

    newIndent = (node, options, level) ->
      if (node.parent?.name is "p" and options.state is 1) or (node.name is "p" and options.state is 3)
        return ''
      else
        return @_indent node, options, level

    newEndline = (node, options, level) ->
      if (node.parent?.name is "p" and options.state is 3) or (node.name is "p" and options.state is 1)
        return ''
      else
        return @_endline node, options, level

    eq(
      xml('html', { headless: true })
        .ele('p', { 'style': 'S1' })
          .ele('span', { 'style': 'S1' }).txt(1)
        .end(builder.stringWriter({ writer: { indent: newIndent, endline: newEndline }, pretty: true } ))

      """
      <html>
        <p style="S1"><span style="S1">1</span></p>
      </html>
      """
    )

  test 'use of writer modification in .end() with openNode and closeNode. Issue 193', ->

    newOpenNode = (node, options, level) ->
      if (node.name is "p")
        options.user.oldPretty = options.pretty
        options.pretty = false

      @_openNode node, options, level

    newCloseNode = (node, options, level) ->
      if (node.name is "p")
        options.pretty = options.user.oldPretty 

      @_closeNode node, options, level

    eq(
      xml('p', { headless: true })
        .ele('span')
          .ele('span', 'sometext').up()
          .ele('span', 'sometext2')
        .end(builder.stringWriter({ writer: { openNode: newOpenNode, closeNode: newCloseNode }, pretty: true } ))

      """
      <p><span><span>sometext</span><span>sometext2</span></span></p>
      """
    )