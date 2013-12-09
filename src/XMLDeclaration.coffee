_ = require 'underscore'

XMLNode = require './XMLNode'

# Represents the XML declaration
module.exports = class XMLDeclaration extends XMLNode


  # Initializes a new instance of `XMLDeclaration`
  #
  # `parent` the document object
  #
  # `options.version` A version number string, e.g. 1.0
  # `options.encoding` Encoding declaration, e.g. UTF-8
  # `options.standalone` standalone document declaration: true or false
  constructor: (parent, options) ->
    super parent

    options = _.extend { 'version': '1.0' }, options

    if options.version?
      @version = @stringify.xmlVersion options.version

    if options.encoding?
      @encoding = @stringify.xmlEncoding options.encoding

    if options.standalone?
      @standalone = @stringify.xmlStandalone options.standalone


  # Converts to string
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

    # open tag
    if pretty
      r += space
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

    if pretty
      r += newline

    return r
