suite 'Tests specific to issues:', ->
  test 'Missing callbacks if {pretty: true} and only one method called on element?. Issue 195', ->

    debugStr = ''
    root = xml('root')
    root.ele('textDirect', null, '[1]')
    root.ele('textSingle').txt('[2]')
    root.ele('rawSingle').raw('[3]')
    root.ele('textDirectDummy', null, '[4]').dummy()
    root.ele('textDummy').txt('[5]').dummy()
    root.ele('rawDummy').raw('[6]').dummy()
    root.ele('twoTextNodes').txt('[7]').txt('[7]')
    root.ele('twoRaw').raw('[8]').raw('[8]')
    root.ele('rawAndTextNode').raw('[9]').txt('[9]')
    root.end(builder.stringWriter(
      pretty: true
      writer:
        raw: (node, options, level) ->
          debugStr += "#{ options.indent.repeat(level) }RAW #{ node.value }\n"
          @_raw node, options, level
        text: (node, options, level) ->
          debugStr += "#{ options.indent.repeat(level) }TEXT #{ node.value }\n"
          @_text node, options, level
        element: (node, options, level) ->
          debugStr += "#{ options.indent.repeat(level) }ELEMENT #{ node.name }\n"
          @_element node, options, level
    ))

    # trim last newline
    debugStr = debugStr.slice(0, -1)

    eq(
      debugStr

      """
      ELEMENT root
        ELEMENT textDirect
          TEXT [1]
        ELEMENT textSingle
          TEXT [2]
        ELEMENT rawSingle
          RAW [3]
        ELEMENT textDirectDummy
          TEXT [4]
        ELEMENT textDummy
          TEXT [5]
        ELEMENT rawDummy
          RAW [6]
        ELEMENT twoTextNodes
          TEXT [7]
          TEXT [7]
        ELEMENT twoRaw
          RAW [8]
          RAW [8]
        ELEMENT rawAndTextNode
          RAW [9]
          TEXT [9]
      """
    )
