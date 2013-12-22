_ = require 'underscore'

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

    if not sysID?
      [sysID, pubID] = [pubID, sysID]

    @pubID = @stringify.dtdPubID pubID if pubID?
    @sysID = @stringify.dtdSysID sysID if sysID?


  # Creates an element type declaration
  #
  # `name` element name
  # `value` element content (defaults to #PCDATA)
  element: (name, value) ->
    XMLDTDElement = require './XMLDTDElement'
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
    XMLDTDAttList = require './XMLDTDAttList'
    child = new XMLDTDAttList @, elementName, attributeName, attributeType, defaultValueType, defaultValue
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
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options?.pretty or false
    indent = options?.indent or '  '
    newline = options?.newline or '\n'
    level or= 0

    space = new Array(level + 1).join(indent)

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
      for child in @children
        r += child.toString options, level + 1
      r += newline if pretty
      r += ']'

    # close tag
    r += '>'

    r += newline if pretty

    return r


  # Aliases
  ele: (name, value) -> @element name, value
  att: (elementName, attributeName, attributeType, defaultValueType, defaultValue) ->
    @attList elementName, attributeName, attributeType, defaultValueType, defaultValue
  up: () -> @root()
  doc: () -> @document()