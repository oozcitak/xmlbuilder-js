{ assign, isFunction } = require './Utility'

XMLDocument = require './XMLDocument'
XMLDocumentCB = require './XMLDocumentCB'
XMLStringWriter = require './XMLStringWriter'
XMLStreamWriter = require './XMLStreamWriter'

# Creates a new document and returns the root node for
# chain-building the document tree
#
# `name` name of the root element
#
# `xmldec.version` A version number string, e.g. 1.0
# `xmldec.encoding` Encoding declaration, e.g. UTF-8
# `xmldec.standalone` standalone document declaration: true or false
#
# `doctype.pubID` public identifier of the external subset
# `doctype.sysID` system identifier of the external subset
#
# `options.headless` whether XML declaration and doctype will be included:
#     true or false
# `options.allowSurrogateChars` whether surrogates will be allowed: true or
#     false
# `options.skipNullAttributes` whether attributes with null values will be
#     ignored: true or false
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
module.exports.create = (name, xmldec, doctype, options) ->
  if not name?
    throw new Error "Root element needs a name"

  options = assign { }, xmldec, doctype, options

  # create the document node
  doc = new XMLDocument(options)
  # add the root node
  root = doc.element name

  # prolog
  if not options.headless
    doc.declaration options

    if options.pubID? or options.sysID?
      doc.doctype options

  return root

# Creates a new document and returns the document node for
# chain-building the document tree
#
# `options.allowSurrogateChars` whether surrogates will be allowed: true or
#     false
# `options.skipNullAttributes` whether attributes with null values will be
#     ignored: true or false
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
#
# `onData` the function to be called when a new chunk of XML is output. The
#          string containing the XML chunk is passed to `onData` as its single
#          argument.
# `onEnd`  the function to be called when the XML document is completed with
#          `end`. `onEnd` does not receive any arguments.
module.exports.begin = (options, onData, onEnd) ->
  if isFunction(options)
    [onData, onEnd] = [options, onData]
    options = {}

  if onData
    new XMLDocumentCB(options, onData, onEnd)
  else
    new XMLDocument(options)

module.exports.stringWriter = (options) ->
  new XMLStringWriter(options)

module.exports.streamWriter = (stream, options) ->
  new XMLStreamWriter(stream, options)
