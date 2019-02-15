NodeType = require './NodeType'
XMLCharacterData = require './XMLCharacterData'

# Represents a processing instruction
module.exports = class XMLProcessingInstruction extends XMLCharacterData


  # Initializes a new instance of `XMLProcessingInstruction`
  #
  # `parent` the parent node
  # `target` instruction target
  # `value` instruction value
  constructor: (parent, target, value) ->
    super parent

    if not target?
      throw new Error "Missing instruction target. " + @debugInfo()

    @type = NodeType.ProcessingInstruction
    @target = @stringify.insTarget target
    @name = @target
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
    @options.writer.processingInstruction @, @options.writer.filterOptions(options)


  isEqualNode: (node) ->
    if not super.isEqualNode(node) then return false
    if node.target isnt @target then return false

    return true