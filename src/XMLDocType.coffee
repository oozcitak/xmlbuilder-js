_ = require 'underscore'

XMLNode = require './XMLNode'

# Represents doctype declaration
module.exports = class XMLDocType extends XMLNode


  # Initializes a new instance of `XMLDocType`
  #
  # `parent` the document object
  #
  # `options.dtd` document type declaration with optional external subset
  # `options.dtd.pubID` the public identifier of the external subset
  # `options.dtd.sysID` the system identifier of the external subset
  constructor: (parent, options) ->
    super parent

    if not _.isObject options.dtd
      sysID = options.dtd
      options.dtd = {}
      options.dtd.sysID = sysID if sysID
    
    @pubID = @stringify.xmlPubID options.dtd.pubID if options.dtd.pubID?
    @sysID = @stringify.xmlSysID options.dtd.sysID if options.dtd.sysID?


  # Converts to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options?.pretty or false
    indent = options?.indent or '  '
    newline = options?.newline or '\n'
    level or= 0

    space = new Array(level + 1).join(indent)

    r = ''

    # open tag
    if pretty
      r += space
    r += '<!DOCTYPE ' + @parent.root().name

    # external identifier
    if @pubID and @sysID
      r += ' PUBLIC "' + @pubID + '" "' + @sysID + '"'
    else if @sysID
      r += ' SYSTEM "' + @sysID + '"'

    # close tag
    r += '>'

    if pretty
      r += newline

    return r
