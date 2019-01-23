XMLDeclaration = require './XMLDeclaration'
XMLDocType = require './XMLDocType'

XMLCData = require './XMLCData'
XMLComment = require './XMLComment'
XMLElement = require './XMLElement'
XMLRaw = require './XMLRaw'
XMLText = require './XMLText'
XMLProcessingInstruction = require './XMLProcessingInstruction'
XMLDummy = require './XMLDummy'

XMLDTDAttList = require './XMLDTDAttList'
XMLDTDElement = require './XMLDTDElement'
XMLDTDEntity = require './XMLDTDEntity'
XMLDTDNotation = require './XMLDTDNotation'

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
      # skip dummy nodes
      if child instanceof XMLDummy then continue

      r += switch
        when child instanceof XMLDeclaration then @declaration child, options, 0
        when child instanceof XMLDocType     then @docType     child, options, 0
        when child instanceof XMLComment     then @comment     child, options, 0
        when child instanceof XMLProcessingInstruction then @processingInstruction child, options, 0
        else @element child, options, 0

    # remove trailing newline
    if options.pretty and r.slice(-options.newline.length) == options.newline
      r = r.slice(0, -options.newline.length)

    return r