every = require 'lodash/every'

XMLWriter = require './XMLWriter'

# Prints formatted XML nodes as string
module.exports = class XMLFormattedWriter extends XMLWriter


  # Initializes a new instance of `XMLWriter`
  #
  # `options.indent` indentation string
  # `options.offset` a fixed number of indentations to add to every line
  # `options.newline` newline sequence
  constructor: (options) ->
    super options

    options ?= {}
    @indent = options?.indent ? '  '
    @offset = options?.offset ? 0
    @newline = options?.newline ? '\n'

  # returns the indentation string for the current level
  space: (level) ->
    level or= 0
    new Array(level + @offset + 1).join(@indent)

  document: (doc) ->
    r = ''
    r += doc.xmldec.toString @options if doc.xmldec?
    r += doc.doctype.toString @options if doc.doctype?
    r += doc.rootObject.toString @options

    # remove trailing newline
    if r.slice(-@newline.length) == @newline
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
        r += child.toString @options, level + 1
      r += ']'

    # close tag
    r += '>'
    r += @newline

    return r

  element: (node, level) ->
    level or= 0

    space = @space(level)

    r = ''

    # instructions
    for instruction in node.instructions
      r += instruction.toString @options, level

    # open tag
    r += space + '<' + node.name

    # attributes
    for own name, att of node.attributes
      r += att.toString @options

    if node.children.length == 0 or every(node.children, (e) -> e.value == '')
      # empty element
      if @allowEmpty
        r += '></' + node.name + '>' + @newline
      else
        r += '/>' + @newline
    else if node.children.length == 1 and node.children[0].value?
      # do not indent text-only nodes
      r += '>'
      r += node.children[0].value
      r += '</' + node.name + '>' + @newline
    else
      r += '>' + @newline
      # inner tags
      for child in node.children
        r += child.toString @options, level + 1
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

