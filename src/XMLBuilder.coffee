XMLFragment = require './XMLFragment'

# Represents an XML builder
class XMLBuilder extends XMLFragment

  # Initializes a new instance of `XMLBuilder`
  constructor: () -> super '', {}, ''


  # Converts the XML document to string
  #
  #
  # `options.Pretty` pretty prints the result
  # `options.Indent` indentation for pretty print
  # `options.NewLine` newline sequence for pretty print
  toString: (options) ->
    pretty = options? and options.Pretty or false
    indent = options? and options.Indent or '  '
    newline = options? and options.NewLine or '\n'

    r = ''
    for child in @children
      r += child.toString options

    return r


module.exports = XMLBuilder
