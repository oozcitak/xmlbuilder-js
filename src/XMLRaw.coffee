create = require 'lodash/object/create'

XMLNode = require './XMLNode'

# Represents a  raw node
module.exports = class XMLRaw extends XMLNode


  # Initializes a new instance of `XMLRaw`
  #
  # `text` raw text
  constructor: (parent, text) ->
    super parent

    if not text?
      throw new Error "Missing raw text"

    @value = @stringify.raw text


  # Creates and returns a deep clone of `this`
  clone: () ->
    create XMLRaw.prototype, @


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options?.pretty or false
    indent = options?.indent ? '  '
    offset = options?.offset ? 0
    newline = options?.newline ? '\n'
    level or= 0

    space = new Array(level + offset + 1).join(indent)

    r = ''

    r += space if pretty

    r += @value

    r += newline if pretty

    return r
