create = require 'lodash-node/modern/objects/create'
isObject = require 'lodash-node/modern/objects/isObject'

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

    if version?
      @version = @stringify.xmlVersion version

    if encoding?
      @encoding = @stringify.xmlEncoding encoding

    if standalone?
      @standalone = @stringify.xmlStandalone standalone


  # Creates and returns a deep clone of `this`
  clone: () ->
    create XMLDeclaration.prototype, @


  # Converts to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options?.pretty or false
    indent = options?.indent ? '  '
    offset = options?.offset ? 0
    newline = options?.newline ? '\n'
    level or= 0

    space = new Array(level + offset + 1).join(indent)

    r = ''

    r += space if pretty

    # open tag
    r += '<?xml'

    # attributes
    if @version?
      r += ' version="' + @version + '"'
    if @encoding?
      r += ' encoding="' + @encoding + '"'
    if @standalone?
      r += ' standalone="' + @standalone + '"'

    # close tag
    r += '?>'

    r += newline if pretty

    return r
