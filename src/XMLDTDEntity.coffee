_ = require 'underscore'

# Represents an entity declaration in the DTD
module.exports = class XMLDTDEntity


  # Initializes a new instance of `XMLDTDEntity`
  #
  # `parent` the parent `XMLDocType` element
  # `pe` whether this is a parameter entity or a general entity
  #      defaults to `false` (general entity)
  # `name` the name of the entity
  # `value` internal entity value or an object with external entity details
  # `value.pubid` public identifier
  # `value.sysid` system identifier
  # `value.ndata` notation declaration
  constructor: (parent, pe, name, value) ->
    @stringify = parent.stringify

    if not name?
      throw new Error "Missing entity name"
    if not value?
      throw new Error "Missing entity value"

    @pe = !!pe
    @name = @stringify.eleName name

    if not _.isObject value
      @value =  @stringify.dtdEntityValue value
    else
      if not value.pubid and not value.sysid
        throw new Error "Public and/or system identifiers are required for an external entity"
      if value.pubid and not value.sysid
        throw new Error "System identifier is required for a public external entity"

      @pubid = @stringify.dtdPubID value.pubid if value.pubid?
      @sysid = @stringify.dtdSysID value.sysid if value.sysid?

      @ndata = @stringify.dtdNData value.ndata if value.ndata?
      if @pe and @ndata
        throw new Error "Notation declaration is not allowed in a parameter entity"

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

    r += '<!ENTITY'
    r += ' %' if @pe
    r += ' ' + @name
    if @value
      r += ' "' + @value + '"'
    else
      if @pubid and @sysid
        r += ' PUBLIC "' + @pubid + '" "' + @sysid + '"'
      else if @sysid
        r += ' SYSTEM "' + @sysid + '"'
      r += ' NDATA ' + @ndata if @ndata
    r += '>'

    r += newline if pretty

    return r
