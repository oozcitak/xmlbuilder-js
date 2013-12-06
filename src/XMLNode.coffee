_ = require 'underscore'

# Represents a generic XMl element
module.exports = class XMLNode


  # Initializes a new instance of `XMLNode`
  #
  # `parent` the parent node
  constructor: (@parent) ->
    @stringify = @parent.stringify


  # Creates a child element node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  element: (name, attributes, text) ->
    child = @makeElement @, name, attributes, text

    if _.isArray child
      Array.prototype.push.apply @children, child
      return _.last child
    else
      @children.push child
      return child


  # Creates a child element node before the current node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  insertBefore: (name, attributes, text) ->
    if @isRoot
      throw new Error "Cannot insert elements at root level"

    child = @makeElement @parent, name, attributes, text

    i = @parent.children.indexOf @

    if _.isArray child
      child.unshift i, 0
      Array.prototype.splice.apply @parent.children, child
      return _.last child
    else
      @parent.children.splice i, 0, child
      return child


  # Creates a child element node after the current node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  insertAfter: (name, attributes, text) ->
    if @isRoot
      throw new Error "Cannot insert elements at root level"

    child = @makeElement @parent, name, attributes, text

    i = @parent.children.indexOf @

    if _.isArray child
      child.unshift i + 1, 0
      Array.prototype.splice.apply @parent.children, child
      return _.last child
    else
      @parent.children.splice i + 1, 0, child
      return child


  # Creates a child element node without inserting into the XML tree
  #
  # `parent` parent node
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  makeElement: (parent, name, attributes, text) ->
    if not name?
      throw new Error "Missing element name"

    if _.isObject name
      items = []
      for own key, val of name
        if _.isFunction val
          val = val.apply()
          items.push @makeElement parent, key, val
        else if _.isArray val
          res = for item in val
            @makeElement parent, key, item
          Array.prototype.push.apply items, res
        else if _.isObject val
          child = @makeElement parent, key
          child.element val
          items.push child
        else
          items.push @makeElement parent, key, val
      return items
    else
      name = @stringify.eleName name
      attributes ?= {}

      # swap argument order: text <-> attributes
      if _.isObject(text) or not _.isObject(attributes)
        [attributes, text] = [text, attributes]

      atts = {}
      for own key, val of attributes
        if key? and val?
          atts[key] = val

      XMLElement = require './XMLElement'
      child = new XMLElement parent, name, atts

      if text?
        text = @stringify.eleText text
        child.raw text

      return child


  # Deletes a child element node
  #
  remove: () ->
    if @isRoot
      throw new Error "Cannot remove the root element"

    i = @parent.children.indexOf @
    @parent.children[i..i] = []

    return @parent


  # Creates a text node
  #
  # `value` element text
  text: (value) ->
    XMLText = require './XMLText'
    child = new XMLText @, value
    @children.push child
    return @


  # Creates a CDATA node
  #
  # `value` element text without CDATA delimiters
  cdata: (value) ->
    XMLCData = require './XMLCData'
    child = new XMLCData @, value
    @children.push child
    return @


  # Creates a comment node
  #
  # `value` comment text
  comment: (value) ->
    XMLComment = require './XMLComment'
    child = new XMLComment @, value
    @children.push child
    return @


  # Adds unescaped raw text
  #
  # `value` text
  raw: (value) ->
    XMLRaw = require './XMLRaw'
    child = new XMLRaw @, value
    @children.push child
    return @


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
    clonedRoot = xmlbuilder.root().clone(true)
    clonedRoot.parent = @
    @children.push clonedRoot
    clonedRoot.isRoot = false
    return @


  # Clones self
  #
  # `deep` true to clone child nodes as well
  clone: (deep) ->
    _.clone @


  # Aliases
  ele: (name, attributes, text) -> @element name, attributes, text
  txt: (value) -> @text value
  dat: (value) -> @cdata value
  com: (value) -> @comment value
  doc: () -> @document()
  e: (name, attributes, text) -> @element name, attributes, text
  t: (value) -> @text value
  d: (value) -> @cdata value
  c: (value) -> @comment value
  r: (value) -> @raw value
  u: () -> @up()
