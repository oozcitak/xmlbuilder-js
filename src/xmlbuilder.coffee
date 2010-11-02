# xmlbuilder
# ==========
# An XML builder for node.js
# Copyright Ozgur Ozcitak 2010
# Licensed under the MIT license

class XMLBuilder

  decorators:
    OpenTag: '<'
    CloseTag: '>'
    CloseSOTag: '/>'
    AttDelim: '='
    AttSep: ' '
    Quote: '"'
    Space: ' '
    Indent: '  '

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

  constructor: (options) ->
    @reset ()
 
    options or= { indent: false, validate: true };
    @settings = {}
    @settings.indent = options.indent or false
    @settings.validate = options.validate or true

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

  reset: () =>
    @elements = []
    @level = 0

  prolog: () =>
    # FIXME
    @elements.push '<?xml version="1.0"?>'

  element: (name, attributes, callback) =>
    value = undefined
    if typeof callback is "string"
      value = callback
      callback = undefined

    # open tag
    if not name?
      throw new Error "Missing element name"
    if @settings.validate and not name.match "^" + @validators.Name + "$"
      throw new Error "Invalid element name: " + name
    @elements.push @decorators.OpenTag + name
  
    # attributes
    if attributes?
      for attName, attValue of attributes
        if @settings.validate and not attName.match "^" + @validators.Name + "$"
          throw new Error "Invalid attribute name: " + attName
        if @settings.validate and not attValue.match "^" + @validators.AttValue + "$"
          throw new Error "Invalid attribute value: " + attValue
        @elements.push @decorators.Space + attName + @decorators.Equals + 
          @decorators.Quote + attValue + @decorators.Quote

    # value or inner tags
    if value?
      if @settings.validate and not value.match "^" + @validators.EntityValue + "$"
        throw new Error "Invalid element value: " + value
      @elements.push value
    else if callback?
      callback

    # close tag
    if value? or callback?
      @elements.push @decorators.CloseTag
    else
      @elements.push @decorators.CloseSOTag

  text: (value) =>
    if not value?
      throw new Error "Missing text value"
    if @settings.validate and not value.match "^" + @validators.EntityValue + "$"
      throw new Error "Invalid text value: " + value
    @elements.push value

  toString: ->
    r = ""
    for e in @elements
      r += e
    return r

  # aliases
  pro: () => @prolog
  ele: (name, attributes, callback) => @element name, attributes, callback
  txt: (value) => @text value

module.exports = XMLBuilder
