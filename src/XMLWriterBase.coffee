# Base class for XML writers
module.exports = class XMLWriterBase


  # Initializes a new instance of `XMLWriterBase`
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation string
  # `options.newline` newline sequence
  # `options.offset` a fixed number of indentations to add to every line
  # `options.allowEmpty` do not self close empty element tags
  # 'options.dontprettytextnodes' if any text is present in node, don't indent or LF
  # `options.spacebeforeslash` add a space before the closing slash of empty elements
  constructor: (options) ->
    options or= {}
    @pretty = options.pretty or false
    @allowEmpty = options.allowEmpty ? false
    if @pretty
      @indent = options.indent ? '  '
      @newline = options.newline ? '\n'
      @offset = options.offset ? 0
      @dontprettytextnodes = options.dontprettytextnodes ? 0
    else
      @indent = ''
      @newline = ''
      @offset = 0
      @dontprettytextnodes = 0

    @spacebeforeslash = options.spacebeforeslash ? ''
    if @spacebeforeslash is true then @spacebeforeslash = ' '

    # create local copies of these two for later
    @newlinedefault = @newline
    @prettydefault = @pretty

    # overwrite default properties
    for own key, value of options.writer or {}
      @[key] = value

  # Modifies writer options
  set: (options) ->
    options or= {}
    @pretty = options.pretty if "pretty" of options
    @allowEmpty = options.allowEmpty  if "allowEmpty" of options
    if @pretty
      @indent = if "indent" of options then options.indent else '  '
      @newline = if "newline" of options then options.newline else '\n'
      @offset = if "offset" of options then options.offset else 0
      @dontprettytextnodes =  if "dontprettytextnodes" of options then options.dontprettytextnodes else 0
    else
      @indent = ''
      @newline = ''
      @offset = 0
      @dontprettytextnodes = 0

    @spacebeforeslash = if "spacebeforeslash" of options then options.spacebeforeslash else ''
    if @spacebeforeslash is true then @spacebeforeslash = ' '

    # create local copies of these two for later
    @newlinedefault = @newline
    @prettydefault = @pretty

    # overwrite default properties
    for own key, value of options.writer or {}
      @[key] = value

    return @

  # returns the indentation string for the current level
  space: (level) ->
    if @pretty
      indent = (level or 0) + @offset + 1
      if indent > 0
        new Array(indent).join(@indent)
      else
        ''
    else
      ''
