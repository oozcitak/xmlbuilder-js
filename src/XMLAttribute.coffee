_ = require 'underscore'

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

    # evaluate if function
    value = value.apply() if _.isFunction value

    @name = @stringify.attName name
    @value = @stringify.attValue value


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    ' ' + @name + '="' + @value + '"'
