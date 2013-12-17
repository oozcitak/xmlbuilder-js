_ = require 'underscore'

XMLNode = require './XMLNode'

# Represents a  CDATA node
module.exports = class XMLCData extends XMLNode


  # Initializes a new instance of `XMLCData`
  #
  # `text` CDATA text
  constructor: (parent, text) ->
    super parent

    if not text?
      throw new Error "Missing CDATA text"
          
    @text = @stringify.cdata text


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options?.pretty or false
    indent = options?.indent or '  '
    newline = options?.newline or '\n'
    level or= 0

    space = new Array(level + 1).join(indent)

    r = ''

    r += space if pretty

    r += '<![CDATA[' + @text + ']]>'

    r += newline if pretty

    return r
