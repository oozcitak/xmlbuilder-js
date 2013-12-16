_ = require 'underscore'

XMLNode = require './XMLNode'

# Represents doctype declaration
module.exports = class XMLDocType extends XMLNode


  # Initializes a new instance of `XMLDocType`
  #
  # `parent` the document object
  #
  # `pubId` the public identifier of the DTD
  # `sysId` the system identifier of the DTD
  #     if sysId is omitted, pubId will be used
  #     as sysId
  constructor: (parent, pubId, sysId) ->
    super parent

    if sysId
      @public = true
      @pubId = @stringify.xmlPubId pubId
      @sysId = @stringify.xmlSysId sysId
    else
      @public = false
      @sysId = @stringify.xmlSysId pubId
      @pubId = null


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
    if @pubId or @sysId
      if @public
        r += ' PUBLIC "' + @pubId + '" "' + @sysId + '"'
      else
        r += ' SYSTEM "' + @sysId + '"'

    # close tag
    r += '>'

    if pretty
      r += newline

    return r
