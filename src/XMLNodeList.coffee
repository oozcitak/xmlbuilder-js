# Represents a list of nodes
module.exports = class XMLNodeList


  # Initializes a new instance of `XMLNodeList`
  # This is just a wrapper around an ordinary
  # JS array.
  #
  # `nodes` the array containing nodes.
  constructor: (@nodes) ->


  # DOM level 1
  Object.defineProperty @::, 'length', get: () -> @nodes.length or 0


  # Creates and returns a deep clone of `this`
  #
  clone: () ->
    # this class should not be cloned since it wraps
    # around a given array. The calling function should check
    # whether the wrapped array is null and supply a new array
    # (from the clone).
    @nodes = null


  # DOM Level 1
  item: (index) -> @nodes[index] or null