_ = require 'underscore'

XMLStringifier = require './XMLStringifier'
XMLDeclaration = require './XMLDeclaration'
XMLDocType = require './XMLDocType'
XMLNode = require './XMLNode'

# Represents an XML builder
module.exports = class XMLBuilder


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

    options = _.extend { 'version': '1.0' }, xmldec, doctype, options
    @stringify = new XMLStringifier options

    @children = []
    # prolog
    if not options.headless
      child = new XMLDeclaration @, options
      @children.push child

      if options.ext?
        child = new XMLDocType @, options
        @children.push child

    root = XMLNode::makeElement @, name
    if _.isArray root
      if root.length > 1
        throw new Error "Multiple root elements are not allowed"
      else 
        root = root[0]
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
