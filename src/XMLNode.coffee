{ isObject, isFunction, isEmpty, getValue } = require './Utility'

XMLElement = null
XMLCData = null
XMLComment = null
XMLDeclaration = null
XMLDocType = null
XMLRaw = null
XMLText = null
XMLProcessingInstruction = null
XMLDummy = null
NodeType = null
XMLNodeList = null
XMLNamedNodeMap = null
DocumentPosition = null

# Represents a generic XMl element
module.exports = class XMLNode


  # Initializes a new instance of `XMLNode`
  #
  # `parent` the parent node
  constructor: (@parent) ->
    if @parent
      @options = @parent.options
      @stringify = @parent.stringify

    @value = null
    @children = []
    @baseURI = null

    # first execution, load dependencies that are otherwise
    # circular (so we can't load them at the top)
    unless XMLElement
      XMLElement = require './XMLElement'
      XMLCData = require './XMLCData'
      XMLComment = require './XMLComment'
      XMLDeclaration = require './XMLDeclaration'
      XMLDocType = require './XMLDocType'
      XMLRaw = require './XMLRaw'
      XMLText = require './XMLText'
      XMLProcessingInstruction = require './XMLProcessingInstruction'
      XMLDummy = require './XMLDummy'
      NodeType = require './NodeType'
      XMLNodeList = require './XMLNodeList'
      XMLNamedNodeMap = require './XMLNamedNodeMap'
      DocumentPosition = require './DocumentPosition'


  # DOM level 1
  Object.defineProperty @::, 'nodeName', get: () -> @name
  Object.defineProperty @::, 'nodeType', get: () -> @type
  Object.defineProperty @::, 'nodeValue', get: () -> @value
  Object.defineProperty @::, 'parentNode', get: () -> @parent
  Object.defineProperty @::, 'childNodes', get: () -> 
    if not @childNodeList or not @childNodeList.nodes
      @childNodeList = new XMLNodeList @children
    return @childNodeList
  Object.defineProperty @::, 'firstChild', get: () -> @children[0] or null
  Object.defineProperty @::, 'lastChild', get: () -> @children[@children.length - 1] or null
  Object.defineProperty @::, 'previousSibling', get: () ->
    i = @parent.children.indexOf @
    @parent.children[i - 1] or null
  Object.defineProperty @::, 'nextSibling', get: () ->
    i = @parent.children.indexOf @
    @parent.children[i + 1] or null
  Object.defineProperty @::, 'ownerDocument', get: () -> @document() or null


  # DOM level 3
  Object.defineProperty @::, 'textContent', 
    get: () ->
      if @nodeType is NodeType.Element or @nodeType is NodeType.DocumentFragment
        str = ''
        for child in @children
          str += child.textContent if child.textContent
        return str
      else
        return null
    set: (value) ->
      throw new Error "This DOM method is not implemented." + @debugInfo()
  

  # Sets the parent node of this node and its children recursively
  #
  # `parent` the parent node
  setParent: (parent) ->
    @parent = parent
    if parent
      @options = parent.options
      @stringify = parent.stringify

    for child in @children
      child.setParent @


  # Creates a child element node
  #
  # `name` node name or an object describing the XML tree
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  element: (name, attributes, text) ->
    lastChild = null

    if attributes == null and not text?
      [attributes, text] = [{}, null]

    attributes ?= {}
    attributes = getValue attributes
    # swap argument order: text <-> attributes
    if not isObject attributes
      [text, attributes] = [attributes, text]

    name = getValue(name) if name?
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

        # assign attributes
        if not @options.ignoreDecorators and @stringify.convertAttKey and key.indexOf(@stringify.convertAttKey) == 0
          lastChild = @attribute(key.substr(@stringify.convertAttKey.length), val)

        # skip empty arrays
        else if not @options.separateArrayItems and Array.isArray(val) and isEmpty(val)
          lastChild = @dummy()

        # empty objects produce one node
        else if isObject(val) and isEmpty(val)
          lastChild = @element key

        # skip null and undefined nodes
        else if not @options.keepNullNodes and not val?
          lastChild = @dummy()
   
        # expand list by creating child nodes
        else if not @options.separateArrayItems and Array.isArray(val)
          for item in val
            childNode = {}
            childNode[key] = item
            lastChild = @element childNode
   
        # expand child nodes under parent
        else if isObject val
          # if the key is #text expand child nodes under this node to support mixed content
          if not @options.ignoreDecorators and @stringify.convertTextKey and key.indexOf(@stringify.convertTextKey) == 0
            lastChild = @element val
          else
            lastChild = @element key
            lastChild.element val
   
        # text node
        else
          lastChild = @element key, val

    # skip null nodes
    else if not @options.keepNullNodes and text is null
      lastChild = @dummy()

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
      # processing instruction
      else if not @options.ignoreDecorators and @stringify.convertPIKey and name.indexOf(@stringify.convertPIKey) == 0
        lastChild = @instruction name.substr(@stringify.convertPIKey.length), text
      # element node
      else
        lastChild = @node name, attributes, text

    if not lastChild?
      throw new Error "Could not create any elements with: " + name + ". " + @debugInfo()

    return lastChild


  # Creates a child element node before the current node
  #
  # `name` node name or an object describing the XML tree
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  insertBefore: (name, attributes, text) ->
    # DOM level 1
    # insertBefore(newChild, refChild) inserts the child node newChild before refChild
    if name?.type
      newChild = name
      refChild = attributes
      newChild.setParent @

      if refChild
        # temporarily remove children starting *with* refChild
        i = children.indexOf refChild
        removed = children.splice i
      
        # add the new child
        children.push newChild
      
        # add back removed children after new child
        Array.prototype.push.apply children, removed
      else
        children.push newChild

      return newChild
    else
      if @isRoot
        throw new Error "Cannot insert elements at root level. " + @debugInfo(name)
      
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
      throw new Error "Cannot insert elements at root level. " + @debugInfo(name)
    
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
      throw new Error "Cannot remove the root element. " + @debugInfo()

    i = @parent.children.indexOf @
    @parent.children[i..i] = []

    return @parent


  # Creates a node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  node: (name, attributes, text) ->
    name = getValue(name) if name?

    attributes or= {}
    attributes = getValue attributes
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
    if isObject value
      @element value
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


  # Creates a comment node before the current node
  #
  # `value` comment text
  commentBefore: (value) ->
    # temporarily remove children starting *with* this
    i = @parent.children.indexOf @
    removed = @parent.children.splice i

    # add the new child
    child = @parent.comment value

    # add back removed children after new child
    Array.prototype.push.apply @parent.children, removed

    return @


  # Creates a comment node after the current node
  #
  # `value` comment text
  commentAfter: (value) ->
    # temporarily remove children starting *after* this
    i = @parent.children.indexOf @
    removed = @parent.children.splice i + 1

    # add the new child
    child = @parent.comment value

    # add back removed children after new child
    Array.prototype.push.apply @parent.children, removed

    return @


  # Adds unescaped raw text
  #
  # `value` text
  raw: (value) ->
    child = new XMLRaw @, value
    @children.push child
    return @


  # Adds a dummy node
  dummy: () ->
    child = new XMLDummy @
    # Normally when a new node is created it is added to the child node collection.
    # However, dummy nodes are never added to the XML tree. They are created while
    # converting JS objects to XML nodes in order not to break the recursive function
    # chain. They can be thought of as invisible nodes. They can be traversed through
    # by using prev(), next(), up(), etc. functions but they do not exists in the tree.
    #
    # @children.push child
    return child

  # Adds a processing instruction
  #
  # `target` instruction target
  # `value` instruction value
  instruction: (target, value) ->
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
      instruction = new XMLProcessingInstruction @, target, value
      @children.push instruction
    return @


  # Creates a processing instruction node before the current node
  #
  # `target` instruction target
  # `value` instruction value
  instructionBefore: (target, value) ->
    # temporarily remove children starting *with* this
    i = @parent.children.indexOf @
    removed = @parent.children.splice i

    # add the new child
    child = @parent.instruction target, value

    # add back removed children after new child
    Array.prototype.push.apply @parent.children, removed

    return @


  # Creates a processing instruction node after the current node
  #
  # `target` instruction target
  # `value` instruction value
  instructionAfter: (target, value) ->
    # temporarily remove children starting *after* this
    i = @parent.children.indexOf @
    removed = @parent.children.splice i + 1

    # add the new child
    child = @parent.instruction target, value

    # add back removed children after new child
    Array.prototype.push.apply @parent.children, removed

    return @


  # Creates the xml declaration
  #
  # `version` A version number string, e.g. 1.0
  # `encoding` Encoding declaration, e.g. UTF-8
  # `standalone` standalone document declaration: true or false
  declaration: (version, encoding, standalone) ->
    doc = @document()

    xmldec = new XMLDeclaration doc, version, encoding, standalone

    # Replace XML declaration if exists, otherwise insert at top
    if doc.children.length is 0
      doc.children.unshift xmldec
    else if doc.children[0].type is NodeType.Declaration
      doc.children[0] = xmldec
    else
      doc.children.unshift xmldec

    return doc.root() or doc


  # Creates the document type declaration
  #
  # `pubID` the public identifier of the external subset
  # `sysID` the system identifier of the external subset
  dtd: (pubID, sysID) ->
    doc = @document()

    doctype = new XMLDocType doc, pubID, sysID

    # Replace DTD if exists
    for child, i in doc.children
      if child.type is NodeType.DocType
        doc.children[i] = doctype
        return doctype

    # insert before root node if the root node exists
    for child, i in doc.children
      if child.isRoot
        doc.children.splice i, 0, doctype
        return doctype

    # otherwise append to end
    doc.children.push doctype
    return doctype

  # Gets the parent node
  up: () ->
    if @isRoot
      throw new Error "The root node has no parent. Use doc() if you need to get the document object."
    return @parent


  # Gets the root node
  root: () ->
    node = @

    while node
      if node.type is NodeType.Document
        return node.rootObject
      else if node.isRoot
        return node
      else
        node = node.parent


  # Gets the node representing the XML document
  document: () ->
    node = @

    while node
      if node.type is NodeType.Document
        return node
      else
        node = node.parent


  # Ends the document and converts string
  end: (options) ->
    return @document().end(options)


  # Gets the previous node
  prev: () ->
    i = @parent.children.indexOf @

    if i < 1
      throw new Error "Already at the first node. " + @debugInfo()

    @parent.children[i - 1]


  # Gets the next node
  next: () ->
    i = @parent.children.indexOf @

    if i == -1 || i == @parent.children.length - 1
      throw new Error "Already at the last node. " + @debugInfo()

    @parent.children[i + 1]


  # Imports cloned root from another XML document
  #
  # `doc` the XML document to insert nodes from
  importDocument: (doc) ->
    clonedRoot = doc.root().clone()
    clonedRoot.parent = @
    clonedRoot.isRoot = false
    @children.push clonedRoot

    # set properties if imported element becomes the root node
    if @type is NodeType.Document
      clonedRoot.isRoot = true
      clonedRoot.documentObject = @
      @rootObject = clonedRoot
      # set dtd name
      if @children
        for child in @children
          if child.type is NodeType.DocType
            child.name = clonedRoot.name
            break

    return @
  

  # Returns debug string for this node
  debugInfo: (name) ->
    name = name or @name

    if not name? and not @parent?.name
      ""
    else if not name?
      "parent: <" + @parent.name + ">"
    else if not @parent?.name
      "node: <" + name + ">"
    else
      "node: <" + name + ">, parent: <" + @parent.name + ">"


  # Aliases
  ele: (name, attributes, text) -> @element name, attributes, text
  nod: (name, attributes, text) -> @node name, attributes, text
  txt: (value) -> @text value
  dat: (value) -> @cdata value
  com: (value) -> @comment value
  ins: (target, value) -> @instruction target, value
  doc: () -> @document()
  dec: (version, encoding, standalone) -> @declaration version, encoding, standalone
  e: (name, attributes, text) -> @element name, attributes, text
  n: (name, attributes, text) -> @node name, attributes, text
  t: (value) -> @text value
  d: (value) -> @cdata value
  c: (value) -> @comment value
  r: (value) -> @raw value
  i: (target, value) -> @instruction target, value
  u: () -> @up()

  # can be deprecated in a future release
  importXMLBuilder: (doc) -> @importDocument doc

  # Adds or modifies an attribute.
  #
  # `name` attribute name
  # `value` attribute value
  attribute: (name, value) ->
    throw new Error "attribute() applies to element nodes only."
  att: (name, value) -> @attribute name, value
  a: (name, value) -> @attribute name, value

  # Removes an attribute
  #
  # `name` attribute name
  removeAttribute: (name) ->
    throw new Error "attribute() applies to element nodes only."

  # DOM level 1 functions to be implemented later
  replaceChild: (newChild, oldChild) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  removeChild: (oldChild) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  appendChild: (newChild) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  hasChildNodes: () -> @children.length isnt 0
  cloneNode: (deep) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  normalize: () -> throw new Error "This DOM method is not implemented." + @debugInfo()

  # DOM level 2
  isSupported: (feature, version) -> return true
  hasAttributes: () -> @attribs.length isnt 0

  # DOM level 3 functions to be implemented later
  compareDocumentPosition: (other) ->
    ref = @

    if ref is other 
      return 0
    else if @document() isnt other.document()
      res = DocumentPosition.Disconnected | DocumentPosition.ImplementationSpecific
      if Math.random() < 0.5 then res |= DocumentPosition.Preceding else res |= DocumentPosition.Following
      return res
    else if ref.isAncestor(other)
      return DocumentPosition.Contains | DocumentPosition.Preceding
    else if ref.isDescendant(other)
      return DocumentPosition.Contains | DocumentPosition.Following
    else if ref.isPreceding(other)
      return DocumentPosition.Preceding
    else
      return DocumentPosition.Following

  isSameNode: (other) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  lookupPrefix: (namespaceURI) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  isDefaultNamespace: (namespaceURI) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  lookupNamespaceURI: (prefix) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  isEqualNode: (node) ->
    if node.nodeType isnt @nodeType then return false

    if node.children.length isnt @children.length then return false
    for i in [0..@children.length - 1]
      if not @children[i].isEqualNode(node.children[i]) then return false

    return true
  getFeature: (feature, version) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  setUserData: (key, data, handler) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  getUserData: (key) -> throw new Error "This DOM method is not implemented." + @debugInfo()

  # Returns true if other is an inclusive descendant of node,
  # and false otherwise.
  contains: (other) ->
    if not other then return false
    return other is @ or @isDescendant other


  # An object A is called a descendant of an object B, if either A is 
  # a child of B or A is a child of an object C that is a descendant of B.
  isDescendant: (node) ->
    for child in @children
      if node is child then return true
      isDescendantChild = child.isDescendant(node)
      if isDescendantChild then return true

    return false


  # An object A is called an ancestor of an object B if and only if
  # B is a descendant of A.
  isAncestor: (node) ->
    node.isDescendant @


  # An object A is preceding an object B if A and B are in the 
  # same tree and A comes before B in tree order.
  isPreceding: (node) ->
    nodePos = @treePosition node
    thisPos = @treePosition @

    if nodePos is -1 or thisPos is -1 then false else nodePos < thisPos


  # An object A is folllowing an object B if A and B are in the 
  # same tree and A comes after B in tree order.
  isFollowing: (node) ->
    nodePos = @treePosition node
    thisPos = @treePosition @

    if nodePos is -1 or thisPos is -1 then false else nodePos > thisPos


  # Returns the preorder position of the given node in the tree, or -1
  # if the node is not in the tree.
  treePosition: (node) ->
    pos = 0
    found = false
    @foreachTreeNode @document(), (childNode) -> 
      pos++
      if not found and childNode is node then found = true

    if found then return pos else return -1
        

  # Depth-first preorder traversal through the XML tree
  foreachTreeNode: (node, func) ->
    node or= @document()
    for child in node.children
      if res = func(child) 
        return res
      else
        res = @foreachTreeNode(child, func)
        return res if res

