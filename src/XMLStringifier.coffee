# Converts values to strings
class XMLStringifier


  # Initializes a new instance of `XMLStringifier`
  #
  # `options.allowSurrogateChars` whether surrogates will be allowed: true or false
  # `options.stringify` a set of functions to use for converting values to strings
  constructor: (options) ->
    @allowSurrogateChars = options?.allowSurrogateChars
    for own key, value of options?.stringify or {}
      XMLStringifier::[key] = value

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
    val = @assertLegalChar val
    '<![CDATA[' + val + ']]>'
  comment: (val) ->
    val = '' + val or ''
    if val.match /--/
      throw new Error "Comment text cannot contain double-hypen: " + val
    val = @assertLegalChar @escape val
    '<!-- ' + val + ' -->'
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


module.exports = XMLStringifier

