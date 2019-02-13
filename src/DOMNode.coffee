NodeType = null
Text = null
DocumentPosition = null

# Represents a generic XML node
module.exports = class Node


  # Initializes a new instance of `Node`
  #
  # `parent` the parent node
  constructor: (parent) ->
    # private property backing fields
    @_parentNode = parent
    @_nodeName = null
    @_nodeType = 0

    # public
    @children = []

    # first execution, load dependencies that are otherwise
    # circular (so we can't load them at the top)
    unless NodeType
      NodeType = require './NodeType'
      Text = require './Text'
      DocumentPosition = require './DocumentPosition'


  # Returns the type of the node.
  Object.defineProperty @::, 'nodeType', get: () -> @_nodeType


  # Returns a string appropriate for the type of node.
  Object.defineProperty @::, 'nodeName', get: () -> @_nodeName


  # Returns the associated base URL.
  Object.defineProperty @::, 'baseURI', value: '', writable: true


  # Returns the parent document.
  Object.defineProperty @::, 'ownerDocument', get: () ->
    node = null
    while (node = if node then node.parent else @)
      if node.type is NodeType.Document
        return node
    return null


  # Returns the parent node.
  Object.defineProperty @::, 'parentNode', get: () -> @_parentNode


  # Returns the parent Element node. If the parent node has another
  # type, this property returns null.
  Object.defineProperty @::, 'parentElement', get: () -> 
    if @_parentNode.type is NodeType.Element then @_parentNode else null


  # Determines whether a node has any children.
  hasChildNodes: () -> @children.length isnt 0
  

  # Returns a NodeList of child nodes.
  Object.defineProperty @::, 'childNodes', get: () -> 
    if not @childNodeList or not @childNodeList.nodes
      @childNodeList = new XMLNodeList @children
    return @childNodeList


  # Returns the first child node.
  Object.defineProperty @::, 'firstChild', get: () -> 
    @children[0] or null


  # Returns the last child node.
  Object.defineProperty @::, 'lastChild', get: () -> 
    @children[@children.length - 1] or null


  # Returns the previous sibling node.
  Object.defineProperty @::, 'previousSibling', get: () ->
      i = @parentNode.children.indexOf @
      @parentNode.children[i - 1] or null


  # Returns the next sibling node.
  Object.defineProperty @::, 'nextSibling', get: () ->
      i = @parentNode.children.indexOf @
      @parentNode.children[i + 1] or null


  # Gets or sets the data associated with a CharacterData node. For
  # other returns null.
  Object.defineProperty @::, 'nodeValue', 
    get: () ->
      if @nodeType is NodeType.Text or @nodeType is NodeType.Comment or @nodeType is NodeType.ProcessingInstruction
        return @data
      else
        return null
    set: (value) ->
      if @nodeType is NodeType.Text or @nodeType is NodeType.Comment or  @nodeType is NodeType.ProcessingInstruction
        @data = value or ''


  # Returns the concatenation of data of all the CharacterData node
  # descendants in tree order. 
  Object.defineProperty @::, 'textContent', get: () ->
    get: () ->
      if @nodeType is NodeType.Text or @nodeType is NodeType.Comment or @nodeType is NodeType.ProcessingInstruction
        return @data
      else if @nodeType is NodeType.Element or @nodeType is NodeType.DocumentFragment
        str = ''
        for child in @children
          str += child.textContent if child.textContent?
        return str
      else
        return null
    set: (value) ->
      if @nodeType is NodeType.Text or @nodeType is NodeType.Comment or  @nodeType is NodeType.ProcessingInstruction
        @data = value or ''
      else if @nodeType is NodeType.Element or @nodeType is NodeType.DocumentFragment
        @children = []
        if value?
          node = new Text(value)
          node.setParent @
          @children.push node
          

  # Puts all Text nodes in the full depth of the sub-tree underneath
  # this node into a "normal" form where only markup (e.g., tags, 
  # comments, processing instructions, CDATA sections, and entity 
  # references) separates Text nodes, i.e., there are no adjacent Text
  # nodes.
  normalize: () -> 
    throw new Error "This DOM method is not implemented." + @debugInfo()


  # Returns a duplicate of this node, i.e., serves as a generic copy 
  # constructor for nodes. The duplicate node has no parent (parentNode 
  # returns null).
  #
  # `deep` if true, recursively clone the subtree under the specified 
  # node; if false, clone only the node itself (and its attributes, 
  # if it is an Element).
  cloneNode: (deep) ->
    clonedSelf = Object.create @

    # remove parent element
    clonedSelf.setParent null

    # clone attributes
    clonedSelf.attribs = {}
    for own attName, att of @attribs
      clonedSelf.attribs[attName] = att.cloneNode()

    # clone child nodes
    if deep
      clonedSelf.children = []
      @children.forEach (child) ->
        clonedChild = child.cloneNode(deep)
        clonedChild.parent = clonedSelf
        clonedSelf.children.push clonedChild

    return clonedSelf


  # Determines if the given node is equal to this one.
  #
  # `node` the node to compare with
  isEqualNode: (node) -> 
    throw new Error "This DOM method is not implemented." + @debugInfo()


  # Returns a bitmask indicating the position of a node relative to this
  # node.
  compareDocumentPosition: (node) -> 
    throw new Error "This DOM method is not implemented." + @debugInfo()

  
  # Returns true if given node is an inclusive descendant of this node,
  # and false otherwise (including when other node is null).
  contains: (node) -> 
    throw new Error "This DOM method is not implemented." + @debugInfo()


  # Returns the prefix for a given namespace URI, if present, and null
  # if not.
  lookupPrefix: (namespace) -> 
    throw new Error "This DOM method is not implemented." + @debugInfo()


  # Returns the namespace URI for a given prefix if present, and null
  # if not.
  lookupNamespaceURI: (prefix) -> 
    throw new Error "This DOM method is not implemented." + @debugInfo()


  # Returns true if the namespace is the default namespace on this
  # node or false if not.
  isDefaultNamespace: (namespace) -> 
    throw new Error "This DOM method is not implemented." + @debugInfo()


  # Inserts the node newChild before the existing child node refChild. 
  # If refChild is null, insert newChild at the end of the list of 
  # children.
  #
  # If newChild is a DocumentFragment object, all of its children are
  # inserted, in the same order, before refChild.
  #
  # If the newChild is already in the tree, it is first removed.
  #
  # `newChild` the node to insert
  # `refChild` the node before which the new node must be inserted
  insertBefore: (newChild, refChild) ->
    if node.nodeType is NodeType.DocumentFragment
      lastInsertedNode = null

      for childNode in newChild.children
        lastInsertedNode = @insertBefore childNode, refChild

      return lastInsertedNode
    else    
      if refChild
        # remove newChild if it is already in the tree
        index = @children.indexOf newChild
        if index isnt -1
          @children.splice(index, 1);
        else
          newChild.setParent @

        # temporarily remove children starting *with* refChild
        i = @children.indexOf refChild
        removed = @children.splice i
      
        # add the new child
        @children.push newChild
      
        # add back removed children after new child
        Array.prototype.push.apply @children, removed
      else
        @children.push newChild
  
      return newChild


  # Replaces the child node oldChild with newChild in the list of 
  # children, and returns the oldChild node. If the newChild is already
  # in the tree, it is first removed.
  #
  # `newChild` the new node to put in the child list
  # `oldChild` the node being replaced in the list
  replaceChild: (newChild, oldChild) ->
    # remove newChild if it is already in the tree
    index = @children.indexOf newChild
    if index isnt -1
      @children.splice(index, 1);
    else
      newChild.setParent @

    # find and replace oldChild
    index = @children.indexOf oldChild
    if index isnt -1
      @children[index] = newChild

    return oldChild


  # Removes the child node indicated by oldChild from the list of
  # children, and returns it.
  #
  # `oldChild` the node being replaced in the list
  removeChild: (oldChild) ->
    index = @children.indexOf oldChild
    if index isnt -1
      @children.splice(index, 1);

    return oldChild


  # Adds the node newChild to the end of the list of children of this
  # node, and returns it. If the newChild is already in the tree, it is
  # first removed.
  #
  # If newChild is a DocumentFragment object, the entire contents of the
  # document fragment are moved into the child list of this node.
  #
  # `newChild` the node to add
  appendChild: (newChild) ->
    if node.nodeType is NodeType.DocumentFragment
      lastInsertedNode = null

      for childNode in newChild.children
        lastInsertedNode = @appendChild childNode

      return lastInsertedNode
    else  
      # remove newChild if it is already in the tree
      index = @children.indexOf newChild
      if index isnt -1
        @children.splice(index, 1);
      else
        newChild.setParent @
  
      # add newChild
      @children.push newChild
  
      return newChild


  # Sets the parent node of this node and its children recursively.
  #
  # `parent` the parent node
  setParent: (parent) ->
    @_parentNode = parent

    for child in @children
      child.setParent @


  # Returns debug string for this node
  #
  # `name` optional node name
  debugInfo: (name) ->
    name = name or @nodeName
    parentName = @parentNode?.nodeName

    if not name? and not parentName
      ""
    else if not name?
      "parent: <" + parentName + ">"
    else if not parentName
      "node: <" + name + ">"
    else
      "node: <" + name + ">, parent: <" + parentName + ">"
