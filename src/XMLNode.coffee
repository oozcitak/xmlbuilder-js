isObject = require 'lodash/lang/isObject'
isFunction = require 'lodash/lang/isFunction'
isEmpty = require 'lodash/lang/isEmpty'

XMLElement = null
XMLCData = null
XMLComment = null
XMLDeclaration = null
XMLDocType = null
XMLRaw = null
XMLText = null

# Represents a generic XMl element
module.exports = class XMLNode


  # Initializes a new instance of `XMLNode`
  #
  # `parent` the parent node
  constructor: (@parent) ->
    @options = @parent.options
    @stringify = @parent.stringify

    # first execution, load dependencies that are otherwise
    # circular (so we can't load them at the top)
    if XMLElement is null
      XMLElement = require './XMLElement'
      XMLCData = require './XMLCData'
      XMLComment = require './XMLComment'
      XMLDeclaration = require './XMLDeclaration'
      XMLDocType = require './XMLDocType'
      XMLRaw = require './XMLRaw'
      XMLText = require './XMLText'


  # Creates a child element node
  #
  # `name` node name or an object describing the XML tree
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  element: (name, attributes, text) ->
    lastChild = null

    attributes ?= {}
    attributes = attributes.valueOf()
    # swap argument order: text <-> attributes
    if not isObject attributes
      [text, attributes] = [attributes, text]

    name = name.valueOf() if name?
    # expand if array
    if Array.isArray name
      lastChild = @element item for item in name

    # evaluate if function
    else if isFunction name
      lastChild = @element name.apply()

    # expand if object
    else if isObject name
      for own key, val of name
        # evaluate if function
        val = val.apply() if isFunction val

        # skip empty or null objects and arrays
        val = null if (isObject val) and (isEmpty val)

        # assign attributes
        if not @options.ignoreDecorators and @stringify.convertAttKey and key.indexOf(@stringify.convertAttKey) == 0
          lastChild = @attribute(key.substr(@stringify.convertAttKey.length), val)

        # assign processing instructions
        else if not @options.ignoreDecorators and @stringify.convertPIKey and key.indexOf(@stringify.convertPIKey) == 0
          lastChild = @instruction(key.substr(@stringify.convertPIKey.length), val)

        # expand list by creating child nodes
        else if not @options.separateArrayItems and Array.isArray val
          for item in val
            childNode = {}
            childNode[key] = item
            lastChild = @element childNode

        # expand child nodes under parent
        else if isObject val
          lastChild = @element key
          lastChild.element val

        # text node
        else
          lastChild = @element key, val

    else
      # text node
      if not @options.ignoreDecorators and @stringify.convertTextKey and name.indexOf(@stringify.convertTextKey) == 0
        lastChild = @text text
      # cdata node
      else if not @options.ignoreDecorators and @stringify.convertCDataKey and name.indexOf(@stringify.convertCDataKey) == 0
        lastChild = @cdata text
      # comment node
      else if not @options.ignoreDecorators and @stringify.convertCommentKey and name.indexOf(@stringify.convertCommentKey) == 0
        lastChild = @comment text
      # raw text node
      else if not @options.ignoreDecorators and @stringify.convertRawKey and name.indexOf(@stringify.convertRawKey) == 0
        lastChild = @raw text
      # element node
      else
        lastChild = @node name, attributes, text

    if not lastChild?
      throw new Error "Could not create any elements with: " + name

    return lastChild


  # Creates a child element node before the current node
  #
  # `name` node name or an object describing the XML tree
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  insertBefore: (name, attributes, text) ->
    if @isRoot
      throw new Error "Cannot insert elements at root level"

    # temporarily remove children starting *with* this
    i = @parent.children.indexOf @
    removed = @parent.children.splice i

    # add the new child
    child = @parent.element name, attributes, text

    # add back removed children after new child
    Array.prototype.push.apply @parent.children, removed

    return child


  # Creates a child element node after the current node
  #
  # `name` node name or an object describing the XML tree
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  insertAfter: (name, attributes, text) ->
    if @isRoot
      throw new Error "Cannot insert elements at root level"

    # temporarily remove children starting *after* this
    i = @parent.children.indexOf @
    removed = @parent.children.splice i + 1

    # add the new child
    child = @parent.element name, attributes, text

    # add back removed children after new child
    Array.prototype.push.apply @parent.children, removed

    return child


  # Deletes a child element node
  #
  remove: () ->
    if @isRoot
      throw new Error "Cannot remove the root element"

    i = @parent.children.indexOf @
    @parent.children[i..i] = []

    return @parent


  # Creates a node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  node: (name, attributes, text) ->
    name = name.valueOf() if name?

    attributes ?= {}
    attributes = attributes.valueOf()
    # swap argument order: text <-> attributes
    if not isObject attributes
      [text, attributes] = [attributes, text]

    child = new XMLElement @, name, attributes
    child.text(text) if text?
    @children.push child
    return child


  # Creates a text node
  #
  # `value` element text
  text: (value) ->
    child = new XMLText @, value
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


  # Adds unescaped raw text
  #
  # `value` text
  raw: (value) ->
    child = new XMLRaw @, value
    @children.push child
    return @


  # Creates the xml declaration
  #
  # `version` A version number string, e.g. 1.0
  # `encoding` Encoding declaration, e.g. UTF-8
  # `standalone` standalone document declaration: true or false
  declaration: (version, encoding, standalone) ->
    doc = @document()
    xmldec = new XMLDeclaration doc, version, encoding, standalone
    doc.xmldec = xmldec
    return doc.root()


  # Creates the document type declaration
  #
  # `pubID` the public identifier of the external subset
  # `sysID` the system identifier of the external subset
  doctype: (pubID, sysID) ->
    doc = @document()
    doctype = new XMLDocType doc, pubID, sysID
    doc.doctype = doctype
    return doctype


  # Gets the parent node
  up: () ->
    if @isRoot
      throw new Error "The root node has no parent. Use doc() if you need to get the document object."
    return @parent


  # Gets the root node
  root: () ->
    if @isRoot
      return @

    child = @parent
    child = child.parent while not child.isRoot

    return child


  # Gets the node representing the XML document
  document: () ->
    return @root().documentObject


  # Ends the document and converts string
  end: (options) ->
    return @document().toString(options)


  # Gets the previous node
  prev: () ->
    if @isRoot
      throw new Error "Root node has no siblings"

    i = @parent.children.indexOf @
    if i < 1
      throw new Error "Already at the first node"
    @parent.children[i - 1]


  # Gets the next node
  next: () ->
    if @isRoot
      throw new Error "Root node has no siblings"

    i = @parent.children.indexOf @
    if i == -1 || i == @parent.children.length - 1
      throw new Error "Already at the last node"
    @parent.children[i + 1]


  # Imports cloned root from another XMLBuilder
  #
  # `xmlbuilder` the instance of XMLBuilder to insert nodes from
  importXMLBuilder: (xmlbuilder) ->
    clonedRoot = xmlbuilder.root().clone()
    clonedRoot.parent = @
    clonedRoot.isRoot = false
    @children.push clonedRoot
    return @


  # Aliases
  ele: (name, attributes, text) -> @element name, attributes, text
  nod: (name, attributes, text) -> @node name, attributes, text
  txt: (value) -> @text value
  dat: (value) -> @cdata value
  com: (value) -> @comment value
  doc: () -> @document()
  dec: (version, encoding, standalone) -> @declaration version, encoding, standalone
  dtd: (pubID, sysID) -> @doctype pubID, sysID
  e: (name, attributes, text) -> @element name, attributes, text
  n: (name, attributes, text) -> @node name, attributes, text
  t: (value) -> @text value
  d: (value) -> @cdata value
  c: (value) -> @comment value
  r: (value) -> @raw value
  u: () -> @up()
