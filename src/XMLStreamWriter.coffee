every = require 'lodash/every'

XMLProcessingInstruction = require './XMLProcessingInstruction'

XMLCData = require './XMLCData'
XMLComment = require './XMLComment'
XMLElement = require './XMLElement'
XMLRaw = require './XMLRaw'
XMLText = require './XMLText'

XMLDTDAttList = require './XMLDTDAttList'
XMLDTDElement = require './XMLDTDElement'
XMLDTDEntity = require './XMLDTDEntity'
XMLDTDNotation = require './XMLDTDNotation'

# Prints XML nodes to a stream
module.exports = class XMLStreamWriter


  # Initializes a new instance of `XMLStreamWriter`
  #
  # `stream` the writable output stream
  # `options.pretty` pretty prints the result
  # `options.indent` indentation string
  # `options.newline` newline sequence
  # `options.offset` a fixed number of indentations to add to every line
  # `options.allowEmpty` do not self close empty element tags
  constructor: (stream, options) ->
    @stream = stream
    @pretty = options?.pretty or false
    @allowEmpty = options?.allowEmpty ? false
    if @pretty
      @indent = options?.indent ? '  '
      @newline = options?.newline ? '\n'
      @offset = options?.offset ? 0
    else
      @indent = ''
      @newline = ''
      @offset = 0

  # Modifies writer options
  set: (options) ->
    options ?= {}
    @pretty = options.pretty if "pretty" of options
    @allowEmpty = options.allowEmpty  if "allowEmpty" of options
    if @pretty
      @indent = if "indent" of options then options.indent else '  '
      @newline = if "newline" of options then options.newline else '\n'
      @offset = if "offset" of options then options.offset else 0
    else
      @indent = ''
      @newline = ''
      @offset = 0

    return @

  # returns the indentation string for the current level
  space: (level) ->
    if @pretty
      new Array((level or 0) + @offset + 1).join(@indent)
    else
      ''

  document: (doc) ->
    @declaration doc.xmldec if doc.xmldec?
    @docType doc.doctype if doc.doctype?
    @element doc.root()

  attribute: (att) ->
    @stream.write ' ' + att.name + '="' + att.value + '"'

  cdata: (node, level) ->
    @stream.write @space(level) + '<![CDATA[' + node.text + ']]>' + @newline

  comment: (node, level) ->
    @stream.write @space(level) + '<!-- ' + node.text + ' -->' + @newline

  declaration: (node, level) ->
    @stream.write @space(level)
    @stream.write '<?xml version="' + node.version + '"'
    @stream.write ' encoding="' + node.encoding + '"' if node.encoding?
    @stream.write ' standalone="' + node.standalone + '"' if node.standalone?
    @stream.write '?>'
    @stream.write @newline

  docType: (node, level) ->
    level or= 0

    @stream.write @space(level)
    @stream.write '<!DOCTYPE ' + node.root().name

    # external identifier
    if node.pubID and node.sysID
      @stream.write ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.sysID
      @stream.write ' SYSTEM "' + node.sysID + '"'

    # internal subset
    if node.children.length > 0
      @stream.write ' ['
      @stream.write @newline
      for child in node.children
        switch
          when child instanceof XMLDTDAttList  then @dtdAttList  child, level + 1
          when child instanceof XMLDTDElement  then @dtdElement  child, level + 1
          when child instanceof XMLDTDEntity   then @dtdEntity   child, level + 1
          when child instanceof XMLDTDNotation then @dtdNotation child, level + 1
          when child instanceof XMLCData       then @cdata       child, level + 1
          when child instanceof XMLComment     then @comment     child, level + 1
          when child instanceof XMLProcessingInstruction then @processingInstruction child, level + 1
          else throw new Error "Unknown DTD node type: " + child.constructor.name
      @stream.write ']'

    # close tag
    @stream.write '>'
    @stream.write  @newline

  element: (node, level) ->
    level or= 0

    space = @space(level)

    # instructions
    for ins in node.instructions
       @processingInstruction ins, level

    # open tag
    @stream.write space + '<' + node.name

    # attributes
    for own name, att of node.attributes
      @attribute att

    if node.children.length == 0 or every(node.children, (e) -> e.value == '')
      # empty element
      if @allowEmpty
        @stream.write '></' + node.name + '>' + (if node.isRoot then '' else @newline)
      else
        @stream.write '/>' + (if node.isRoot then '' else @newline)
    else if @pretty and node.children.length == 1 and node.children[0].value?
      # do not indent text-only nodes
      @stream.write '>'
      @stream.write node.children[0].value
      @stream.write '</' + node.name + '>' + (if node.isRoot then '' else @newline)
    else
      @stream.write '>' + @newline
      # inner tags
      for child in node.children
        switch
          when child instanceof XMLCData   then @cdata   child, level + 1
          when child instanceof XMLComment then @comment child, level + 1
          when child instanceof XMLElement then @element child, level + 1
          when child instanceof XMLRaw     then @raw     child, level + 1
          when child instanceof XMLText    then @text    child, level + 1
          else throw new Error "Unknown XML node type: " + child.constructor.name
      # close tag
      @stream.write space + '</' + node.name + '>' + (if node.isRoot then '' else @newline)

  processingInstruction: (node, level) ->
    @stream.write @space(level) + '<?' + node.target
    @stream.write ' ' + node.value if node.value
    @stream.write '?>' + @newline

  raw: (node, level) ->
    @stream.write @space(level) + node.value + @newline

  text: (node, level) ->
    @stream.write @space(level) + node.value + @newline

  dtdAttList: (node, level) ->
    @stream.write @space(level) + '<!ATTLIST ' + node.elementName + ' ' + node.attributeName + ' ' + node.attributeType
    @stream.write ' ' + node.defaultValueType if node.defaultValueType != '#DEFAULT'
    @stream.write ' "' + node.defaultValue + '"' if node.defaultValue
    @stream.write '>' + @newline

  dtdElement: (node, level) ->
    @stream.write @space(level) + '<!ELEMENT ' + node.name + ' ' + node.value + '>' + @newline

  dtdEntity: (node, level) ->
    @stream.write @space(level) + '<!ENTITY'
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
    @stream.write '>' + @newline

  dtdNotation: (node, level) ->
    @stream.write @space(level) + '<!NOTATION ' + node.name
    if node.pubID and node.sysID
      @stream.write ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.pubID
      @stream.write ' PUBLIC "' + node.pubID + '"'
    else if node.sysID
      @stream.write ' SYSTEM "' + node.sysID + '"'
    @stream.write '>' + @newline
