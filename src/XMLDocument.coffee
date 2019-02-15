{ isPlainObject } = require './Utility'

XMLDOMImplementation = require './XMLDOMImplementation'
XMLDOMConfiguration = require './XMLDOMConfiguration'
XMLNode = require './XMLNode'
NodeType = require './NodeType'
XMLStringifier = require './XMLStringifier'
XMLStringWriter = require './XMLStringWriter'

# Represents an XML builder
module.exports = class XMLDocument extends XMLNode


  # Initializes a new instance of `XMLDocument`
  #
  # `options.keepNullNodes` whether nodes with null values will be kept
  #     or ignored: true or false
  # `options.keepNullAttributes` whether attributes with null values will be
  #     kept or ignored: true or false
  # `options.ignoreDecorators` whether decorator strings will be ignored when
  #     converting JS objects: true or false
  # `options.separateArrayItems` whether array items are created as separate
  #     nodes when passed as an object value: true or false
  # `options.noDoubleEncoding` whether existing html entities are encoded:
  #     true or false
  # `options.stringify` a set of functions to use for converting values to
  #     strings
  # `options.writer` the default XML writer to use for converting nodes to
  #     string. If the default writer is not set, the built-in XMLStringWriter
  #     will be used instead.
  constructor: (options) ->
    super null

    @name = "#document"
    @type = NodeType.Document
    @documentURI = null
    @domConfig = new XMLDOMConfiguration()

    options or= {}
    if not options.writer then options.writer = new XMLStringWriter()

    @options = options
    @stringify = new XMLStringifier options

  # DOM level 1
  Object.defineProperty @::, 'implementation', value: new XMLDOMImplementation()
  Object.defineProperty @::, 'doctype', get: () ->
    for child in @children
      if child.type is NodeType.DocType
        return child
    return null
  Object.defineProperty @::, 'documentElement', get: () -> @rootObject or null


  # DOM level 3
  Object.defineProperty @::, 'inputEncoding', get: () -> null
  Object.defineProperty @::, 'strictErrorChecking', get: () -> false
  Object.defineProperty @::, 'xmlEncoding', get: () ->
    if @children.length isnt 0 and @children[0].type is NodeType.Declaration
      return @children[0].encoding
    else
      return null
  Object.defineProperty @::, 'xmlStandalone', get: () ->
    if @children.length isnt 0 and @children[0].type is NodeType.Declaration
      return @children[0].standalone is 'yes'
    else
      return false
  Object.defineProperty @::, 'xmlVersion', get: () ->
    if @children.length isnt 0 and @children[0].type is NodeType.Declaration
      return @children[0].version
    else
      return "1.0"


  # DOM level 4
  Object.defineProperty @::, 'URL', get: () -> @documentURI
  Object.defineProperty @::, 'origin', get: () -> null
  Object.defineProperty @::, 'compatMode', get: () -> null
  Object.defineProperty @::, 'characterSet', get: () -> null
  Object.defineProperty @::, 'contentType', get: () -> null


  # Ends the document and passes it to the given XML writer
  #
  # `writer` is either an XML writer or a plain object to pass to the
  # constructor of the default XML writer. The default writer is assigned when
  # creating the XML document. Following flags are recognized by the
  # built-in XMLStringWriter:
  #   `writer.pretty` pretty prints the result
  #   `writer.indent` indentation for pretty print
  #   `writer.offset` how many indentations to add to every line for pretty print
  #   `writer.newline` newline sequence for pretty print
  end: (writer) ->
    writerOptions = {}

    if not writer
      writer = @options.writer
    else if isPlainObject(writer)
      writerOptions = writer
      writer = @options.writer

    writer.document @, writer.filterOptions(writerOptions)


  # Converts the XML document to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    @options.writer.document @, @options.writer.filterOptions(options)

  # DOM level 1 functions to be implemented later
  createElement: (tagName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createDocumentFragment: () -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createTextNode: (data) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createComment: (data) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createCDATASection: (data) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createProcessingInstruction: (target, data) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createAttribute: (name) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createEntityReference: (name) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getElementsByTagName: (tagname) -> throw new Error "This DOM method is not implemented." + @debugInfo()

  # DOM level 2 functions to be implemented later
  importNode: (importedNode, deep) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createElementNS: (namespaceURI, qualifiedName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createAttributeNS: (namespaceURI, qualifiedName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getElementsByTagNameNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getElementById: (elementId) -> throw new Error "This DOM method is not implemented." + @debugInfo()

  # DOM level 3 functions to be implemented later
  adoptNode: (source) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  normalizeDocument: () ->  throw new Error "This DOM method is not implemented." + @debugInfo()
  renameNode: (node, namespaceURI, qualifiedName) -> throw new Error "This DOM method is not implemented." + @debugInfo()

  # DOM level 4 functions to be implemented later
  getElementsByClassName: (classNames) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createEvent: (eventInterface) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createRange: () -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createNodeIterator: (root, whatToShow, filter) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  createTreeWalker: (root, whatToShow, filter) -> throw new Error "This DOM method is not implemented." + @debugInfo()