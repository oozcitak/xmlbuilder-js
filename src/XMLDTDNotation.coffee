create = require 'lodash/object/create'

# Represents a NOTATION entry in the DTD
module.exports = class XMLDTDNotation


  # Initializes a new instance of `XMLDTDNotation`
  #
  # `parent` the parent `XMLDocType` element
  # `name` the name of the notation
  # `value` an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  constructor: (parent, name, value) ->
    @stringify = parent.stringify

    if not name?
      throw new Error "Missing notation name"
    if not value.pubID and not value.sysID
      throw new Error "Public or system identifiers are required for an external entity"

    @name = @stringify.eleName name
    @pubID = @stringify.dtdPubID value.pubID if value.pubID?
    @sysID = @stringify.dtdSysID value.sysID if value.sysID?


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options?.pretty or false
    indent = options?.indent ? '  '
    offset = options?.offset ? 0
    newline = options?.newline ? '\n'
    level or= 0

    space = new Array(level + offset + 1).join(indent)

    r = ''

    r += space if pretty

    r += '<!NOTATION ' + @name
    if @pubID and @sysID
      r += ' PUBLIC "' + @pubID + '" "' + @sysID + '"'
    else if @pubID
      r += ' PUBLIC "' + @pubID + '"'
    else if @sysID
      r += ' SYSTEM "' + @sysID + '"'
    r += '>'

    r += newline if pretty

    return r
