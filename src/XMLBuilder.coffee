isPlainObject = require 'lodash/isPlainObject'

XMLStringifier = require './XMLStringifier'
XMLElement = require './XMLElement'
XMLStringWriter = require './XMLStringWriter'

# Represents an XML builder
module.exports = class XMLBuilder


  # Initializes a new instance of `XMLBuilder`
  # and creates the XML prolog
  #
  # `name` name of the root element
  #
  # `options.version` A version number string, e.g. 1.0
  # `options.encoding` Encoding declaration, e.g. UTF-8
  # `options.standalone` standalone document declaration: true or false
  #
  # `options.pubID` public identifier of the external subset
  # `options.sysID` system identifier of the external subset
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
  #
  # `options.writer` the default XML writer to use for converting nodes to
  #     string. If the default writer is not set, the built-in XMLStringWriter
  #     will be used instead.
  constructor: (name, options) ->
    if not name?
      throw new Error "Root element needs a name"

    options ?= {}
    if not options.writer then options.writer = new XMLStringWriter()

    @options = options
    @stringify = new XMLStringifier options

    temp = new XMLElement @, 'doc' # temporary node so that we can call element()
    root = temp.element name
    root.isRoot = true
    root.documentObject = @
    @rootObject = root

    # prolog
    if not options.headless
      root.declaration options

      if options.pubID? or options.sysID?
        root.doctype options


  # Gets the xml declaration
  dec: () -> @xmldec


  # Gets the document type declaration
  dtd: () -> @doctype


  # Gets the root node
  root: () -> @rootObject


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
    if not writer
      writer = @options.writer
    else if isPlainObject(writer)
      writerOptions = writer
      writer = @options.writer.set(writerOptions)

    writer.document @


  # Converts the XML document to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    @options.writer.set(options).document @
