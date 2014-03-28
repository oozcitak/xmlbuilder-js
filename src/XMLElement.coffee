_ = require 'lodash-node'

XMLNode = require './XMLNode'
XMLAttribute = require './XMLAttribute'
XMLProcessingInstruction = require './XMLProcessingInstruction'

# Represents an element of the XMl document
module.exports = class XMLElement extends XMLNode


  # Initializes a new instance of `XMLFragment`
  #
  # `parent` the parent node
  # `name` element name
  # `attributes` an object containing name/value pairs of attributes
  constructor: (parent, name, attributes) ->
    super parent

    if not name?
      throw new Error "Missing element name"

    @name = @stringify.eleName name
    @children = []
    @instructions = []
    @attributes = {}

    @attribute attributes if attributes?


  # Clones self
  #
  # `deep` true to clone child nodes as well
  clone: (deep) ->
    # shallow copy
    clonedSelf = _.clone @

    # clone attributes
    clonedSelf.attributes = {}
    for own attName, att of @attributes
      clonedSelf.attributes[attName] = _.clone att

    # clone processing instructions
    clonedSelf.instructions = []
    for pi in @instructions
      clonedSelf.instructions.push _.clone pi

    clonedSelf.children = []
    # clone child nodes
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
    if _.isObject name # expand if object
      for own attName, attValue of name
        @attribute attName, attValue
    else
      value = value.apply() if _.isFunction value
      if not @options.skipNullAttributes or value?
        @attributes[name] = new XMLAttribute @, name, value

    return @


  # Removes an attribute
  #
  # `name` attribute name
  removeAttribute: (name) ->
    if not name?
      throw new Error "Missing attribute name"

    if _.isArray name # expand if array
      for attName in name
        delete @attributes[attName]
    else
      delete @attributes[name]

    return @


  # Adds a processing instruction
  #
  # `target` instruction target
  # `value` instruction value
  instruction: (target, value) ->
    if _.isArray target # expand if array
      for insTarget in target
        @instruction insTarget
    else if _.isObject target # expand if object
      for own insTarget, insValue of target
        @instruction insTarget, insValue
    else
      value = value.apply() if _.isFunction value
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
    r += space if pretty
    r += '<' + @name

    # attributes
    for own name, att of @attributes
      r += att.toString options

    if @children.length == 0
      # empty element
      r += '/>'
      r += newline if pretty
    else if pretty and @children.length == 1 and @children[0].value?
      # do not indent text-only nodes
      r += '>'
      r += @children[0].value
      r += '</' + @name + '>'
      r += newline
    else
      r += '>'
      r += newline if pretty
      # inner tags
      for child in @children
        r += child.toString options, level + 1
      # close tag
      r += space if pretty
      r += '</' + @name + '>'
      r += newline if pretty

    return r


  # Aliases
  att: (name, value) -> @attribute name, value
  ins: (target, value) -> @instruction target, value
  a: (name, value) -> @attribute name, value
  i: (target, value) -> @instruction target, value
