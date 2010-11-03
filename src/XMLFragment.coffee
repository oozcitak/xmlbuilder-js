# Represents a fragment of an XMl document
class XMLFragment


  # Regular expressions to validate tokens
  # See: http://www.w3.org/TR/xml/ 
  # Supplementary Unicode code points not supported
  val: {}
    

  # Initializes a new instance of `XMLFragment`
  # `name` element name
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  constructor: (name, attributes, text) ->
    @name = name or ''
    @attributes = attributes or {}
    @text = text or ''
    @children = []


  # Creates an XML prolog with one or both of the following options
  #
  # `xmldec.version` A version number string, e.g. 1.0
  # `xmldec.encoding` Encoding declaration, e.g. UTF-8
  # `xmldec.standalone` standalone document declaration: true or false
  #
  # `doctype.name` name of the root element
  # `doctype.ext` the external subset containing markup declarations
  # `doctype.int` the internal subset containing markup declarations
  prolog: (xmldec, doctype) =>
    # FIXME
    return '<?xml version="1.0"?>'


  # Creates a child element node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  element: (name, attributes) =>
    if not name?
      throw new Error "Missing element name"
    if not name.match "^" + @val.Name + "$"
      throw new Error "Invalid element name: " + name

    @children.push new XMLFragment name, attributes


  # Creates a text node
  #
  # `value` element text
  text: (value) =>
    if not value?
      throw new Error "Missing element text"
    if not value.match "^" + @val.EntityValue + "$"
      throw new Error "Invalid element text: " + value

    @children.push new XMLFragment '', {}, value


  # Adds or modifies an attribute
  #
  # `name` attribute name
  # `value` attribute value
  attribute: (name, value) =>
    if not name?
      throw new Error "Missing attribute name"
    if not name.match "^" + @val.Name + "$"
      throw new Error "Invalid attribute name: " + name
    if not value?
      throw new Error "Missing attribute value"
    if not value.match "^" + @val.AttValue + "$"
      throw new Error "Invalid attribute value: " + value

    @attributes[name] = value


  # Converts the XML fragment to string
  #
  #
  # `options.Pretty` pretty prints the result
  # `options.Indent` indentation for pretty print
  # `options.NewLine` newline sequence for pretty print
  toString: (options) ->
    pretty = options? and options.Pretty or false
    indent = options? and options.Indent or '  '
    newline = options? and options.NewLine or '\n'

    r = ''
    # open tag
    r += '<' + @name

    # attributes
    for attName, attValue of @attributes
      r += ' ' + attName + '="' + attValue + '"'

    if @children.length == 0
      # empty element
      r += '/>'
    else
      r += '>' 
      # inner tags
      for child in @children
        r += child.toString options
      # close tag
      r += '</' + @name + '>'

    return r


  # aliases
  pro: (xmldec, doctype) => @prolog xmldec, doctype
  ele: (name, attributes) => @element name, attributes
  txt: (value) => @text value
  att: (name, value) => @attribute name, value
  p: (xmldec, doctype) => @prolog xmldec, doctype
  e: (name, attributes) => @element name, attributes
  t: (value) => @text value
  a: (name, value) => @attribute name, value
 

# assign validation strings to the prototype
XMLFragment::val.Space = "(?:\u0020|\u0009|\u000D|\u000A)+"
XMLFragment::val.Char = "\u0009|\u000A|\u000D|[\u0020-\uD7FF]|[\uE000-\uFFFD]"
XMLFragment::val.NameStartChar =
  ":|[A-Z]|_|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|" + 
  "[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|" +
  "[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]"
XMLFragment::val.NameChar =
  ":|[A-Z]|_|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|" +
  "[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|" + 
  "[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]" +
  "-|\.|[0-9]|\u00B7|[\u0300-\u036F]|[\u203F-\u2040]"
XMLFragment::val.CharRef = "&#[0-9]+;|&#x[0-9a-fA-F]+;"
XMLFragment::val.CharData = "(?![^<&]*]]>[^<&]*)[^<&]*"
XMLFragment::val.Name = XMLFragment::val.NameStartChar + '(?:' + XMLFragment::val.NameChar + ')*'
XMLFragment::val.NMToken = '(?:' + XMLFragment::val.NameChar + ')+'
XMLFragment::val.EntityRef = '&' + XMLFragment::val.Name + ';'
XMLFragment::val.Reference = '&' + XMLFragment::val.Name + ';' + '|' + XMLFragment::val.CharRef
XMLFragment::val.PEReference = '%' + XMLFragment::val.Name + ';'
XMLFragment::val.EntityValue =
    '(?:[^%&"]|%' + XMLFragment::val.Name + ';|&' + XMLFragment::val.Name + ';)*'
XMLFragment::val.AttValue =
    '(?:[^<&"]|' + XMLFragment::val.Reference + ')*'
XMLFragment::val.SystemLiteral = '[^"]*'
XMLFragment::val.PubIDChar = "\u0020|\u000D|\u000A|[a-zA-Z0-9]|[-'()+,./:=?;!*#@$_%]"
XMLFragment::val.PubIDLiteral = '(?:' + XMLFragment::val.PubIDChar + ')*'
XMLFragment::val.CommentChar = '(?!-)' + '(?:' + XMLFragment::val.Char + ')'
XMLFragment::val.Comment =
  '<!--' + '(?:' + XMLFragment::val.CommentChar + '|' + 
  '-' + XMLFragment::val.CommentChar + ')*'  + '-->'


module.exports = XMLFragment
