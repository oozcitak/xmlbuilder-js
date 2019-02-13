NodeType = require './NodeType'
XMLNode = require './XMLNode'

# Represents an attribute
module.exports = class XMLAttribute extends XMLNode


  # Initializes a new instance of `XMLAttribute`
  #
  # `parent` the parent node
  # `name` attribute target
  # `value` attribute value
  constructor: (parent, name, value) ->
    super parent

    if not name?
      throw new Error "Missing attribute name. " + @debugInfo(name)

    @name = @stringify.name name
    @value = @stringify.attValue value
    @specified = true
    @type = NodeType.Attribute

    # DOM level 1
    Object.defineProperty @, 'ownerElement', get: () -> @parent


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