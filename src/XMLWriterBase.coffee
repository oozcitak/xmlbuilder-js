{ assign } = require './Utility'

NodeType = require './NodeType'
XMLDeclaration = require './XMLDeclaration'
XMLDocType = require './XMLDocType'

XMLCData = require './XMLCData'
XMLComment = require './XMLComment'
XMLElement = require './XMLElement'
XMLRaw = require './XMLRaw'
XMLText = require './XMLText'
XMLProcessingInstruction = require './XMLProcessingInstruction'
XMLDummy = require './XMLDummy'

XMLDTDAttList = require './XMLDTDAttList'
XMLDTDElement = require './XMLDTDElement'
XMLDTDEntity = require './XMLDTDEntity'
XMLDTDNotation = require './XMLDTDNotation'

WriterState = require './WriterState'

# Base class for XML writers
module.exports = class XMLWriterBase


  # Initializes a new instance of `XMLWriterBase`
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation string
  # `options.newline` newline sequence
  # `options.offset` a fixed number of indentations to add to every line
  # `options.width` maximum column width
  # `options.allowEmpty` do not self close empty element tags
  # 'options.dontPrettyTextNodes' if any text is present in node, don't indent or LF
  # `options.spaceBeforeSlash` add a space before the closing slash of empty elements
  constructor: (options) ->
    options or= {}
    @options = options

    # overwrite default properties
    for own key, value of options.writer or {}
      @["_" + key] = @[key]
      @[key] = value

  # Filters writer options and provides defaults
  #
  # `options` writer options
  filterOptions: (options) ->
    options or= {}
    options = assign {}, @options, options

    filteredOptions = { writer: @ }
    filteredOptions.pretty = options.pretty or false
    filteredOptions.allowEmpty = options.allowEmpty or false
    
    filteredOptions.indent = options.indent ? '  '
    filteredOptions.newline = options.newline ? '\n'
    filteredOptions.offset = options.offset ? 0
    filteredOptions.width = options.width ? 0
    filteredOptions.dontPrettyTextNodes = options.dontPrettyTextNodes ? options.dontprettytextnodes ? 0

    filteredOptions.spaceBeforeSlash = options.spaceBeforeSlash ? options.spacebeforeslash ? ''
    if filteredOptions.spaceBeforeSlash is true then filteredOptions.spaceBeforeSlash = ' '

    filteredOptions.suppressPrettyCount = 0

    filteredOptions.user = {}
    filteredOptions.state = WriterState.None

    return filteredOptions

  # Returns the indentation string for the current level
  #
  # `node` current node
  # `options` writer options
  # `level` current indentation level
  indent: (node, options, level) ->
    if not options.pretty or options.suppressPrettyCount
      return ''
    else if options.pretty
      indentLevel = (level or 0) + options.offset + 1
      if indentLevel > 0
        return new Array(indentLevel).join(options.indent)
        
    return ''

  # Returns the newline string
  #
  # `node` current node
  # `options` writer options
  # `level` current indentation level
  endline: (node, options, level) ->
    if not options.pretty or options.suppressPrettyCount
      return ''
    else
      return options.newline

  attribute: (att, options, level) ->
    @openAttribute(att, options, level)
    if options.pretty and options.width > 0
      r = att.name + '="' + att.value + '"'
    else
      r = ' ' + att.name + '="' + att.value + '"'
    @closeAttribute(att, options, level)
    return r

  cdata: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<![CDATA['
    options.state = WriterState.InsideTag
    r += node.value
    options.state = WriterState.CloseTag
    r += ']]>' + @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  comment: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<!-- '
    options.state = WriterState.InsideTag
    r += node.value
    options.state = WriterState.CloseTag
    r += ' -->' + @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  declaration: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<?xml'
    options.state = WriterState.InsideTag
    r += ' version="' + node.version + '"'
    r += ' encoding="' + node.encoding + '"' if node.encoding?
    r += ' standalone="' + node.standalone + '"' if node.standalone?
    options.state = WriterState.CloseTag
    r += options.spaceBeforeSlash + '?>'
    r += @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  docType: (node, options, level) ->
    level or= 0

    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level)
    r += '<!DOCTYPE ' + node.root().name

    # external identifier
    if node.pubID and node.sysID
      r += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.sysID
      r += ' SYSTEM "' + node.sysID + '"'

    # internal subset
    if node.children.length > 0
      r += ' ['
      r += @endline(node, options, level)
      options.state = WriterState.InsideTag
      for child in node.children
        r += @writeChildNode child, options, level + 1
      options.state = WriterState.CloseTag
      r += ']'

    # close tag
    options.state = WriterState.CloseTag
    r += options.spaceBeforeSlash + '>'
    r += @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  element: (node, options, level) ->
    level or= 0
    prettySuppressed = false

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

    childNodeCount = node.children.length
    firstChildNode = if childNodeCount is 0 then null else node.children[0]
    if childNodeCount == 0 or node.children.every((e) -> (e.type is NodeType.Text or e.type is NodeType.Raw or e.type is NodeType.CData) and e.value == '')
      # empty element
      if options.allowEmpty
        r += '>'
        options.state = WriterState.CloseTag
        r += '</' + node.name + '>' + @endline(node, options, level)
      else
        options.state = WriterState.CloseTag
        r += options.spaceBeforeSlash + '/>' + @endline(node, options, level)
    else if options.pretty and childNodeCount == 1 and (firstChildNode.type is NodeType.Text or firstChildNode.type is NodeType.Raw or firstChildNode.type is NodeType.CData) and firstChildNode.value?
      # do not indent text-only nodes
      r += '>'
      options.state = WriterState.InsideTag
      options.suppressPrettyCount++
      prettySuppressed = true
      r += @writeChildNode firstChildNode, options, level + 1
      options.suppressPrettyCount--
      prettySuppressed = false
      options.state = WriterState.CloseTag
      r += '</' + node.name + '>' + @endline(node, options, level)
    else
      # if ANY are a text node, then suppress pretty now
      if options.dontPrettyTextNodes
        for child in node.children
          if (child.type is NodeType.Text or child.type is NodeType.Raw or child.type is NodeType.CData) and child.value?
            options.suppressPrettyCount++
            prettySuppressed = true
            break

      # close the opening tag, after dealing with newline
      r += '>' + @endline(node, options, level)
      options.state = WriterState.InsideTag
      # inner tags
      for child in node.children
        r += @writeChildNode child, options, level + 1

      # close tag
      options.state = WriterState.CloseTag
      r += @indent(node, options, level) + '</' + node.name + '>'

      if prettySuppressed
        options.suppressPrettyCount--

      r += @endline(node, options, level)
      options.state = WriterState.None

    @closeNode(node, options, level)

    return r

  writeChildNode: (node, options, level) ->
    switch node.type
      when NodeType.CData   then @cdata   node, options, level
      when NodeType.Comment then @comment node, options, level
      when NodeType.Element then @element node, options, level
      when NodeType.Raw     then @raw     node, options, level
      when NodeType.Text    then @text    node, options, level
      when NodeType.ProcessingInstruction then @processingInstruction node, options, level
      when NodeType.Dummy   then ''
      when NodeType.Declaration then @declaration node, options, level
      when NodeType.DocType     then @docType     node, options, level
      when NodeType.AttributeDeclaration then @dtdAttList  node, options, level
      when NodeType.ElementDeclaration   then @dtdElement  node, options, level
      when NodeType.EntityDeclaration    then @dtdEntity   node, options, level
      when NodeType.NotationDeclaration  then @dtdNotation node, options, level
      else throw new Error "Unknown XML node type: " + node.constructor.name

  processingInstruction: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<?'
    options.state = WriterState.InsideTag
    r += node.target
    r += ' ' + node.value if node.value
    options.state = WriterState.CloseTag
    r += options.spaceBeforeSlash + '?>'
    r += @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  raw: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level)
    options.state = WriterState.InsideTag
    r += node.value
    options.state = WriterState.CloseTag
    r += @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  text: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level)
    options.state = WriterState.InsideTag
    r += node.value
    options.state = WriterState.CloseTag
    r += @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  dtdAttList: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<!ATTLIST'
    options.state = WriterState.InsideTag
    r += ' ' + node.elementName + ' ' + node.attributeName + ' ' + node.attributeType
    r += ' ' + node.defaultValueType if node.defaultValueType != '#DEFAULT'
    r += ' "' + node.defaultValue + '"' if node.defaultValue
    options.state = WriterState.CloseTag
    r += options.spaceBeforeSlash + '>' + @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  dtdElement: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<!ELEMENT'
    options.state = WriterState.InsideTag
    r += ' ' + node.name + ' ' + node.value
    options.state = WriterState.CloseTag
    r += options.spaceBeforeSlash + '>' + @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  dtdEntity: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<!ENTITY'
    options.state = WriterState.InsideTag
    r += ' %' if node.pe
    r += ' ' + node.name
    if node.value
      r += ' "' + node.value + '"'
    else
      if node.pubID and node.sysID
        r += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
      else if node.sysID
        r += ' SYSTEM "' + node.sysID + '"'
      r += ' NDATA ' + node.nData if node.nData
    options.state = WriterState.CloseTag
    r += options.spaceBeforeSlash + '>' + @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  dtdNotation: (node, options, level) ->
    @openNode(node, options, level)
    options.state = WriterState.OpenTag
    r = @indent(node, options, level) + '<!NOTATION'
    options.state = WriterState.InsideTag
    r += ' ' + node.name
    if node.pubID and node.sysID
      r += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.pubID
      r += ' PUBLIC "' + node.pubID + '"'
    else if node.sysID
      r += ' SYSTEM "' + node.sysID + '"'
    options.state = WriterState.CloseTag
    r += options.spaceBeforeSlash + '>' + @endline(node, options, level)
    options.state = WriterState.None
    @closeNode(node, options, level)

    return r

  openNode: (node, options, level) ->

  closeNode: (node, options, level) ->

  openAttribute: (att, options, level) ->

  closeAttribute: (att, options, level) ->
