{ isObject } = require './Utility'

XMLNode = require './XMLNode'

# Represents the XML declaration
module.exports = class XMLDeclaration extends XMLNode


  # Initializes a new instance of `XMLDeclaration`
  #
  # `parent` the document object
  #
  # `version` A version number string, e.g. 1.0
  # `encoding` Encoding declaration, e.g. UTF-8
  # `standalone` standalone document declaration: true or false
  constructor: (parent, version, encoding, standalone) ->
    super parent

    # arguments may also be passed as an object
    if isObject version
      { version, encoding, standalone } = version

    version = '1.0' if not version

    @version = @stringify.xmlVersion version
    @encoding = @stringify.xmlEncoding encoding if encoding?
    @standalone = @stringify.xmlStandalone standalone if standalone?


  # Converts to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    @options.writer.set(options).declaration @

