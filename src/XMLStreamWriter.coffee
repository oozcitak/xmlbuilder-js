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

XMLWriterBase = require './XMLWriterBase'

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

  document: (doc, options) ->
    # set a flag so that we don't insert a newline after the last root level node 
    for child, i in doc.children
      child.isLastRootNode = (i is doc.children.length - 1)

    for child, i in doc.children
      # skip dummy nodes
      if child instanceof XMLDummy then continue

      switch
        when child instanceof XMLDeclaration then @declaration child, options, 0
        when child instanceof XMLDocType     then @docType     child, options, 0
        when child instanceof XMLComment     then @comment     child, options, 0
        when child instanceof XMLProcessingInstruction then @processingInstruction child, options, 0
        else @element child, options, 0

  attribute: (att, options, level) ->
    @stream.write ' ' + att.name + '="' + att.value + '"'

  cdata: (node, options, level) ->
    @stream.write @space(node, options, level) + '<![CDATA[' + node.text + ']]>' + @endline(node, options, level)

  comment: (node, options, level) ->
    @stream.write @space(node, options, level) + '<!-- ' + node.text + ' -->' + @endline(node, options, level)

  declaration: (node, options, level) ->
    @stream.write @space(node, options, level)
    @stream.write '<?xml version="' + node.version + '"'
    @stream.write ' encoding="' + node.encoding + '"' if node.encoding?
    @stream.write ' standalone="' + node.standalone + '"' if node.standalone?
    @stream.write options.spaceBeforeSlash + '?>'
    @stream.write @endline(node, options, level)

  docType: (node, options, level) ->
    level or= 0

    @stream.write @space(node, options, level)
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
      for child in node.children
        switch
          when child instanceof XMLDTDAttList  then @dtdAttList  child, options, level + 1
          when child instanceof XMLDTDElement  then @dtdElement  child, options, level + 1
          when child instanceof XMLDTDEntity   then @dtdEntity   child, options, level + 1
          when child instanceof XMLDTDNotation then @dtdNotation child, options, level + 1
          when child instanceof XMLCData       then @cdata       child, options, level + 1
          when child instanceof XMLComment     then @comment     child, options, level + 1
          when child instanceof XMLProcessingInstruction then @processingInstruction child, options, level + 1
          else throw new Error "Unknown DTD node type: " + child.constructor.name
      @stream.write ']'

    # close tag
    @stream.write options.spaceBeforeSlash + '>'
    @stream.write @endline(node, options, level)

  element: (node, options, level) ->
    level or= 0

    space = @space(node, options, level)

    # open tag
    @stream.write space + '<' + node.name

    # attributes
    for own name, att of node.attributes
      @attribute att, options, level

    if node.children.length == 0 or node.children.every((e) -> e.value == '')
      # empty element
      if options.allowEmpty
        @stream.write '></' + node.name + '>'
      else
        @stream.write options.spaceBeforeSlash + '/>'
    else if options.pretty and node.children.length == 1 and node.children[0].value?
      # do not indent text-only nodes
      @stream.write '>'
      @stream.write node.children[0].value
      @stream.write '</' + node.name + '>'
    else
      @stream.write '>' + options.newline
      # inner tags
      for child in node.children
        switch
          when child instanceof XMLCData   then @cdata   child, options, level + 1
          when child instanceof XMLComment then @comment child, options, level + 1
          when child instanceof XMLElement then @element child, options, level + 1
          when child instanceof XMLRaw     then @raw     child, options, level + 1
          when child instanceof XMLText    then @text    child, options, level + 1
          when child instanceof XMLProcessingInstruction then @processingInstruction child, options, level + 1
          when child instanceof XMLDummy   then ''
          else throw new Error "Unknown XML node type: " + child.constructor.name
      # close tag
      @stream.write space + '</' + node.name + '>'

    @stream.write @endline(node, options, level)

  processingInstruction: (node, options, level) ->
    @stream.write @space(node, options, level) + '<?' + node.target
    @stream.write ' ' + node.value if node.value
    @stream.write options.spaceBeforeSlash + '?>' + @endline(node, options, level)

  raw: (node, options, level) ->
    @stream.write @space(node, options, level) + node.value + @endline(node, options, level)

  text: (node, options, level) ->
    @stream.write @space(node, options, level) + node.value + @endline(node, options, level)

  dtdAttList: (node, options, level) ->
    @stream.write @space(node, options, level) + '<!ATTLIST ' + node.elementName + ' ' + node.attributeName + ' ' + node.attributeType
    @stream.write ' ' + node.defaultValueType if node.defaultValueType != '#DEFAULT'
    @stream.write ' "' + node.defaultValue + '"' if node.defaultValue
    @stream.write options.spaceBeforeSlash + '>' + @endline(node, options, level)

  dtdElement: (node, options, level) ->
    @stream.write @space(node, options, level) + '<!ELEMENT ' + node.name + ' ' + node.value
    @stream.write options.spaceBeforeSlash + '>' + @endline(node, options, level)

  dtdEntity: (node, options, level) ->
    @stream.write @space(node, options, level) + '<!ENTITY'
    @stream.write ' %' if node.pe
    @stream.write ' ' + node.name
    if node.value
      @stream.write ' "' + node.value + '"'
    else
      if node.pubID and node.sysID
        @stream.write ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
      else if node.sysID
        @stream.write ' SYSTEM "' + node.sysID + '"'
      @stream.write ' NDATA ' + node.nData if node.nData
    @stream.write options.spaceBeforeSlash + '>' + @endline(node, options, level)

  dtdNotation: (node, options, level) ->
    @stream.write @space(node, options, level) + '<!NOTATION ' + node.name
    if node.pubID and node.sysID
      @stream.write ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.pubID
      @stream.write ' PUBLIC "' + node.pubID + '"'
    else if node.sysID
      @stream.write ' SYSTEM "' + node.sysID + '"'
    @stream.write options.spaceBeforeSlash + '>' + @endline(node, options, level)

  endline: (node, options, level) ->
    if node.isLastRootNode then '' else options.newline
