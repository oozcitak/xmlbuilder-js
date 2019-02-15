# Represents a map of nodes accessed by a string key
module.exports = class XMLNamedNodeMap


  # Initializes a new instance of `XMLNamedNodeMap`
  # This is just a wrapper around an ordinary
  # JS object.
  #
  # `nodes` the object containing nodes.
  constructor: (@nodes) ->
    
  
  # DOM level 1
  Object.defineProperty @::, 'length', get: () -> Object.keys(@nodes).length or 0


  # Creates and returns a deep clone of `this`
  #
  clone: () ->
    # this class should not be cloned since it wraps
    # around a given object. The calling function should check
    # whether the wrapped object is null and supply a new object
    # (from the clone).
    @nodes = null


  # DOM Level 1
  getNamedItem: (name) -> @nodes[name]
  setNamedItem: (node) ->
    oldNode = @nodes[node.nodeName]
    @nodes[node.nodeName] = node
    return oldNode or null
  removeNamedItem: (name) ->
    oldNode = @nodes[name]
    delete @nodes[name]
    return oldNode or null
  item: (index) -> @nodes[Object.keys(@nodes)[index]] or null

  # DOM level 2 functions to be implemented later
  getNamedItemNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented."
  setNamedItemNS: (node) -> throw new Error "This DOM method is not implemented."
  removeNamedItemNS: (namespaceURI, localName) -> throw new Error "This DOM method is not implemented."
