NodeType = require './NodeType'
XMLCharacterData = require './XMLCharacterData'

# Represents a comment node
module.exports = class XMLComment extends XMLCharacterData


  # Initializes a new instance of `XMLComment`
  #
  # `text` comment text
  constructor: (parent, text) ->
    super parent

    if not text?
      throw new Error "Missing comment text. " + @debugInfo()

    @name = "#comment"
    @type = NodeType.Comment
    @value = @stringify.comment text


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
    @options.writer.comment @, @options.writer.filterOptions(options)
