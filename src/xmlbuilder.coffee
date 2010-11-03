# xmlbuilder
# ----------
# An XML builder for node.js
# Copyright Ozgur Ozcitak 2010
# Licensed under the MIT license

# Represents an XMl builder
class XMLBuilder

  decorators:
    OpenTag: '<'
    CloseTag: '>'
    EndTag: '/'
    AttDelim: '='
    AttSep: ' '
    Quote: '"'
    Space: ' '
    Indent: '  '
    Newline: '\n'

  settings:
    ValidateNames: true
    ValidateValues: true

  # Regular expressions to validate tokens
  # See: http://www.w3.org/TR/xml/ 
  # Supplementary Unicode code points not supported
  validators:
    Space:
      "(?:\u0020|\u0009|\u000D|\u000A)+"
    Char:
      "\u0009|\u000A|\u000D|[\u0020-\uD7FF]|[\uE000-\uFFFD]"
    NameStartChar:
      ":|[A-Z]|_|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|" +
      "[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|" + 
      "[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]"
    NameChar:
      ":|[A-Z]|_|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|" +
      "[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|" + 
      "[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]" +
      "-|\.|[0-9]|\u00B7|[\u0300-\u036F]|[\u203F-\u2040]"
    CharRef:
      "&#[0-9]+;|&#x[0-9a-fA-F]+;"
    CharData:
      "(?![^<&]*]]>[^<&]*)[^<&]*"


  # Initializes a new instance of `XMLBuilder`
  # `options.validateNames` true to validate element names
  # `options.validateValues` true to validate element values
  constructor: (options) ->

    if options?
      @settings.ValidateNames = options.validateNames if options.validateNames?
      @settings.ValidateValues = options.validateValues if options.validateValues?

    # build compound validation strings
    @validators.Name = @validators.NameStartChar + '(?:' + @validators.NameChar + ')*'
    @validators.NMToken = '(?:' + @validators.NameChar + ')+'
    @validators.EntityRef = '&' + @validators.Name + ';'
    @validators.Reference = @validators.EntityRef + '|' + @validators.CharRef
    @validators.PEReference = '%' + @validators.Name + ';'
    if @decorators.Quote == '"'
      @validators.EntityValue = '(?:[^%&"]|%' + @validators.Name + ';|&' + @validators.Name + ';)*'
    else
      @validators.EntityValue = "'(?:[^%&']|%" + @validators.Name + ';|&' + @validators.Name + ';)*'
    if @decorators.Quote == '"'
      @validators.AttValue = '(?:[^<&"]|' + @validators.Reference + ')*'
    else
      @validators.AttValue = "(?:[^<&']|" + @validators.Reference + ')*'     
    if @decorators.Quote == '"'
      @validators.SystemLiteral = '[^"]*'
    else
      @validators.SystemLiteral = "[^']*"
    if @decorators.Quote == '"'
      @validators.PubIDChar = "\u0020|\u000D|\u000A|[a-zA-Z0-9]|[-'()+,./:=?;!*#@$_%]"
    else
      @validators.PubIDChar = "\u0020|\u000D|\u000A|[a-zA-Z0-9]|[-()+,./:=?;!*#@$_%]"
    @validators.PubIDLiteral = '(?:' + @validators.PubIDChar + ')*'
    @validators.CommentChar = '(?!-)' + '(?:' + @validators.Char + ')'
    @validators.Comment = '<!--' + '(?:' + @validators.CommentChar + '|' + 
      '-' + @validators.CommentChar + ')*'  + '-->'


  # Starts the builder
  begin: (elements...) ->
    r = ''
    for element in elements
      r += element
    return r


  # Creates an XML prolog with one or both of the following options
  #
  # `xmldec.version` A version number string, e.g. 1.0
  # `xmldec.encoding` Encoding declaration, e.g. UTF-8
  # `xmldec.standalone` standalone document declaration: true or false
  #
  # `doctype.name` name of the root element
  # `doctype.ext` the external subset containing markup declarations
  # `doctype.int` the internal subset containing markup declarations
  prolog: (xmldec, doctype) ->
    # FIXME
    return '<?xml version="1.0"?>'


  # Creates a node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `elements` inner elements
  element: (name, attributes, elements...) ->

    if not elements?
      elements = []
    if typeof elements[0] == "object" #expand nested array
      elements = elements[0]
    if attributes? and typeof attributes == "string"
      elements.unshift attributes
      attributes = undefined
    elements = elements.filter (element) -> element?

    r = ''
    # open tag
    if not name?
      throw new Error "Missing element name"
    if @settings.ValidateNames and not name.match "^" + @validators.Name + "$"
      throw new Error "Invalid element name: " + name
    r += @decorators.OpenTag + name
  
    # attributes
    if attributes?
      for attName, attValue of attributes
        if @settings.ValidateNames and not attName.match "^" + @validators.Name + "$"
          throw new Error "Invalid attribute name: " + attName
        if @settings.ValidateValues and not attValue.match "^" + @validators.AttValue + "$"
          throw new Error "Invalid attribute value: " + attValue
        r += @decorators.Space + attName + @decorators.Equals + 
          @decorators.Quote + attValue + @decorators.Quote

    if elements.length == 0
      # empty element
      r += @decorators.EndTag + @decorators.CloseTag
    else
      r += @decorators.CloseTag
      # inner tags
      for element in elements
        r += element
      # close tag
      r += @decorators.OpenTag + @decorators.EndTag + name + @decorators.CloseTag

    return r


  # Creates a text node
  #
  # `value` element text
  text: (value) ->
    if not value?
      throw new Error "Missing element text"
    if @settings.ValidateValues and not value.match "^" + @validators.EntityValue + "$"
      throw new Error "Invalid element text: " + value
    return value


  # aliases
  pro: (xmldec, doctype) -> @prolog xmldec, doctype
  ele: (name, attributes, elements...) -> @element name, attributes, elements
  txt: (value) -> @text value

module.exports = XMLBuilder
