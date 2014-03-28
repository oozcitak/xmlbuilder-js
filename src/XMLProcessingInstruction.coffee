_ = require 'lodash-node'

# Represents a processing instruction
module.exports = class XMLProcessingInstruction


  # Initializes a new instance of `XMLProcessingInstruction`
  #
  # `parent` the parent node
  # `target` instruction target
  # `value` instruction value
  constructor: (parent, target, value) ->
    @stringify = parent.stringify

    if not target?
      throw new Error "Missing instruction target"

    @target = @stringify.insTarget target
    @value = @stringify.insValue value if value


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

    r += '<?'
    r += @target
    r += ' ' + @value if @value
    r += '?>'

    r += newline if pretty

    return r
