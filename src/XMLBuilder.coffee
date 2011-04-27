XMLFragment = require './XMLFragment'

# Represents an XML builder
class XMLBuilder extends XMLFragment


  # Initializes a new instance of `XMLBuilder`
  constructor: () -> super null, '', {}, ''


  # Creates the XML prolog
  #
  # `name` name of the root element
  #
  # `xmldec.version` A version number string, e.g. 1.0
  # `xmldec.encoding` Encoding declaration, e.g. UTF-8
  # `xmldec.standalone` standalone document declaration: true or false
  #
  # `doctype.name` name of the root element
  # `doctype.ext` the external subset containing markup declarations
  begin: (name, xmldec, doctype, options) ->
    if not name?
      throw new Error "Root element needs a name"
    @children = []
    name = '' + name or ''

    if xmldec? and not xmldec.version?
      throw new Error "Version number is required"
    if doctype? and not doctype.name?
      throw new Error "Document name is required"

    if xmldec?
      xmldec.version = '' + xmldec.version or ''
      if not xmldec.version.match @val.VersionNum
        throw new Error "Invalid version number: " + xmldec.version
      att = { version: xmldec.version }

      if xmldec.encoding?
        xmldec.encoding = '' + xmldec.encoding or ''
        if not xmldec.encoding.match @val.EncName
          throw new Error "Invalid encoding: " + xmldec.encoding
        att.encoding = xmldec.encoding

      if xmldec.standalone?
        att.standalone = if xmldec.standalone then "yes" else "no"

      child = new XMLFragment @, '?xml', att
      @children.push child

    if doctype?
      doctype.name = '' + doctype.name or ''
      if not String(doctype.name).match "^" + @val.Name + "$"
        throw new Error "Invalid document name: " + doctype.name
      att = { name: doctype.name }
      
      if doctype.ext?
        doctype.ext = '' + doctype.ext or ''
        if not String(doctype.ext).match "^" + @val.ExternalID + "$"
          throw new Error "Invalid external ID: " + doctype.ext
        att.ext = doctype.ext

      child = new XMLFragment @, '!DOCTYPE', att
      @children.push child

    root = new XMLFragment @, name, {}
    @children.push root

    return root


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

