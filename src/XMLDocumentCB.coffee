{ isObject, isFunction, isPlainObject, getValue } = require './Utility'

NodeType = require './NodeType'
XMLDocument = require './XMLDocument'
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
WriterState = require './WriterState'

# Represents an XML builder
module.exports = class XMLDocumentCB


  # Initializes a new instance of `XMLDocumentCB`
  #
  # `options.keepNullNodes` whether nodes with null values will be kept
  #     or ignored: true or false
  # `options.keepNullAttributes` whether attributes with null values will be
  #     kept or ignored: true or false
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
  #          string containing the XML chunk is passed to `onData` as its first
  #          argument, and the current indentation level as its second argument.
  # `onEnd`  the function to be called when the XML document is completed with
  #          `end`. `onEnd` does not receive any arguments.
  constructor: (options, onData, onEnd) ->
    @name = "?xml"
    @type = NodeType.Document
    
    options or= {}

    writerOptions = {}
    if not options.writer
      options.writer = new XMLStringWriter()
    else if isPlainObject(options.writer)
      writerOptions = options.writer
      options.writer = new XMLStringWriter()

    @options = options
    @writer = options.writer
    @writerOptions = @writer.filterOptions writerOptions
    @stringify = new XMLStringifier options
    @onDataCallback = onData or () ->
    @onEndCallback = onEnd or () ->

    @currentNode = null
    @currentLevel = -1
    @openTags = {}
    @documentStarted = false
    @documentCompleted = false
    @root = null


  # Creates a child element node from the given XMLNode
  #
  # `node` the child node
  createChildNode: (node) ->
    switch node.type
      when NodeType.CData   then @cdata   node.value
      when NodeType.Comment then @comment node.value
      when NodeType.Element 
        attributes = {}
        for own attName, att of node.attribs
          attributes[attName] = att.value
        @node node.name, attributes
      when NodeType.Dummy   then @dummy()
      when NodeType.Raw     then @raw     node.value
      when NodeType.Text    then @text    node.value
      when NodeType.ProcessingInstruction then @instruction node.target, node.value
      else throw new Error "This XML node type is not supported in a JS object: " + node.constructor.name

    # write child nodes recursively
    for child in node.children
      @createChildNode(child)
      if child.type is NodeType.Element then @up()

    return @

  # Creates a dummy node
  #
  dummy: () ->
    # no-op, just return this

    return @


  # Creates a node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  node: (name, attributes, text) ->
    if not name?
      throw new Error "Missing node name."

    if @root and @currentLevel is -1
      throw new Error "Document can only have one root node. " + @debugInfo(name)

    @openCurrent()

    name = getValue name

    attributes ?= {}
    attributes = getValue attributes
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
    if @currentNode and @currentNode.type is NodeType.DocType
      @dtdElement arguments...
    else
      if Array.isArray(name) or isObject(name) or isFunction(name)

        oldValidationFlag = @options.noValidation
        @options.noValidation = true
        root = new XMLDocument(@options).element('TEMP_ROOT')
        root.element(name)
        @options.noValidation = oldValidationFlag

        for child in root.children
          @createChildNode(child)
          if child.type is NodeType.Element then @up()

      else
        @node name, attributes, text

    return @

  # Adds or modifies an attribute
  #
  # `name` attribute name
  # `value` attribute value
  attribute: (name, value) ->
    if not @currentNode or @currentNode.children
      throw new Error "att() can only be used immediately after an ele() call in callback mode. " + @debugInfo(name)

    name = getValue(name) if name?

    if isObject name # expand if object
      for own attName, attValue of name
        @attribute attName, attValue
    else
      value = value.apply() if isFunction value
      if @options.keepNullAttributes and not value?
        @currentNode.attribs[name] = new XMLAttribute @, name, ""
      else if value?
        @currentNode.attribs[name] = new XMLAttribute @, name, value

    return @


  # Creates a text node
  #
  # `value` element text
  text: (value) ->
    @openCurrent()

    node = new XMLText @, value
    @onData(@writer.text(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

    return @


  # Creates a CDATA node
  #
  # `value` element text without CDATA delimiters
  cdata: (value) ->
    @openCurrent()

    node = new XMLCData @, value
    @onData(@writer.cdata(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

    return @


  # Creates a comment node
  #
  # `value` comment text
  comment: (value) ->
    @openCurrent()

    node = new XMLComment @, value
    @onData(@writer.comment(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

    return @


  # Adds unescaped raw text
  #
  # `value` text
  raw: (value) ->
    @openCurrent()

    node = new XMLRaw @, value
    @onData(@writer.raw(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

    return @


  # Adds a processing instruction
  #
  # `target` instruction target
  # `value` instruction value
  instruction: (target, value) ->
    @openCurrent()

    target = getValue(target) if target?
    value = getValue(value) if value?

    if Array.isArray target # expand if array
      for insTarget in target
        @instruction insTarget
    else if isObject target # expand if object
      for own insTarget, insValue of target
        @instruction insTarget, insValue
    else
      value = value.apply() if isFunction value
      node = new XMLProcessingInstruction @, target, value
      @onData(@writer.processingInstruction(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

    return @


  # Creates the xml declaration
  #
  # `version` A version number string, e.g. 1.0
  # `encoding` Encoding declaration, e.g. UTF-8
  # `standalone` standalone document declaration: true or false
  declaration: (version, encoding, standalone) ->
    @openCurrent()

    if @documentStarted
      throw new Error "declaration() must be the first node."

    node = new XMLDeclaration @, version, encoding, standalone
    @onData(@writer.declaration(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

    return @


  # Creates the document type declaration
  #
  # `root`  the name of the root node
  # `pubID` the public identifier of the external subset
  # `sysID` the system identifier of the external subset
  doctype: (root, pubID, sysID) ->
    @openCurrent()

    if not root?
      throw new Error "Missing root node name."

    if @root
      throw new Error "dtd() must come before the root node."

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
    @onData(@writer.dtdElement(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

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
    @onData(@writer.dtdAttList(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

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
    @onData(@writer.dtdEntity(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

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
    @onData(@writer.dtdEntity(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

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
    @onData(@writer.dtdNotation(node, @writerOptions, @currentLevel + 1), @currentLevel + 1)

    return @


  # Gets the parent node
  up: () ->
    if @currentLevel < 0
      throw new Error "The document node has no parent."

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
      if not @root and @currentLevel is 0 and node.type is NodeType.Element then @root = node
      chunk = ''
      if node.type is NodeType.Element
        @writerOptions.state = WriterState.OpenTag
        chunk = @writer.indent(node, @writerOptions, @currentLevel) + '<' + node.name
    
        # attributes
        for own name, att of node.attribs
          chunk += @writer.attribute att,  @writerOptions, @currentLevel
    
        chunk += (if node.children then '>' else '/>') + @writer.endline(node,  @writerOptions, @currentLevel)
    
        @writerOptions.state = WriterState.InsideTag

      else # if node.type is NodeType.DocType
        @writerOptions.state = WriterState.OpenTag
        chunk = @writer.indent(node,  @writerOptions, @currentLevel) + '<!DOCTYPE ' + node.rootNodeName
    
        # external identifier
        if node.pubID and node.sysID
          chunk += ' PUBLIC "' + node.pubID + '" "' + node.sysID + '"'
        else if node.sysID
          chunk += ' SYSTEM "' + node.sysID + '"'
    
        # internal subset
        if node.children
          chunk += ' ['
          @writerOptions.state = WriterState.InsideTag
        else
          @writerOptions.state = WriterState.CloseTag
          chunk += '>'
        chunk += @writer.endline(node,  @writerOptions, @currentLevel)

      @onData(chunk, @currentLevel)
      node.isOpen = true


  # Writes the closing tag of the current node
  closeNode: (node) ->
    if not node.isClosed
      chunk = ''
      @writerOptions.state = WriterState.CloseTag
      if node.type is NodeType.Element
        chunk = @writer.indent(node, @writerOptions, @currentLevel) + '</' + node.name + '>' + @writer.endline(node, @writerOptions, @currentLevel)
      else # if node.type is NodeType.DocType
        chunk = @writer.indent(node, @writerOptions, @currentLevel) + ']>' + @writer.endline(node, @writerOptions, @currentLevel)
      @writerOptions.state = WriterState.None

      @onData(chunk, @currentLevel)
      node.isClosed = true


  # Called when a new chunk of XML is output
  #
  # `chunk` a string containing the XML chunk
  # `level` current indentation level
  onData: (chunk, level) ->
    @documentStarted = true
    @onDataCallback(chunk, level + 1)


  # Called when the XML document is completed
  onEnd: () ->
    @documentCompleted = true
    @onEndCallback()


  # Returns debug string
  debugInfo: (name) -> 
    if not name?
      ""
    else
      "node: <" + name + ">"


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
    if @currentNode and @currentNode.type is NodeType.DocType
      @attList arguments...
    else
      @attribute arguments...
  a: () ->
    if @currentNode and @currentNode.type is NodeType.DocType
      @attList arguments...
    else
      @attribute arguments...

  # DTD aliases
  # att() and ele() are defined above
  ent: (name, value) -> @entity name, value
  pent: (name, value) -> @pEntity name, value
  not: (name, value) -> @notation name, value
