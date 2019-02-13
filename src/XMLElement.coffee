{ isObject, isFunction, getValue } = require './Utility'

XMLNode = require './XMLNode'
NodeType = require './NodeType'
XMLAttribute = require './XMLAttribute'

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
    @attributes = {}

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
    Object.defineProperty @, 'tagName', get: () -> @name

  # Creates and returns a deep clone of `this`
  #
  clone: () ->
    clonedSelf = Object.create @

    # remove document element
    if clonedSelf.isRoot
      clonedSelf.documentObject = null

    # clone attributes
    clonedSelf.attributes = {}
    for own attName, att of @attributes
      clonedSelf.attributes[attName] = att.clone()

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
        @attributes[name] = new XMLAttribute @, name, ""
      else if value?
        @attributes[name] = new XMLAttribute @, name, value

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
        delete @attributes[attName]
    else
      delete @attributes[name]

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
  getAttribute: (name) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  setAttribute: (name, value) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getAttributeNode: (name) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  setAttributeNode: (newAttr) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  removeAttributeNode: (oldAttr) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getElementsByTagName: (name) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  normalize: () -> throw new Error "This DOM method is not implemented." + @debugInfo()
