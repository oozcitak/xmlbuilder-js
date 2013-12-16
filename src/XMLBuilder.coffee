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
  # `options.dtd` document type declaration with optional external subset
  # `options.dtd.pubID` the public identifier of the external subset
  # `options.dtd.sysID` the system identifier of the external subset
  #
  # `options.headless` whether XML declaration and doctype will be included: true or false
  # `options.allowSurrogateChars` whether surrogates will be allowed: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  constructor: (name, options) ->
    if not name?
      throw new Error "Root element needs a name"

    options ?= {}

    # support legacy ext attribute
    if options.ext and not options.dtd
      options.dtd = options.ext
      
    @stringify = new XMLStringifier options

    # prolog
    if not options.headless
      @xmldec = new XMLDeclaration @, options

      if options.dtd?
        @doctype = new XMLDocType @, options

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
    r = ''
    r += @xmldec.toString options if @xmldec?
    r += @doctype.toString options if @doctype?
    r += @rootObject.toString options
