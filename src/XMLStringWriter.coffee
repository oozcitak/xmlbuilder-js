XMLDeclaration = require './XMLDeclaration'
XMLDocType = require './XMLDocType'

XMLCData = require './XMLCData'
XMLComment = require './XMLComment'
XMLElement = require './XMLElement'
XMLRaw = require './XMLRaw'
XMLText = require './XMLText'
XMLProcessingInstruction = require './XMLProcessingInstruction'

XMLDTDAttList = require './XMLDTDAttList'
XMLDTDElement = require './XMLDTDElement'
XMLDTDEntity = require './XMLDTDEntity'
XMLDTDNotation = require './XMLDTDNotation'

XMLWriterBase = require './XMLWriterBase'

# Prints XML nodes as plain text
module.exports = class XMLStringWriter extends XMLWriterBase


  # Initializes a new instance of `XMLStringWriter`
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation string
  # `options.newline` newline sequence
  # `options.offset` a fixed number of indentations to add to every line
  # `options.allowEmpty` do not self close empty element tags
  constructor: (options) ->
    super options

  document: (doc) ->
    r = ''
    for child in doc.children
      r += switch
        when child instanceof XMLDeclaration then @declaration child
        when child instanceof XMLDocType     then @docType     child
        when child instanceof XMLComment     then @comment     child
        when child instanceof XMLProcessingInstruction then @processingInstruction child
        else @element child, 0

    # remove trailing newline
    if @pretty and r.slice(-@newline.length) == @newline
      r = r.slice(0, -@newline.length)

    return r

  attribute: (att) ->
    ' ' + att.name + '="' + att.value + '"'

  cdata: (node, level) ->
    @space(level) + '<![CDATA[' + node.text + ']]>' + @newline

  comment: (node, level) ->
    @space(level) + '<!-- ' + node.text + ' -->' + @newline

  declaration: (node, level) ->
    r = @space(level)
    r += '<?xml version="' + node.version + '"'
    r += ' encoding="' + node.encoding + '"' if node.encoding?
    r += ' standalone="' + node.standalone + '"' if node.standalone?
    r += '?>'
    r += @newline

    return r

  docType: (node, level) ->
    level or= 0

    r = @space(level)
    r += '<!DOCTYPE ' + node.root().name

    # external identifier
    if node.pubID and node.sysID
      r += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.sysID
      r += ' SYSTEM "' + node.sysID + '"'

    # internal subset
    if node.children.length > 0
      r += ' ['
      r += @newline
      for child in node.children
        r += switch
          when child instanceof XMLDTDAttList  then @dtdAttList  child, level + 1
          when child instanceof XMLDTDElement  then @dtdElement  child, level + 1
          when child instanceof XMLDTDEntity   then @dtdEntity   child, level + 1
          when child instanceof XMLDTDNotation then @dtdNotation child, level + 1
          when child instanceof XMLCData       then @cdata       child, level + 1
          when child instanceof XMLComment     then @comment     child, level + 1
          when child instanceof XMLProcessingInstruction then @processingInstruction child, level + 1
          else throw new Error "Unknown DTD node type: " + child.constructor.name
      r += ']'

    # close tag
    r += '>'
    r += @newline

    return r

  element: (node, level) ->
    level or= 0

    space = @space(level)

    r = ''

    # open tag
    r += space + '<' + node.name

    # attributes
    for own name, att of node.attributes
      r += @attribute att

    if node.children.length == 0 or node.children.every((e) -> e.value == '')
      # empty element
      if @allowEmpty
        r += '></' + node.name + '>' + @newline
      else
        r += '/>' + @newline
    else if @pretty and node.children.length == 1 and node.children[0].value?
      # do not indent text-only nodes
      r += '>'
      r += node.children[0].value
      r += '</' + node.name + '>' + @newline
    else
      r += '>' + @newline
      # inner tags
      for child in node.children
        r += switch
          when child instanceof XMLCData   then @cdata   child, level + 1
          when child instanceof XMLComment then @comment child, level + 1
          when child instanceof XMLElement then @element child, level + 1
          when child instanceof XMLRaw     then @raw     child, level + 1
          when child instanceof XMLText    then @text    child, level + 1
          when child instanceof XMLProcessingInstruction then @processingInstruction child, level + 1
          else throw new Error "Unknown XML node type: " + child.constructor.name
      # close tag
      r += space + '</' + node.name + '>' + @newline

    return r

  processingInstruction: (node, level) ->
    r = @space(level) + '<?' + node.target
    r += ' ' + node.value if node.value
    r += '?>' + @newline

    return r

  raw: (node, level) ->
    @space(level) + node.value + @newline

  text: (node, level) ->
    @space(level) + node.value + @newline

  dtdAttList: (node, level) ->
    r = @space(level) + '<!ATTLIST ' + node.elementName + ' ' + node.attributeName + ' ' + node.attributeType
    r += ' ' + node.defaultValueType if node.defaultValueType != '#DEFAULT'
    r += ' "' + node.defaultValue + '"' if node.defaultValue
    r += '>' + @newline

    return r

  dtdElement: (node, level) ->
    @space(level) + '<!ELEMENT ' + node.name + ' ' + node.value + '>' + @newline

  dtdEntity: (node, level) ->
    r = @space(level) + '<!ENTITY'
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
    r += '>' + @newline

    return r

  dtdNotation: (node, level) ->
    r = @space(level) + '<!NOTATION ' + node.name
    if node.pubID and node.sysID
      r += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.pubID
      r += ' PUBLIC "' + node.pubID + '"'
    else if node.sysID
      r += ' SYSTEM "' + node.sysID + '"'
    r += '>' + @newline

    return r

  openNode: (node, level) ->
    level or= 0

    if node instanceof XMLElement
      r = @space(level) + '<' + node.name

      # attributes
      for own name, att of node.attributes
        r += @attribute att

      r += (if node.children then '>' else '/>') + @newline

      return r
    else # if node instanceof XMLDocType
      r = @space(level) + '<!DOCTYPE ' + node.rootNodeName

      # external identifier
      if node.pubID and node.sysID
        r += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
      else if node.sysID
        r += ' SYSTEM "' + node.sysID + '"'

      # internal subset
      r += (if node.children then ' [' else '>') + @newline

      return r

  closeNode: (node, level) ->
    level or= 0

    return switch
      when node instanceof XMLElement
        @space(level) + '</' + node.name + '>' + @newline
      when node instanceof XMLDocType
        @space(level) + ']>' + @newline
