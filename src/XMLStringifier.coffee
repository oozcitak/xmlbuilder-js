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
    @assertLegalChar @escape val
  cdata: (val) ->
    val = '' + val or ''
    if val.match /]]>/
      throw new Error "Invalid CDATA text: " + val
    @assertLegalChar val
  comment: (val) ->
    val = '' + val or ''
    if val.match /--/
      throw new Error "Comment text cannot contain double-hypen: " + val
    @assertLegalChar @escape val
  raw: (val) ->
    '' + val or ''
  attName: (val) ->
    '' + val or ''
  attValue: (val) ->
    val = '' + val or ''
    @escape val
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
    if not val.match /[A-Za-z](?:[A-Za-z0-9._-]|-)*/
      throw new Error "Invalid encoding: " + options.val
    val
  xmlStandalone: (val) ->
    if val then "yes" else "no"
  xmlExternalSubset: (val) ->
    '' + val or ''

  # strings to match while converting from JS objects
  convertAttChar: '@'
  convertTextKey: '#text'
  convertCDataKey: '#cdata'
  convertCommentKey: '#comment'


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


  # Escapes special characters <, >, ', ", &
  #
  # `str` the string to escape
  escape: (str) ->
    str.replace(/&/g, '&amp;')
       .replace(/</g,'&lt;').replace(/>/g,'&gt;')
       .replace(/'/g, '&apos;').replace(/"/g, '&quot;')
