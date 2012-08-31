XMLFragment = require './XMLFragment'

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
  constructor: (name, xmldec, doctype) ->
    @children = []
    @rootObject = null

    if name?
      xmldec ?= { 'version': '1.0' }
      @begin name, xmldec, doctype


  # Creates the XML prolog and the root element
  #
  # `name` name of the root element
  #
  # `xmldec.version` A version number string, e.g. 1.0
  # `xmldec.encoding` Encoding declaration, e.g. UTF-8
  # `xmldec.standalone` standalone document declaration: true or false
  #
  # `doctype.ext` the external subset containing markup declarations
  begin: (name, xmldec, doctype) ->
    if not name?
      throw new Error "Root element needs a name"
    @children = []
    name = '' + name or ''

    if xmldec? and not xmldec.version?
      throw new Error "Version number is required"

    if xmldec?
      xmldec.version = '' + xmldec.version or ''
      if not xmldec.version.match /1\.[0-9]+/
        throw new Error "Invalid version number: " + xmldec.version
      att = { version: xmldec.version }

      if xmldec.encoding?
        xmldec.encoding = '' + xmldec.encoding or ''
        if not xmldec.encoding.match /[A-Za-z](?:[A-Za-z0-9._-]|-)*/
          throw new Error "Invalid encoding: " + xmldec.encoding
        att.encoding = xmldec.encoding

      if xmldec.standalone?
        att.standalone = if xmldec.standalone then "yes" else "no"

      child = new XMLFragment @, '?xml', att
      @children.push child

    if doctype?
      att = { name: name }
      
      if doctype.ext?
        doctype.ext = '' + doctype.ext or ''
        att.ext = doctype.ext

      child = new XMLFragment @, '!DOCTYPE', att
      @children.push child

    root = new XMLFragment @, name, {}
    root.isRoot = true
    root.documentObject = @
    @children.push root
    @rootObject = root

    return root


  # Gets the root node
  root: () ->
    return @rootObject


  # Converts the XML document to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    r = ''
    for child in @children
      r += child.toString options

    return r


module.exports = XMLBuilder

