{ assign } = require './Utility'

# Base class for XML writers
module.exports = class XMLWriterBase


  # Initializes a new instance of `XMLWriterBase`
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation string
  # `options.newline` newline sequence
  # `options.offset` a fixed number of indentations to add to every line
  # `options.allowEmpty` do not self close empty element tags
  # 'options.dontPrettyTextNodes' if any text is present in node, don't indent or LF
  # `options.spaceBeforeSlash` add a space before the closing slash of empty elements
  constructor: (options) ->
    options or= {}
    @options = options

    # overwrite default properties
    for own key, value of options.writer or {}
      @[key] = value

  # Filters writer options and provides defaults
  #
  # `options` writer options
  filterOptions: (options) ->
    options or= {}
    options = assign {}, @options, options

    filteredOptions = {}
    filteredOptions.pretty = options.pretty or false
    filteredOptions.allowEmpty = options.allowEmpty or false
    if filteredOptions.pretty
      filteredOptions.indent = options.indent ? '  '
      filteredOptions.newline = options.newline ? '\n'
      filteredOptions.offset = options.offset ? 0
      filteredOptions.dontPrettyTextNodes = options.dontPrettyTextNodes ? options.dontprettytextnodes ? 0
    else
      filteredOptions.indent = ''
      filteredOptions.newline = ''
      filteredOptions.offset = 0
      filteredOptions.dontPrettyTextNodes = 0

    filteredOptions.spaceBeforeSlash = options.spaceBeforeSlash ? options.spacebeforeslash ? ''
    if filteredOptions.spaceBeforeSlash is true then filteredOptions.spaceBeforeSlash = ' '

    # create local copies of these two for later
    filteredOptions.newlineDefault = filteredOptions.newline
    filteredOptions.prettyDefault = filteredOptions.pretty

    return filteredOptions

  # Returns the indentation string for the current level
  #
  # `node` current node
  # `options` writer options
  # `level` current indentation level
  space: (node, options, level) ->
    if options.pretty
      indentLevel = (level or 0) + options.offset + 1
      if indentLevel > 0
        return new Array(indentLevel).join(options.indent)
        
    return ''

  # Returns the newline string
  #
  # `node` current node
  # `options` writer options
  # `level` current indentation level
  endline: (node, options, level) ->
    options.newline