NodeType = require './NodeType'
XMLNode = require './XMLNode'

# Represents an attribute
module.exports = class XMLAttribute


  # Initializes a new instance of `XMLAttribute`
  #
  # `parent` the parent node
  # `name` attribute target
  # `value` attribute value
  constructor: (@parent, name, value) ->
    if @parent
      @options = @parent.options
      @stringify = @parent.stringify

    if not name?
      throw new Error "Missing attribute name. " + @debugInfo(name)

    @name = @stringify.name name
    @value = @stringify.attValue value
    @type = NodeType.Attribute
    # DOM level 3
    @isId = false
    @schemaTypeInfo = null


  # DOM level 1
  Object.defineProperty @::, 'nodeType', get: () -> @type
  Object.defineProperty @::, 'ownerElement', get: () -> @parent


  # DOM level 3
  Object.defineProperty @::, 'textContent', 
    get: () -> @value
    set: (value) -> @value = value or ''


  # DOM level 4
  Object.defineProperty @::, 'namespaceURI', get: () -> ''
  Object.defineProperty @::, 'prefix', get: () -> ''
  Object.defineProperty @::, 'localName', get: () -> @name
  Object.defineProperty @::, 'specified', get: () -> true


  # Creates and returns a deep clone of `this`
  clone: () ->
    Object.create @


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    @options.writer.attribute @, @options.writer.filterOptions(options)

  
  # Returns debug string for this node
  debugInfo: (name) -> 
    name = name or @name

    if not name?
      "parent: <" + @parent.name + ">"
    else
      "attribute: {" + name + "}, parent: <" + @parent.name + ">"


  isEqualNode: (node) ->
    if node.namespaceURI isnt @namespaceURI then return false
    if node.prefix isnt @prefix then return false
    if node.localName isnt @localName then return false
    if node.value isnt @value then return false

    return true