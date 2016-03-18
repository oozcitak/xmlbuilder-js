create = require 'lodash/create'

XMLNode = require './XMLNode'

# Represents a comment node
module.exports = class XMLComment extends XMLNode


  # Initializes a new instance of `XMLComment`
  #
  # `text` comment text
  constructor: (parent, text) ->
    super parent

    if not text?
      throw new Error "Missing comment text"

    @text = @stringify.comment text


  # Creates and returns a deep clone of `this`
  clone: () ->
    create XMLComment.prototype, @


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    @options.writer.set(options).comment @
