XMLNode = require './XMLNode'

# Represents a NOTATION entry in the DTD
module.exports = class XMLDTDNotation extends XMLNode


  # Initializes a new instance of `XMLDTDNotation`
  #
  # `parent` the parent `XMLDocType` element
  # `name` the name of the notation
  # `value` an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  constructor: (parent, name, value) ->
    super parent

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
  toString: (options) ->
    @options.writer.set(options).dtdNotation @
