_ = require 'underscore'

XMLFragment = require './XMLFragment'
XMLStringifier = require './XMLStringifier'

# Represents an XML builder
class XMLBuilder


  # Initializes a new instance of `XMLBuilder`
  # and creates the XML prolog
  #
  # `name` name of the root element
  #
  # `xmldec.version` A version number string, e.g. 1.0
  # `xmldec.encoding` Encoding declaration, e.g. UTF-8
  # `xmldec.standalone` standalone document declaration: true or false
  #
  # `doctype.ext` the external subset containing markup declarations
  #
  # `options.headless` whether XML declaration and doctype will be included: true or false
  # `options.allowSurrogateChars` whether surrogates will be allowed: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  constructor: (name, xmldec, doctype, options) ->
    if not name?
      throw new Error "Root element needs a name"

    @children = []
    @rootObject = null

    @stringify = new XMLStringifier options

    name = @stringify.eleName name

    if not options?.headless
      xmldec ?= { 'version': '1.0' }
      decatts = {}

      if not xmldec.version?
        xmldec.version = '1.0'

      xmldec.version = '' + xmldec.version or ''
      if not xmldec.version.match /1\.[0-9]+/
        throw new Error "Invalid version number: " + xmldec.version
      decatts.version = xmldec.version

      if xmldec.encoding?
        xmldec.encoding = '' + xmldec.encoding or ''
        if not xmldec.encoding.match /[A-Za-z](?:[A-Za-z0-9._-]|-)*/
          throw new Error "Invalid encoding: " + xmldec.encoding
        decatts.encoding = xmldec.encoding

      if xmldec.standalone?
        decatts.standalone = if xmldec.standalone then "yes" else "no"

      child = new XMLFragment @, '?xml', decatts
      @children.push child

      if doctype?
        docatts = {}
        if name?
          docatts.name = name

        if doctype.ext?
          doctype.ext = '' + doctype.ext or ''
          docatts.ext = doctype.ext

        child = new XMLFragment @, '!DOCTYPE', docatts
        @children.push child

    @begin name


  # Creates the root element
  #
  # `name` name of the root element
  begin: (name) ->
    if not name?
      throw new Error "Root element needs a name"

    if @rootObject
      # Erase old instance
      @children = []
      @rootObject = null

    name = @stringify.eleName name
    root = new XMLFragment @, name, {}
    root.isRoot = true
    root.documentObject = @
    @children.push root
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
    for child in @children
      r += child.toString options
    r


module.exports = XMLBuilder

