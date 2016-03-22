# Represents an attribute
module.exports = class XMLAttribute


  # Initializes a new instance of `XMLAttribute`
  #
  # `parent` the parent node
  # `name` attribute target
  # `value` attribute value
  constructor: (parent, name, value) ->
    @options = parent.options
    @stringify = parent.stringify

    if not name?
      throw new Error "Missing attribute name of element " + parent.name
    if not value?
      throw new Error "Missing attribute value for attribute " + name + " of element " + parent.name

    @name = @stringify.attName name
    @value = @stringify.attValue value


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
    @options.writer.set(options).attribute @

