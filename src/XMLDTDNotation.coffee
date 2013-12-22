_ = require 'underscore'

# Represents a NOTATION entry in the DTD
module.exports = class XMLDTDNotation


  # Initializes a new instance of `XMLDTDNotation`
  #
  # `parent` the parent `XMLDocType` element
  # `name` the name of the notation
  # `identifierType` type of the identifier (either PUBLIC or SYSTEM)
  #                  (defaults to SYSTEM)
  # `pubID` public identifier
  # `sysID` system identifier
  constructor: (parent, name, identifierType, pubID, sysID) ->
    @stringify = parent.stringify

    if not name?
      throw new Error "Missing notation name"
    if not identifierType?
      throw new Error "Missing identifier"
    if not pubID? and not sysID?
      pubID = identifierType
      identifierType = 'SYSTEM'
    if not identifierType.match /^(PUBLIC|SYSTEM)$/
      throw new Error "Invalid identifier type; expected: PUBLIC or SYSTEM"
    if identifierType.indexOf('SYSTEM') == 0
      sysID = pubID if not sysID
      pubID = undefined
    if not pubID and not sysID
      throw new Error "Missing identifier"

    @name = @stringify.eleName name
    @type = identifierType
    @pubID = @stringify.dtdPubID pubID if pubID?
    @sysID = @stringify.dtdSysID sysID if sysID?

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

    r += '<!NOTATION ' + @name + ' ' + @type
    r += ' "' + @pubID + '"' if @pubID
    r += ' "' + @sysID + '"' if @sysID
    r += '>'

    r += newline if pretty

    return r
