every = require 'lodash/every'

# Prints XML nodes as plain text
module.exports = class XMLWriter


  # Initializes a new instance of `XMLWriter`
  #
  constructor: (options) ->
    options ?= {}
    options.writer = @
    @options = options
    @allowEmpty = options?.allowEmpty ? false

  document: (doc) ->
    r = ''
    r += doc.xmldec.toString @options if doc.xmldec?
    r += doc.doctype.toString @options if doc.doctype?
    r += doc.rootObject.toString @options

    return r

  attribute: (att) ->
    ' ' + att.name + '="' + att.value + '"'

  cdata: (node) ->
    '<![CDATA[' + node.text + ']]>'

  comment: (node) ->
    '<!-- ' + node.text + ' -->'

  declaration: (node) ->
    r = '<?xml version="' + node.version + '"'
    r += ' encoding="' + node.encoding + '"' if node.encoding?
    r += ' standalone="' + node.standalone + '"' if node.standalone?
    r += '?>'

    return r

  docType: (node) ->
    r = '<!DOCTYPE ' + node.root().name

    # external identifier
    if node.pubID and node.sysID
      r += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.sysID
      r += ' SYSTEM "' + node.sysID + '"'

    # internal subset
    if node.children.length > 0
      r += ' ['
      for child in node.children
        r += child.toString @options
      r += ']'

    # close tag
    r += '>'

    return r

  element: (node) ->
    r = ''

    # instructions
    for instruction in node.instructions
      r += instruction.toString @options

    # open tag
    r += '<' + node.name

    # attributes
    for own name, att of node.attributes
      r += att.toString @options

    if node.children.length == 0 or every(node.children, (e) -> e.value == '')
      # empty element
      if @allowEmpty
        r += '></' + node.name + '>'
      else
        r += '/>'
    else
      r += '>'
      # inner tags
      for child in node.children
        r += child.toString @options
      # close tag
      r += '</' + node.name + '>'

    return r

  processingInstruction: (node) ->
    r = '<?' + node.target
    r += ' ' + node.value if node.value
    r += '?>'

    return r

  raw: (node) ->
    node.value

  text: (node) ->
    node.value

  dtdAttList: (node) ->
    r = '<!ATTLIST ' + node.elementName + ' ' + node.attributeName + ' ' + node.attributeType
    r += ' ' + node.defaultValueType if node.defaultValueType != '#DEFAULT'
    r += ' "' + node.defaultValue + '"' if node.defaultValue
    r += '>'

    return r

  dtdElement: (node) ->
    '<!ELEMENT ' + node.name + ' ' + node.value + '>'

  dtdEntity: (node) ->
    r = '<!ENTITY'
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
    r += '>'

    return r

  dtdNotation: (node) ->
    r = '<!NOTATION ' + node.name
    if node.pubID and node.sysID
      r += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
    else if node.pubID
      r += ' PUBLIC "' + node.pubID + '"'
    else if node.sysID
      r += ' SYSTEM "' + node.sysID + '"'
    r += '>'

    return r
