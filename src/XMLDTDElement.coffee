XMLNode = require './XMLNode'

# Represents an attribute
module.exports = class XMLDTDElement extends XMLNode


  # Initializes a new instance of `XMLDTDElement`
  #
  # `parent` the parent `XMLDocType` element
  # `name` element name
  # `value` element content (defaults to #PCDATA)
  constructor: (parent, name, value) ->
    super parent

    if not name?
      throw new Error "Missing DTD element name"
    if not value
      value = '(#PCDATA)'
    if Array.isArray value
      value = '(' + value.join(',') + ')'

    @name = @stringify.eleName name
    @value = @stringify.dtdElementValue value


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    @options.writer.set(options).dtdElement @
