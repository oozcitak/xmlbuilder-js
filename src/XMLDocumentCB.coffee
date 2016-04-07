{ isObject, isFunction, isPlainObject } = require './Utility'

XMLElement = require './XMLElement'
XMLCData = require './XMLCData'
XMLComment = require './XMLComment'
XMLRaw = require './XMLRaw'
XMLText = require './XMLText'
XMLProcessingInstruction = require './XMLProcessingInstruction'

XMLDeclaration = require './XMLDeclaration'
XMLDocType = require './XMLDocType'

XMLDTDAttList = require './XMLDTDAttList'
XMLDTDEntity = require './XMLDTDEntity'
XMLDTDElement = require './XMLDTDElement'
XMLDTDNotation = require './XMLDTDNotation'

XMLAttribute = require './XMLAttribute'

XMLStringifier = require './XMLStringifier'
XMLStringWriter = require './XMLStringWriter'

# Represents an XML builder
module.exports = class XMLDocumentCB


  # Initializes a new instance of `XMLDocumentCB`
  #
  # `options.allowSurrogateChars` whether surrogates will be allowed: true or
  #     false
  # `options.skipNullAttributes` whether attributes with null values will be
  #     ignored: true or false
  # `options.ignoreDecorators` whether decorator strings will be ignored when
  #     converting JS objects: true or false
  # `options.separateArrayItems` whether array items are created as separate
  #     nodes when passed as an object value: true or false
  # `options.noDoubleEncoding` whether existing html entities are encoded:
  #     true or false
  # `options.stringify` a set of functions to use for converting values to
  #     strings
  # `options.writer` the default XML writer to use for converting nodes to
  #     string. If the default writer is not set, the built-in XMLStringWriter
  #     will be used instead.
  #
  # `onData` the function to be called when a new chunk of XML is output. The
  #          string containing the XML chunk is passed to `onData` as its single
  #          argument.
  # `onEnd`  the function to be called when the XML document is completed with
  #          `end`. `onEnd` does not receive any arguments.
  constructor: (options, onData, onEnd) ->
    options or= {}

    if not options.writer
      options.writer = new XMLStringWriter(options)
    else if isPlainObject(options.writer)
      writerOptions = options.writer
      options.writer = new XMLStringWriter(writerOptions)

    @options = options
    @writer = options.writer
    @stringify = new XMLStringifier options
    @onDataCallback = onData or () ->
    @onEndCallback = onEnd or () ->

    @currentNode = null
    @currentLevel = -1
    @openTags = {}
    @documentStarted = false
    @documentCompleted = false
    @root = null


  # Creates a node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  node: (name, attributes, text) ->
    if not name?
      throw new Error "Missing node name"

    if @root and @currentLevel is -1
      throw new Error "Document can only have one root node"

    @openCurrent()

    name = name.valueOf()

    attributes ?= {}
    attributes = attributes.valueOf()
    # swap argument order: text <-> attributes
    if not isObject attributes
      [text, attributes] = [attributes, text]

    @currentNode = new XMLElement @, name, attributes
    @currentNode.children = false
    @currentLevel++
    @openTags[@currentLevel] = @currentNode

    @text(text) if text?

    return @


  # Creates a child element node or an element type declaration when called
  # inside the DTD
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  element: (name, attributes, text) ->
    if @currentNode and @currentNode instanceof XMLDocType
      @dtdElement arguments...
    else
      @node name, attributes, text


  # Adds or modifies an attribute
  #
  # `name` attribute name
  # `value` attribute value
  attribute: (name, value) ->
    if not @currentNode or @currentNode.children
      throw new Error "att() can only be used immediately after an ele() call in callback mode"

    name = name.valueOf() if name?

    if isObject name # expand if object
      for own attName, attValue of name
        @attribute attName, attValue
    else
      value = value.apply() if isFunction value
      if not @options.skipNullAttributes or value?
        @currentNode.attributes[name] = new XMLAttribute @, name, value

    return @




  # Creates a text node
  #
  # `value` element text
  text: (value) ->
    @openCurrent()

    node = new XMLText @, value
    @onData(@writer.text(node, @currentLevel + 1))

    return @


  # Creates a CDATA node
  #
  # `value` element text without CDATA delimiters
  cdata: (value) ->
    @openCurrent()

    node = new XMLCData @, value
    @onData(@writer.cdata(node, @currentLevel + 1))

    return @


  # Creates a comment node
  #
  # `value` comment text
  comment: (value) ->
    @openCurrent()

    node = new XMLComment @, value
    @onData(@writer.comment(node, @currentLevel + 1))

    return @


  # Adds unescaped raw text
  #
  # `value` text
  raw: (value) ->
    @openCurrent()

    node = new XMLRaw @, value
    @onData(@writer.raw(node, @currentLevel + 1))

    return @


  # Adds a processing instruction
  #
  # `target` instruction target
  # `value` instruction value
  instruction: (target, value) ->
    @openCurrent()

    target = target.valueOf() if target?
    value = value.valueOf() if value?

    if Array.isArray target # expand if array
      for insTarget in target
        @instruction insTarget
    else if isObject target # expand if object
      for own insTarget, insValue of target
        @instruction insTarget, insValue
    else
      value = value.apply() if isFunction value
      node = new XMLProcessingInstruction @, target, value
      @onData(@writer.processingInstruction(node, @currentLevel + 1))

    return @


  # Creates the xml declaration
  #
  # `version` A version number string, e.g. 1.0
  # `encoding` Encoding declaration, e.g. UTF-8
  # `standalone` standalone document declaration: true or false
  declaration: (version, encoding, standalone) ->
    @openCurrent()

    if @documentStarted
      throw new Error "declaration() must be the first node"

    node = new XMLDeclaration @, version, encoding, standalone
    @onData(@writer.declaration(node, @currentLevel + 1))

    return @


  # Creates the document type declaration
  #
  # `root`  the name of the root node
  # `pubID` the public identifier of the external subset
  # `sysID` the system identifier of the external subset
  doctype: (root, pubID, sysID) ->
    @openCurrent()

    if not root?
      throw new Error "Missing root node name"

    if @root
      throw new Error "dtd() must come before the root node"

    @currentNode = new XMLDocType @, pubID, sysID
    @currentNode.rootNodeName = root
    @currentNode.children = false
    @currentLevel++
    @openTags[@currentLevel] = @currentNode

    return @


  # Creates an element type declaration
  #
  # `name` element name
  # `value` element content (defaults to #PCDATA)
  dtdElement: (name, value) ->
    @openCurrent()

    node = new XMLDTDElement @, name, value
    @onData(@writer.dtdElement(node, @currentLevel + 1))

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
    @openCurrent()

    node = new XMLDTDAttList @, elementName, attributeName, attributeType, defaultValueType, defaultValue
    @onData(@writer.dtdAttList(node, @currentLevel + 1))

    return @


  # Creates a general entity declaration
  #
  # `name` the name of the entity
  # `value` internal entity value or an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  # `value.nData` notation declaration
  entity: (name, value) ->
    @openCurrent()

    node = new XMLDTDEntity @, false, name, value
    @onData(@writer.dtdEntity(node, @currentLevel + 1))

    return @


  # Creates a parameter entity declaration
  #
  # `name` the name of the entity
  # `value` internal entity value or an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  pEntity: (name, value) ->
    @openCurrent()

    node = new XMLDTDEntity @, true, name, value
    @onData(@writer.dtdEntity(node, @currentLevel + 1))

    return @


  # Creates a NOTATION declaration
  #
  # `name` the name of the notation
  # `value` an object with external entity details
  # `value.pubID` public identifier
  # `value.sysID` system identifier
  notation: (name, value) ->
    @openCurrent()

    node = new XMLDTDNotation @, name, value
    @onData(@writer.dtdNotation(node, @currentLevel + 1))

    return @


  # Gets the parent node
  up: () ->
    if @currentLevel < 0
      throw new Error "The document node has no parent"

    if @currentNode
      if @currentNode.children then @closeNode(@currentNode) else @openNode(@currentNode)
      @currentNode = null
    else
      @closeNode(@openTags[@currentLevel])

    delete @openTags[@currentLevel]
    @currentLevel--

    return @


  # Ends the document
  end: () ->
    while @currentLevel >= 0
      @up()

    @onEnd()


  # Opens the current parent node
  openCurrent: () ->
    if @currentNode
      @currentNode.children = true
      @openNode(@currentNode)


  # Writes the opening tag of the current node or the entire node if it has
  # no child nodes
  openNode: (node) ->
    if not node.isOpen
      if not @root and @currentLevel is 0 and node instanceof XMLElement then @root = node
      @onData(@writer.openNode(node, @currentLevel))
      node.isOpen = true


  # Writes the closing tag of the current node
  closeNode: (node) ->
    if not node.isClosed
      @onData(@writer.closeNode(node, @currentLevel))
      node.isClosed = true


  # Called when a new chunk of XML is output
  #
  # `chunk` a string containing the XML chunk
  onData: (chunk) ->
    @documentStarted = true
    @onDataCallback(chunk)


  # Called when the XML document is completed
  onEnd: () ->
    @documentCompleted = true
    @onEndCallback()


  # Node aliases
  ele: () -> @element arguments...
  nod: (name, attributes, text) -> @node name, attributes, text
  txt: (value) -> @text value
  dat: (value) -> @cdata value
  com: (value) -> @comment value
  ins: (target, value) -> @instruction target, value
  dec: (version, encoding, standalone) -> @declaration version, encoding, standalone
  dtd: (root, pubID, sysID) -> @doctype root, pubID, sysID
  e: (name, attributes, text) -> @element name, attributes, text
  n: (name, attributes, text) -> @node name, attributes, text
  t: (value) -> @text value
  d: (value) -> @cdata value
  c: (value) -> @comment value
  r: (value) -> @raw value
  i: (target, value) -> @instruction target, value

  # Attribute aliases
  att: () ->
    if @currentNode and @currentNode instanceof XMLDocType
      @attList arguments...
    else
      @attribute arguments...
  a: () ->
    if @currentNode and @currentNode instanceof XMLDocType
      @attList arguments...
    else
      @attribute arguments...

  # DTD aliases
  # att() and ele() are defined above
  ent: (name, value) -> @entity name, value
  pent: (name, value) -> @pEntity name, value
  not: (name, value) -> @notation name, value
