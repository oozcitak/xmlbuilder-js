_ = require 'underscore'

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
  # `options.pubid` public identifier of the external subset
  # `options.sysid` system identifier of the external subset
  #
  # `options.headless` whether XML declaration and doctype will be included: true or false
  # `options.allowSurrogateChars` whether surrogates will be allowed: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  constructor: (name, options) ->
    if not name?
      throw new Error "Root element needs a name"

    options ?= {}
    @stringify = new XMLStringifier options

    # prolog
    if not options.headless
      @xmldec = new XMLDeclaration @, options

      if options.pubID? or options.sysID?
        @doctype = new XMLDocType @, options.pubID, options.sysID

    root = new XMLElement @, 'doc'
    root = root.element name
    root.isRoot = true
    root.documentObject = @
    @rootObject = root


  # Gets the root node
  root: () ->
    @rootObject


  # Ends the document and converts string
  end: (options) ->
    toString(options)


  # Converts the XML document to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    pretty = options?.pretty or false
    indent = options?.indent or '  '
    newline = options?.newline or '\n'

    r = ''
    r += @xmldec.toString options if @xmldec?
    r += @doctype.toString options if @doctype?
    r += @rootObject.toString options

    # remove trailing newline
    if pretty and r.slice(-newline.length) == newline
      r = r.slice(0, -newline.length)

    return r
