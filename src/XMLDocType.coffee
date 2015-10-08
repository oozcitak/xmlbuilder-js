create = require 'lodash/object/create'
isObject = require 'lodash/lang/isObject'

XMLCData = require './XMLCData'
XMLComment = require './XMLComment'
XMLDTDAttList = require './XMLDTDAttList'
XMLDTDEntity = require './XMLDTDEntity'
XMLDTDElement = require './XMLDTDElement'
XMLDTDNotation = require './XMLDTDNotation'
XMLProcessingInstruction = require './XMLProcessingInstruction'

# Represents doctype declaration
module.exports = class XMLDocType


  # Initializes a new instance of `XMLDocType`
  #
  # `parent` the document object
  #
  # `pubID` public identifier of the external subset
  # `sysID` system identifier of the external subset
  constructor: (parent, pubID, sysID) ->
    @documentObject = parent
    @stringify = @documentObject.stringify

    @children = []

    # arguments may also be passed as an object
    if isObject pubID
      { pubID, sysID } = pubID

    if not sysID?
      [sysID, pubID] = [pubID, sysID]

    @pubID = @stringify.dtdPubID pubID if pubID?
    @sysID = @stringify.dtdSysID sysID if sysID?


  # Creates an element type declaration
  #
  # `name` element name
  # `value` element content (defaults to #PCDATA)
  element: (name, value) ->
    child = new XMLDTDElement @, name, value
    @children.push child
    return @


  # Creates an attribute declaration
  #
  # `elementName` the name of the element containing this attribute
  # `attributeName` attribute name
  # `attributeType` type of the attribute (defaults to CDATA)
  # `defaultValueType` default value type (either #REQUIRED, #IMPLIED, #FIXED or
  #                    #DEFAULT) (defaults to #IMPLIED)
  # `defaultValue` default value of the attribute
  #                (only used for #FIXED or #DEFAULT)
  attList: (elementName, attributeName, attributeType, defaultValueType, defaultValue) ->
    child = new XMLDTDAttList @, elementName, attributeName, attributeType, defaultValueType, defaultValue
    @children.push child
    return @


  # Creates a general entity declaration
  #
  # `name` the name of the entity
  # `value` internal entity value or an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  # `value.nData` notation declaration
  entity: (name, value) ->
    child = new XMLDTDEntity @, false, name, value
    @children.push child
    return @


  # Creates a parameter entity declaration
  #
  # `name` the name of the entity
  # `value` internal entity value or an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  pEntity: (name, value) ->
    child = new XMLDTDEntity @, true, name, value
    @children.push child
    return @


  # Creates a NOTATION declaration
  #
  # `name` the name of the notation
  # `value` an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  notation: (name, value) ->
    child = new XMLDTDNotation @, name, value
    @children.push child
    return @


  # Creates a CDATA node
  #
  # `value` element text without CDATA delimiters
  cdata: (value) ->
    child = new XMLCData @, value
    @children.push child
    return @


  # Creates a comment node
  #
  # `value` comment text
  comment: (value) ->
    child = new XMLComment @, value
    @children.push child
    return @


  # Adds a processing instruction
  #
  # `target` instruction target
  # `value` instruction value
  instruction: (target, value) ->
    child = new XMLProcessingInstruction @, target, value
    @children.push child
    return @


  # Gets the root node
  root: () ->
    @documentObject.root()


  # Gets the node representing the XML document
  document: () ->
    return @documentObject


  # Converts to string
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

    # open tag
    r += '<!DOCTYPE ' + @root().name

    # external identifier
    if @pubID and @sysID
      r += ' PUBLIC "' + @pubID + '" "' + @sysID + '"'
    else if @sysID
      r += ' SYSTEM "' + @sysID + '"'

    # internal subset
    if @children.length > 0
      r += ' ['
      r += newline if pretty
      for child in @children
        r += child.toString options, level + 1
      r += ']'

    # close tag
    r += '>'

    r += newline if pretty

    return r


  # Aliases
  ele: (name, value) -> @element name, value
  att: (elementName, attributeName, attributeType, defaultValueType, defaultValue) ->
    @attList elementName, attributeName, attributeType, defaultValueType, defaultValue
  ent: (name, value) -> @entity name, value
  pent: (name, value) -> @pEntity name, value
  not: (name, value) -> @notation name, value
  dat: (value) -> @cdata value
  com: (value) -> @comment value
  ins: (target, value) -> @instruction target, value
  up: () -> @root()
  doc: () -> @document()
