{ isObject, isFunction, getValue } = require './Utility'

XMLNode = require './XMLNode'
NodeType = require './NodeType'
XMLAttribute = require './XMLAttribute'
XMLNamedNodeMap = require './XMLNamedNodeMap'

# Represents an element of the XML document
module.exports = class XMLElement extends XMLNode


  # Initializes a new instance of `XMLElement`
  #
  # `parent` the parent node
  # `name` element name
  # `attributes` an object containing name/value pairs of attributes
  constructor: (parent, name, attributes) ->
    super parent

    if not name?
      throw new Error "Missing element name. " + @debugInfo()

    @name = @stringify.name name
    @type = NodeType.Element
    @attribs = {}
    @schemaTypeInfo = null

    @attribute attributes if attributes?

    # set properties if this is the root node
    if parent.type is NodeType.Document
      @isRoot = true
      @documentObject = parent
      parent.rootObject = @
      # set dtd name
      if parent.children
        for child in parent.children
          if child.type is NodeType.DocType
            child.name = @name
            break

  # DOM level 1
  Object.defineProperty @::, 'tagName', get: () -> @name


  # DOM level 4
  Object.defineProperty @::, 'namespaceURI', get: () -> ''
  Object.defineProperty @::, 'prefix', get: () -> ''
  Object.defineProperty @::, 'localName', get: () -> @name
  Object.defineProperty @::, 'id', get: () -> throw new Error "This DOM method is not implemented." + @debugInfo()
  Object.defineProperty @::, 'className', get: () -> throw new Error "This DOM method is not implemented." + @debugInfo()
  Object.defineProperty @::, 'classList', get: () -> throw new Error "This DOM method is not implemented." + @debugInfo()
  Object.defineProperty @::, 'attributes', get: () ->
    if not @attributeMap or not @attributeMap.nodes
      @attributeMap = new XMLNamedNodeMap @attribs
    return @attributeMap


  # Creates and returns a deep clone of `this`
  #
  clone: () ->
    clonedSelf = Object.create @

    # remove document element
    if clonedSelf.isRoot
      clonedSelf.documentObject = null

    # clone attributes
    clonedSelf.attribs = {}
    for own attName, att of @attribs
      clonedSelf.attribs[attName] = att.clone()

    # clone child nodes
    clonedSelf.children = []
    @children.forEach (child) ->
      clonedChild = child.clone()
      clonedChild.parent = clonedSelf
      clonedSelf.children.push clonedChild

    return clonedSelf


  # Adds or modifies an attribute
  #
  # `name` attribute name
  # `value` attribute value
  attribute: (name, value) ->
    name = getValue(name) if name?

    if isObject name # expand if object
      for own attName, attValue of name
        @attribute attName, attValue
    else
      value = value.apply() if isFunction value
      if @options.keepNullAttributes and not value?
        @attribs[name] = new XMLAttribute @, name, ""
      else if value?
        @attribs[name] = new XMLAttribute @, name, value

    return @


  # Removes an attribute
  #
  # `name` attribute name
  removeAttribute: (name) ->
    # Also defined in DOM level 1
    # removeAttribute(name) removes an attribute by name.
    if not name?
      throw new Error "Missing attribute name. " + @debugInfo()
    name = getValue name

    if Array.isArray name # expand if array
      for attName in name
        delete @attribs[attName]
    else
      delete @attribs[name]

    return @


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  # `options.allowEmpty` do not self close empty element tags
  toString: (options) ->
    @options.writer.element @, @options.writer.filterOptions(options)


  # Aliases
  att: (name, value) -> @attribute name, value
  a: (name, value) -> @attribute name, value


  # DOM Level 1
  getAttribute: (name) -> if @attribs.hasOwnProperty(name) then @attribs[name].value else null
  setAttribute: (name, value) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getAttributeNode: (name) -> if @attribs.hasOwnProperty(name) then @attribs[name] else null
  setAttributeNode: (newAttr) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  removeAttributeNode: (oldAttr) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getElementsByTagName: (name) -> throw new Error "This DOM method is not implemented." + @debugInfo()

  # DOM Level 2
  getAttributeNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  setAttributeNS: (namespaceURI, qualifiedName, value) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  removeAttributeNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getAttributeNodeNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  setAttributeNodeNS: (newAttr) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getElementsByTagNameNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  hasAttribute: (name) -> @attribs.hasOwnProperty(name)
  hasAttributeNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented." + @debugInfo()

  # DOM Level 3
  setIdAttribute: (name, isId) -> if @attribs.hasOwnProperty(name) then @attribs[name].isId else isId
  setIdAttributeNS: (namespaceURI, localName, isId) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  setIdAttributeNode: (idAttr, isId) -> throw new Error "This DOM method is not implemented." + @debugInfo()


  # DOM Level 4
  getElementsByTagName: (tagname) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getElementsByTagNameNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getElementsByClassName: (classNames) -> throw new Error "This DOM method is not implemented." + @debugInfo()


  isEqualNode: (node) ->
    if not super.isEqualNode(node) then return false
    if node.namespaceURI isnt @namespaceURI then return false
    if node.prefix isnt @prefix then return false
    if node.localName isnt @localName then return false

    if node.attribs.length isnt @attribs.length then return false
    for i in [0..@attribs.length - 1]
      if not @attribs[i].isEqualNode(node.attribs[i]) then return false

    return true