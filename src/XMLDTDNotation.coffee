_ = require 'underscore'

# Represents a NOTATION entry in the DTD
module.exports = class XMLDTDNotation


  # Initializes a new instance of `XMLDTDNotation`
  #
  # `parent` the parent `XMLDocType` element
  # `name` the name of the notation
  # `value` an object with external entity details
  # `value.pubid` public identifier
  # `value.sysid` system identifier
  constructor: (parent, name, value) ->
    @stringify = parent.stringify

    if not name?
      throw new Error "Missing notation name"
    if not value.pubid and not value.sysid
      throw new Error "Public or system identifiers are required for an external entity"

    @name = @stringify.eleName name
    @pubid = @stringify.dtdPubID value.pubid if value.pubid?
    @sysid = @stringify.dtdSysID value.sysid if value.sysid?

  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options?.pretty or false
    indent = options?.indent or '  '
    newline = options?.newline or '\n'
    level or= 0

    space = new Array(level).join(indent)

    r = ''

    r += space if pretty

    r += '<!NOTATION ' + @name
    if @pubid and @sysid
      r += ' PUBLIC "' + @pubid + '" "' + @sysid + '"'
    else if @pubid
      r += ' PUBLIC "' + @pubid + '"'
    else if @sysid
      r += ' SYSTEM "' + @sysid + '"'
    r += '>'

    r += newline if pretty

    return r
