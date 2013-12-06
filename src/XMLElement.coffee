_ = require 'underscore'

XMLNode = require './XMLNode'

# Represents an element of the XMl document
module.exports = class XMLElement extends XMLNode


  # Initializes a new instance of `XMLFragment`
  #
  # `parent` the parent node
  # `name` element name
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  constructor: (parent, name, attributes, text) ->
    super parent
    
    @name = name
    XMLAttribute = require './XMLAttribute'
    @attributes = {}
    for own attName, attValue of attributes
      @attributes[attName] = new XMLAttribute @, attName, attValue
    @value = text
    @children = []
    @instructions = []


  # Clones self
  #
  # `deep` true to clone child nodes as well
  clone: (deep) ->
    clonedSelf = new XMLElement @parent, @name, @attributes, @value
    if deep
      @children.forEach (child) ->
        clonedChild = child.clone(deep)
        clonedChild.parent = clonedSelf
        clonedSelf.children.push clonedChild
    return clonedSelf


  # Adds or modifies an attribute
  #
  # `name` attribute name
  # `value` attribute value
  attribute: (name, value) ->
    if not name?
      throw new Error "Missing attribute name"
    if not value?
      throw new Error "Missing attribute value"

    @attributes ?= {}
    XMLAttribute = require './XMLAttribute'
    @attributes[name] = new XMLAttribute @, name, value

    return @


  # Removes an attribute
  #
  # `name` attribute name
  removeAttribute: (name) ->
    if not name?
      throw new Error "Missing attribute name"

    delete @attributes[name]

    return @


  # Adds a processing instruction
  #
  # `target` instruction target
  # `value` instruction value
  instruction: (target, value) ->
    XMLProcessingInstruction = require './XMLProcessingInstruction'
    instruction = new XMLProcessingInstruction @, target, value
    @instructions.push instruction
    return @


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options?.pretty or false
    indent = options?.indent or '  '
    newline = options?.newline or '\n'
    level or= 0

    space = new Array(level + 1).join(indent)

    r = ''

    # instructions
    for instruction in @instructions
      r += instruction.toString options, level + 1

    # open tag
    if pretty
      r += space
    if not @value?
      r += '<' + @name
    else
      r += '' + @value

    # attributes
    for own name, att of @attributes
      r += att.toString options

    if @children.length == 0
      # empty element
      if not @value?
        r += '/>'
      if pretty
        r += newline
    else if pretty and @children.length == 1 and @children[0].value?
      # do not indent text-only nodes
      r += '>'
      r += @children[0].value
      r += '</' + @name + '>'
      r += newline
    else
      r += '>'
      if pretty
        r += newline
      # inner tags
      for child in @children
        r += child.toString options, level + 1
      # close tag
      if pretty
        r += space
      r += '</' + @name + '>'
      if pretty
        r += newline

    return r


  # Aliases
  att: (name, value) -> @attribute name, value
  ins: (target, value) -> @instruction target, value
  a: (name, value) -> @attribute name, value
  i: (target, value) -> @instruction target, value
