# Converts values to strings
module.exports = class XMLStringifier


  # Initializes a new instance of `XMLStringifier`
  #
  # `options.allowSurrogateChars` whether surrogates will be allowed: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  constructor: (options) ->
    @allowSurrogateChars = options?.allowSurrogateChars
    for own key, value of options?.stringify or {}
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
    if val.match /]]>/
      throw new Error "Invalid CDATA text: " + val
    @assertLegalChar val
  comment: (val) ->
    val = '' + val or ''
    if val.match /--/
      throw new Error "Comment text cannot contain double-hypen: " + val
    @assertLegalChar val
  raw: (val) ->
    '' + val or ''
  attName: (val) ->
    '' + val or ''
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
    if @allowSurrogateChars
      chars = /[\u0000-\u0008\u000B-\u000C\u000E-\u001F\uFFFE-\uFFFF]/
    else
      chars = /[\u0000-\u0008\u000B-\u000C\u000E-\u001F\uD800-\uDFFF\uFFFE-\uFFFF]/
    chr = str.match chars
    if chr
      throw new Error "Invalid character (#{chr}) in string: #{str} at index #{chr.index}"

    str


  # Escapes special characters in element values
  #
  # See http://www.w3.org/TR/2000/WD-xml-c14n-20000119.html#charescaping
  #
  # `str` the string to escape
  elEscape: (str) ->
    str.replace(/&/g, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/>/g, '&gt;')
       .replace(/\r/g, '&#xD;')

  # Escapes special characters in attribute values
  #
  # See http://www.w3.org/TR/2000/WD-xml-c14n-20000119.html#charescaping
  #
  # `str` the string to escape
  attEscape: (str) ->
    str.replace(/&/g, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/"/g, '&quot;')
