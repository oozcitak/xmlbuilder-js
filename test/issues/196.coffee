suite 'Tests specific to issues:', ->
  test 'Are attributes really nodes and should therefore invoke openNode() and closeNode() callbacks?. Issue 196', ->

    newAttribute = (att, options, level) ->
      r = @_attribute att, options, level
      if options.user.openflag then r = "BEGINATT:" + r
      if options.user.closeflag then r = r + ":ENDATT"
      return r

    newOpenAttribute = (att, options, level) ->
      options.user.openflag = att.name is "att1"

    newCloseAttribute = (att, options, level) ->
      options.user.closeflag = att.name is "att1"

    eq(
      xml('root', { headless: true })
        .ele('item', { 'att1': 'val1', 'att2': 'val2' })
        .end(builder.stringWriter({ writer: { attribute: newAttribute, openAttribute: newOpenAttribute, closeAttribute: newCloseAttribute }, pretty: true } ))

      """
      <root>
        <itemBEGINATT: att1="val1":ENDATT att2="val2"/>
      </root>
      """
    )
