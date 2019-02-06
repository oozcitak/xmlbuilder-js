XMLNode = require './XMLNode'
NodeType = require './NodeType'

# Represents a  raw node
module.exports = class XMLDummy extends XMLNode


  # Initializes a new instance of `XMLDummy`
  #
  # `XMLDummy` is a special node representing a node with 
  # a null value. Dummy nodes are created while recursively
  # building the XML tree. Simply skipping null values doesn't
  # work because that would break the recursive chain.
  constructor: (parent) ->
    super parent

    @type = NodeType.Dummy


  # Creates and returns a deep clone of `this`
  clone: () ->
    Object.create @


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.offset` how many indentations to add to every line for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options) ->
    ''

