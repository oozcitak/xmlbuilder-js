XMLFragment = require './XMLFragment'

# Represents an XML builder
class XMLBuilder extends XMLFragment

  # Initializes a new instance of `XMLBuilder`
  constructor: () -> super null, '', {}, ''


  # Starts building an XML document
  begin: () ->
    @children = []
    return @

  # Converts the XML document to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    r = ''
    for child in @children
      r += child.toString options

    return r


module.exports = XMLBuilder
