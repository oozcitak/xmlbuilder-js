XMLNode = require './XMLNode'

# Represents a processing instruction
module.exports = class XMLProcessingInstruction extends XMLNode


  # Initializes a new instance of `XMLProcessingInstruction`
  #
  # `parent` the parent node
  # `target` instruction target
  # `value` instruction value
  constructor: (parent, target, value) ->
    super parent

    if not target?
      throw new Error "Missing instruction target"

    @target = @stringify.insTarget target
    @value = @stringify.insValue value if value


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
    @options.writer.set(options).processingInstruction @
