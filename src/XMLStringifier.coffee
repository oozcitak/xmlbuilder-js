# Converts values to strings
module.exports = class XMLStringifier


  # Initializes a new instance of `XMLStringifier`
  #
  # `options.version` The version number string of the XML spec to validate against, e.g. 1.0
  # `options.noDoubleEncoding` whether existing html entities are encoded: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  # `options.noValidation` whether values will be validated and escaped or returned as is
  # `options.invalidCharReplacement` a character to replace invalid characters and disable character validation
  constructor: (options) ->
    options or= {}
    @options = options
    @options.version = '1.0' if not @options.version

    for own key, value of options.stringify or {}
      @[key] = value


  # Defaults
  name: (val) ->
    if @options.noValidation then return val
    @assertLegalName '' + val or ''
  text: (val) ->
    if @options.noValidation then return val
    @assertLegalChar @textEscape('' + val or '')
  cdata: (val) ->
    if @options.noValidation then return val
    val = '' + val or ''
    val = val.replace(']]>', ']]]]><![CDATA[>')
    @assertLegalChar val
  comment: (val) ->
    if @options.noValidation then return val
    val = '' + val or ''
    if val.match /--/
      throw new Error "Comment text cannot contain double-hypen: " + val
    @assertLegalChar val
  raw: (val) ->
    if @options.noValidation then return val
    '' + val or ''
  attValue: (val) ->
    if @options.noValidation then return val
    @assertLegalChar @attEscape(val = '' + val or '')
  insTarget: (val) ->
    if @options.noValidation then return val
    @assertLegalChar '' + val or ''
  insValue: (val) ->
    if @options.noValidation then return val
    val = '' + val or ''
    if val.match /\?>/
      throw new Error "Invalid processing instruction value: " + val
    @assertLegalChar val
  xmlVersion: (val) ->
    if @options.noValidation then return val
    val = '' + val or ''
    if not val.match /1\.[0-9]+/
      throw new Error "Invalid version number: " + val
    val
  xmlEncoding: (val) ->
    if @options.noValidation then return val
    val = '' + val or ''
    if not val.match /^[A-Za-z](?:[A-Za-z0-9._-])*$/
      throw new Error "Invalid encoding: " + val
    @assertLegalChar val
  xmlStandalone: (val) ->
    if @options.noValidation then return val
    if val then "yes" else "no"
  dtdPubID: (val) ->
    if @options.noValidation then return val
    @assertLegalChar '' + val or ''
  dtdSysID: (val) ->
    if @options.noValidation then return val
    @assertLegalChar '' + val or ''
  dtdElementValue: (val) ->
    if @options.noValidation then return val
    @assertLegalChar '' + val or ''
  dtdAttType: (val) ->
    if @options.noValidation then return val
    @assertLegalChar '' + val or ''
  dtdAttDefault: (val) ->
    if @options.noValidation then return val
    @assertLegalChar '' + val or ''
  dtdEntityValue: (val) ->
    if @options.noValidation then return val
    @assertLegalChar '' + val or ''
  dtdNData: (val) ->
    if @options.noValidation then return val
    @assertLegalChar '' + val or ''


  # strings to match while converting from JS objects
  convertAttKey: '@'
  convertPIKey: '?'
  convertTextKey: '#text'
  convertCDataKey: '#cdata'
  convertCommentKey: '#comment'
  convertRawKey: '#raw'


  # Checks whether the given string contains legal characters
  # Fails with an exception on error
  #
  # `str` the string to check
  assertLegalChar: (str) =>
    if @options.noValidation then return str

    if @options.version is '1.0'
      # Valid characters from https://www.w3.org/TR/xml/#charsets
      # any Unicode character, excluding the surrogate blocks, FFFE, and FFFF.
      # #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
      # This ES5 compatible Regexp has been generated using the "regenerate" NPM module:
      #   let xml_10_InvalidChars = regenerate()
      #     .addRange(0x0000, 0x0008)
      #     .add(0x000B, 0x000C)
      #     .addRange(0x000E, 0x001F)
      #     .addRange(0xD800, 0xDFFF)
      #     .addRange(0xFFFE, 0xFFFF)
      regex = /[\0-\x08\x0B\f\x0E-\x1F\uFFFE\uFFFF]|[\uD800-\uDBFF](?![\uDC00-\uDFFF])|(?:[^\uD800-\uDBFF]|^)[\uDC00-\uDFFF]/g
      if @options.invalidCharReplacement isnt undefined
        str = str.replace regex, @options.invalidCharReplacement
      else if res = str.match(regex)
        throw new Error "Invalid character in string: #{str} at index #{res.index}"
    else if @options.version is '1.1'
      # Valid characters from https://www.w3.org/TR/xml11/#charsets
      # any Unicode character, excluding the surrogate blocks, FFFE, and FFFF.
      # [#x1-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
      # This ES5 compatible Regexp has been generated using the "regenerate" NPM module:
      #   let xml_11_InvalidChars = regenerate()
      #     .add(0x0000)
      #     .addRange(0xD800, 0xDFFF)
      #     .addRange(0xFFFE, 0xFFFF)
      regex = /[\0\uFFFE\uFFFF]|[\uD800-\uDBFF](?![\uDC00-\uDFFF])|(?:[^\uD800-\uDBFF]|^)[\uDC00-\uDFFF]/g
      if @options.invalidCharReplacement isnt undefined
        str = str.replace regex, @options.invalidCharReplacement
      else if res = str.match(regex)
        throw new Error "Invalid character in string: #{str} at index #{res.index}"

    return str


  # Checks whether the given string contains legal characters for a name
  # Fails with an exception on error
  #
  # `str` the string to check
  assertLegalName: (str) =>
    if @options.noValidation then return str

    str = @assertLegalChar str

    regex = /^([:A-Z_a-z\xC0-\xD6\xD8-\xF6\xF8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD]|[\uD800-\uDB7F][\uDC00-\uDFFF])([\x2D\.0-:A-Z_a-z\xB7\xC0-\xD6\xD8-\xF6\xF8-\u037D\u037F-\u1FFF\u200C\u200D\u203F\u2040\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD]|[\uD800-\uDB7F][\uDC00-\uDFFF])*$/
    if not str.match(regex)
      throw new Error "Invalid character in name: #{str}"

    return str


  # Escapes special characters in text
  #
  # See http://www.w3.org/TR/2000/WD-xml-c14n-20000119.html#charescaping
  #
  # `str` the string to escape
  textEscape: (str) ->
    if @options.noValidation then return str
    ampregex = if @options.noDoubleEncoding then /(?!&(lt|gt|amp|apos|quot);)&/g else /&/g
    str.replace(ampregex, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/>/g, '&gt;')
       .replace(/\r/g, '&#xD;')

  # Escapes special characters in attribute values
  #
  # See http://www.w3.org/TR/2000/WD-xml-c14n-20000119.html#charescaping
  #
  # `str` the string to escape
  attEscape: (str) ->
    if @options.noValidation then return str
    ampregex = if @options.noDoubleEncoding then /(?!&(lt|gt|amp|apos|quot);)&/g else /&/g
    str.replace(ampregex, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/"/g, '&quot;')
       .replace(/\t/g, '&#x9;')
       .replace(/\n/g, '&#xA;')
       .replace(/\r/g, '&#xD;')
