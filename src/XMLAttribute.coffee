create = require 'lodash-node/modern/objects/create'

# Represents an attribute
module.exports = class XMLAttribute


  # Initializes a new instance of `XMLAttribute`
  #
  # `parent` the parent node
  # `name` attribute target
  # `value` attribute value
  constructor: (parent, name, value) ->
    @stringify = parent.stringify

    if not name?
      throw new Error "Missing attribute name"
    if not value?
      throw new Error "Missing attribute value"

    @name = @stringify.attName name
    @value = @stringify.attValue value


  # Creates and returns a deep clone of `this`
  clone: () ->
    create XMLAttribute.prototype, @


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    ' ' + @name + '="' + @value + '"'
