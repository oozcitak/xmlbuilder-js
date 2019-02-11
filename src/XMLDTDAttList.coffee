XMLNode = require './XMLNode'
NodeType = require './NodeType'

# Represents an attribute list
module.exports = class XMLDTDAttList extends XMLNode


  # Initializes a new instance of `XMLDTDAttList`
  #
  # `parent` the parent `XMLDocType` element
  # `elementName` the name of the element containing this attribute
  # `attributeName` attribute name
  # `attributeType` type of the attribute
  # `defaultValueType` default value type (either #REQUIRED, #IMPLIED,
  #                    #FIXED or #DEFAULT)
  # `defaultValue` default value of the attribute
  #                (only used for #FIXED or #DEFAULT)
  constructor: (parent, elementName, attributeName, attributeType, defaultValueType, defaultValue) ->
    super parent

    if not elementName?
      throw new Error "Missing DTD element name. " + @debugInfo()
    if not attributeName?
      throw new Error "Missing DTD attribute name. " + @debugInfo(elementName)
    if not attributeType
      throw new Error "Missing DTD attribute type. " + @debugInfo(elementName)
    if not defaultValueType
      throw new Error "Missing DTD attribute default. " + @debugInfo(elementName)
    if defaultValueType.indexOf('#') != 0
      defaultValueType = '#' + defaultValueType
    if not defaultValueType.match /^(#REQUIRED|#IMPLIED|#FIXED|#DEFAULT)$/
      throw new Error "Invalid default value type; expected: #REQUIRED, #IMPLIED, #FIXED or #DEFAULT. " + @debugInfo(elementName)
    if defaultValue and not defaultValueType.match /^(#FIXED|#DEFAULT)$/
      throw new Error "Default value only applies to #FIXED or #DEFAULT. " + @debugInfo(elementName)

    @elementName = @stringify.name elementName
    @type = NodeType.AttributeDeclaration
    @attributeName = @stringify.name attributeName
    @attributeType = @stringify.dtdAttType attributeType
    @defaultValue = @stringify.dtdAttDefault defaultValue if defaultValue
    @defaultValueType = defaultValueType


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    @options.writer.dtdAttList @, @options.writer.filterOptions(options)
