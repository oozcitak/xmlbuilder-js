create = require 'lodash/object/create'
isObject = require 'lodash/lang/isObject'

# Represents an entity declaration in the DTD
module.exports = class XMLDTDEntity


  # Initializes a new instance of `XMLDTDEntity`
  #
  # `parent` the parent `XMLDocType` element
  # `pe` whether this is a parameter entity or a general entity
  #      defaults to `false` (general entity)
  # `name` the name of the entity
  # `value` internal entity value or an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  # `value.nData` notation declaration
  constructor: (parent, pe, name, value) ->
    @stringify = parent.stringify

    if not name?
      throw new Error "Missing entity name"
    if not value?
      throw new Error "Missing entity value"

    @pe = !!pe
    @name = @stringify.eleName name

    if not isObject value
      @value =  @stringify.dtdEntityValue value
    else
      if not value.pubID and not value.sysID
        throw new Error "Public and/or system identifiers are required for an external entity"
      if value.pubID and not value.sysID
        throw new Error "System identifier is required for a public external entity"

      @pubID = @stringify.dtdPubID value.pubID if value.pubID?
      @sysID = @stringify.dtdSysID value.sysID if value.sysID?

      @nData = @stringify.dtdNData value.nData if value.nData?
      if @pe and @nData
        throw new Error "Notation declaration is not allowed in a parameter entity"


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

    r += '<!ENTITY'
    r += ' %' if @pe
    r += ' ' + @name
    if @value
      r += ' "' + @value + '"'
    else
      if @pubID and @sysID
        r += ' PUBLIC "' + @pubID + '" "' + @sysID + '"'
      else if @sysID
        r += ' SYSTEM "' + @sysID + '"'
      r += ' NDATA ' + @nData if @nData
    r += '>'

    r += newline if pretty

    return r
