_ = require 'underscore'

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
  #
  # `options.allowSurrogateChars` whether surrogates will be allowed: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  constructor: (name, xmldec, doctype, options) ->
    @children = []
    @rootObject = null

    # shift arguments
    if XMLBuilder.is(name, 'Object')
      [xmldec, doctype] = [name, xmldec]
      name = null

    if name?
      name = '' + name or ''
      xmldec ?= { 'version': '1.0' }

    @options = _.defaults options or {}, XMLBuilder.defaultOptions
    @allowSurrogateChars = @options.allowSurrogateChars
    @stringify = @options.stringify

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
      att = {}
      if name?
        att.name = name

      if doctype.ext?
        doctype.ext = '' + doctype.ext or ''
        att.ext = doctype.ext

      child = new XMLFragment @, '!DOCTYPE', att
      @children.push child

    if name?
      @begin name


  # Creates the root element
  #
  # `name` name of the root element
  begin: (name, xmldec, doctype) ->
    if not name?
      throw new Error "Root element needs a name"

    if @rootObject
      # Erase old instance
      @children = []
      @rootObject = null

    if xmldec?
      # This will be deprecated in the future. XML prolog should be
      #supplied to the constructor
      doc = new XMLBuilder name, xmldec, doctype
      return doc.root()

    name = @stringify.eleName name
    root = new XMLFragment @, name, {}
    root.isRoot = true
    root.documentObject = @
    @children.push root
    @rootObject = root

    return root


  # Gets the root node
  root: () ->
    return @rootObject


  # Ends the document and converts string
  end: (options) ->
    return toString(options)


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


  # Default options
  @defaultOptions:
    allowSurrogateChars: false
    stringify:
      eleName: (val) ->
        val = '' + val or ''
        XMLBuilder.assertLegalChar '' + val
      eleText: (val) ->
        val = '' + val or ''
        XMLBuilder.assertLegalChar XMLBuilder.escape '' + val
      cdata: (val) ->
        val = '' + val or ''
        if val.match /]]>/
          throw new Error "Invalid CDATA text: " + val
        val = XMLBuilder.assertLegalChar '' + val
        '<![CDATA[' + val + ']]>'
      comment: (val) ->
        val = '' + val or ''
        if val.match /--/
          throw new Error "Comment text cannot contain double-hypen: " + val
        val = XMLBuilder.assertLegalChar XMLBuilder.escape '' + val
        '<!-- ' + val + ' -->'
      raw: (val) ->
        '' + val or ''
      attName: (val) ->
        '' + val or ''
      attValue: (val) ->
        val = '' + val or ''
        XMLBuilder.escape '' + val
      insTarget: (val) ->
        '' + val or ''
      insValue: (val) ->
        val = '' + val or ''
        if val.match /\?>/
          throw new Error "Invalid processing instruction value: " + val
        val

  # Checks whether the given object is of the given type
  #
  # `obj` the object to check
  # `type` the type to compare to. (String, Number, Object, Date, ...)
  @is: (obj, type) ->
    clas = Object.prototype.toString.call(obj).slice(8, -1)
    return obj? and clas is type


  # Checks whether the given string contains legal characters
  # Fails with an exception on error
  #
  # `str` the string to check
  @assertLegalChar: (str) =>
    if @allowSurrogateChars
      chars = /[\u0000-\u0008\u000B-\u000C\u000E-\u001F\uFFFE-\uFFFF]/
    else
      chars = /[\u0000-\u0008\u000B-\u000C\u000E-\u001F\uD800-\uDFFF\uFFFE-\uFFFF]/
    chr = str.match chars
    if chr
      throw new Error "Invalid character (#{chr}) in string: #{str} at index #{chr.index}"

    return str


  # Escapes special characters <, >, ', ", &
  #
  # `str` the string to escape
  @escape: (str) ->
    return str.replace(/&/g, '&amp;')
              .replace(/</g,'&lt;').replace(/>/g,'&gt;')
              .replace(/'/g, '&apos;').replace(/"/g, '&quot;')


module.exports = XMLBuilder

