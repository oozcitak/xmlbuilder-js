# Converts values to strings
module.exports = class XMLStringifier


  # Initializes a new instance of `XMLStringifier`
  #
  # `options.noDoubleEncoding` whether existing html entities are encoded: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  constructor: (options) ->
    options or= {}
    @noDoubleEncoding = options.noDoubleEncoding
    for own key, value of options.stringify or {}
      @[key] = value

  # Defaults
  eleName: (val) ->
    val = '' + val or ''
    @assertLegalChar val
  eleText: (val) ->
    val = '' + val or ''
    @assertLegalChar @elEscape val
  cdata: (val) ->
    val = '' + val or ''
    val = val.replace(']]>', ']]]]><![CDATA[>')
    @assertLegalChar val
  comment: (val) ->
    val = '' + val or ''
    if val.match /--/
      throw new Error "Comment text cannot contain double-hypen: " + val
    @assertLegalChar val
  raw: (val) ->
    '' + val or ''
  attName: (val) ->
    val = '' + val or ''
  attValue: (val) ->
    val = '' + val or ''
    @attEscape val
  insTarget: (val) ->
    '' + val or ''
  insValue: (val) ->
    val = '' + val or ''
    if val.match /\?>/
      throw new Error "Invalid processing instruction value: " + val
    val
  xmlVersion: (val) ->
    val = '' + val or ''
    if not val.match /1\.[0-9]+/
      throw new Error "Invalid version number: " + val
    val
  xmlEncoding: (val) ->
    val = '' + val or ''
    if not val.match /^[A-Za-z](?:[A-Za-z0-9._-]|-)*$/
      throw new Error "Invalid encoding: " + val
    val
  xmlStandalone: (val) ->
    if val then "yes" else "no"
  dtdPubID: (val) ->
    '' + val or ''
  dtdSysID: (val) ->
    '' + val or ''
  dtdElementValue: (val) ->
    '' + val or ''
  dtdAttType: (val) ->
    '' + val or ''
  dtdAttDefault: (val) ->
    if val? then '' + val or '' else val
  dtdEntityValue: (val) ->
    '' + val or ''
  dtdNData: (val) ->
    '' + val or ''

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
    # Valid characters from https://www.w3.org/TR/xml11/#charsets
    # any Unicode character, excluding the surrogate blocks, FFFE, and FFFF.
    # [#x1-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
    # This complex ES5 compatible Regexp has been generated using the "regenerate" NPM module
    # `regenerate().add(0x0000).addRange(0xD800, 0xDFFF).addRange(0xFFFE, 0xFFFF).toString()`
    res = str.match /[\0\uFFFE\uFFFF]|[\uD800-\uDBFF](?![\uDC00-\uDFFF])|(?:[^\uD800-\uDBFF]|^)[\uDC00-\uDFFF]/
    if res
      throw new Error "Invalid character in string: #{str} at index #{res.index}"

    str


  # Escapes special characters in element values
  #
  # See http://www.w3.org/TR/2000/WD-xml-c14n-20000119.html#charescaping
  #
  # `str` the string to escape
  elEscape: (str) ->
    ampregex = if @noDoubleEncoding then /(?!&\S+;)&/g else /&/g
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
    ampregex = if @noDoubleEncoding then /(?!&\S+;)&/g else /&/g
    str.replace(ampregex, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/"/g, '&quot;')
       .replace(/\t/g, '&#x9;')
       .replace(/\n/g, '&#xA;')
       .replace(/\r/g, '&#xD;')

