XMLWriterBase = require './XMLWriterBase'

# Prints XML nodes as plain text
module.exports = class XMLStringWriter extends XMLWriterBase


  # Initializes a new instance of `XMLStringWriter`
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation string
  # `options.newline` newline sequence
  # `options.offset` a fixed number of indentations to add to every line
  # `options.allowEmpty` do not self close empty element tags
  # 'options.dontPrettyTextNodes' if any text is present in node, don't indent or LF
  # `options.spaceBeforeSlash` add a space before the closing slash of empty elements
  constructor: (options) ->
    super(options)

  document: (doc, options) ->
    options = @filterOptions options
    
    r = ''
    for child in doc.children
      r += @writeChildNode child, options, 0

    # remove trailing newline
    if options.pretty and r.slice(-options.newline.length) == options.newline
      r = r.slice(0, -options.newline.length)

    return r