XMLStringifier = require './XMLStringifier'
XMLDeclaration = require './XMLDeclaration'
XMLDocType = require './XMLDocType'
XMLElement = require './XMLElement'

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
  # `options.headless` whether XML declaration and doctype will be included: true or false
  # `options.allowSurrogateChars` whether surrogates will be allowed: true or false
  # `options.skipNullAttributes` whether attributes with null values will be ignored: true or false
  # `options.ignoreDecorators` whether decorator strings will be ignored when converting JS objects: true or false
  # `options.separateArrayItems` whether array items are created as separate nodes when passed as an object value: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  constructor: (name, options) ->
    if not name?
      throw new Error "Root element needs a name"

    options ?= {}
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


  # Gets the root node
  root: () ->
    @rootObject


  # Ends the document and converts string
  end: (options) ->
    @toString(options)


  # Converts the XML document to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    pretty = options?.pretty or false
    indent = options?.indent ? '  '
    offset = options?.offset ? 0
    newline = options?.newline ? '\n'

    r = ''
    r += @xmldec.toString options if @xmldec?
    r += @doctype.toString options if @doctype?
    r += @rootObject.toString options

    # remove trailing newline
    if pretty and r.slice(-newline.length) == newline
      r = r.slice(0, -newline.length)

    return r
