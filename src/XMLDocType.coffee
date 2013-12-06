_ = require 'underscore'

XMLNode = require './XMLNode'

# Represents doctype declaration
module.exports = class XMLDocType extends XMLNode


  # Initializes a new instance of `XMLDocType`
  #
  # `parent` the document object
  #
  # `options.ext` the external subset containing markup declarations
  constructor: (parent, options) ->
    super parent

    if options.ext?
      @ext = @stringify.xmlExternalSubset options.ext


  # Converts to string
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

    # open tag
    if pretty
      r += space
    r += '<!DOCTYPE'

    # attributes
    r += ' ' + @parent.root().name
    if @ext?
      r += ' ' + @ext

    # close tag
    r += '>'

    if pretty
      r += newline

    return r
