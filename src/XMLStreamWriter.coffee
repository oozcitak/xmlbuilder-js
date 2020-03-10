NodeType = require './NodeType'
XMLWriterBase = require './XMLWriterBase'
WriterState = require './WriterState'

# Prints XML nodes to a stream
module.exports = class XMLStreamWriter extends XMLWriterBase


  # Initializes a new instance of `XMLStreamWriter`
  #
  # `stream` output stream
  # `options.pretty` pretty prints the result
  # `options.indent` indentation string
  # `options.newline` newline sequence
  # `options.offset` a fixed number of indentations to add to every line
  # `options.allowEmpty` do not self close empty element tags
  # 'options.dontPrettyTextNodes' if any text is present in node, don't indent or LF
  # `options.spaceBeforeSlash` add a space before the closing slash of empty elements
  constructor: (@stream, options) ->
    super(options)

  endline: (node, options, level) ->
    if node.isLastRootNode and options.state is WriterState.CloseTag
      return ''
    else 
      super(node, options, level)

  document: (doc, options) ->
    # set a flag so that we don't insert a newline after the last root level node 
    for child, i in doc.children
      child.isLastRootNode = (i is doc.children.length - 1)

    options = @filterOptions options

    for child in doc.children
      @writeChildNode child, options, 0

  cdata: (node, options, level) ->
    @stream.write super(node, options, level)

  comment: (node, options, level) ->
    @stream.write super(node, options, level)

  declaration: (node, options, level) ->
    @stream.write super(node, options, level)

  docType: (node, options, level) ->
    level or= 0

    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    @stream.write @indent(node, options, level)
    @stream.write '<!DOCTYPE ' + node.root().name

    # external identifier
    if node.pubID and node.sysID
      @stream.write ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.sysID
      @stream.write ' SYSTEM "' + node.sysID + '"'

    # internal subset
    if node.children.length > 0
      @stream.write ' ['
      @stream.write @endline(node, options, level)
      options.state = WriterState.InsideTag
      for child in node.children
        @writeChildNode child, options, level + 1
      options.state = WriterState.CloseTag
      @stream.write ']'

    # close tag
    options.state = WriterState.CloseTag
    @stream.write options.spaceBeforeSlash + '>'
    @stream.write @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

  element: (node, options, level) ->
    level or= 0

    # open tag
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<' + node.name

    # attributes
    if options.pretty and options.width > 0
      len = r.length
      for own name, att of node.attribs
        ratt = @attribute att, options, level
        attLen = ratt.length
        if len + attLen > options.width
          rline = @indent(node, options, level + 1) + ratt
          r += @endline(node, options, level) + rline
          len = rline.length
        else
          rline = ' ' + ratt
          r += rline
          len += rline.length
    else
      for own name, att of node.attribs
        r += @attribute att, options, level
        
    @stream.write r

    childNodeCount = node.children.length
    firstChildNode = if childNodeCount is 0 then null else node.children[0]
    if childNodeCount == 0 or node.children.every((e) -> (e.type is NodeType.Text or e.type is NodeType.Raw or e.type is NodeType.CData) and e.value == '')
      # empty element
      if options.allowEmpty
        @stream.write '>'
        options.state = WriterState.CloseTag
        @stream.write '</' + node.name + '>'
      else
        options.state = WriterState.CloseTag
        @stream.write options.spaceBeforeSlash + '/>'
    else if options.pretty and childNodeCount == 1 and (firstChildNode.type is NodeType.Text or firstChildNode.type is NodeType.Raw or firstChildNode.type is NodeType.CData) and firstChildNode.value?
      # do not indent text-only nodes
      @stream.write '>'
      options.state = WriterState.InsideTag
      options.suppressPrettyCount++
      prettySuppressed = true
      @writeChildNode firstChildNode, options, level + 1
      options.suppressPrettyCount--
      prettySuppressed = false
      options.state = WriterState.CloseTag
      @stream.write '</' + node.name + '>'
    else
      @stream.write '>' + @endline(node, options, level)
      options.state = WriterState.InsideTag
      # inner tags
      for child in node.children
        @writeChildNode child, options, level + 1
      # close tag
      options.state = WriterState.CloseTag
      @stream.write @indent(node, options, level) + '</' + node.name + '>'

    @stream.write @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

  processingInstruction: (node, options, level) ->
    @stream.write super(node, options, level)

  raw: (node, options, level) ->
    @stream.write super(node, options, level)

  text: (node, options, level) ->
    @stream.write super(node, options, level)

  dtdAttList: (node, options, level) ->
    @stream.write super(node, options, level)

  dtdElement: (node, options, level) ->
    @stream.write super(node, options, level)

  dtdEntity: (node, options, level) ->
    @stream.write super(node, options, level)

  dtdNotation: (node, options, level) ->
    @stream.write super(node, options, level)
