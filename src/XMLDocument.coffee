{ isPlainObject } = require './Utility'

XMLNode = require './XMLNode'
XMLStringifier = require './XMLStringifier'
XMLStringWriter = require './XMLStringWriter'

# Represents an XML builder
module.exports = class XMLDocument extends XMLNode


  # Initializes a new instance of `XMLDocument`
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
  constructor: (options) ->
    super null

    options or= {}
    if not options.writer then options.writer = new XMLStringWriter()

    @options = options
    @stringify = new XMLStringifier options

    @isDocument = true


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
