# Represents a fragment of an XMl document
class XMLFragment


  # Initializes a new instance of `XMLFragment`
  #
  # `parent` the parent node
  # `name` element name
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  constructor: (parent, name, attributes, text) ->
    @isRoot = false
    @documentObject = null
    @parent = parent
    @name = name
    @attributes = attributes
    @value = text
    @children = []
    @assertLegalChar = parent.assertLegalChar

  # Creates a child element node
  #
  # `name` name of the node
  # `attributes` an object containing name/value pairs of attributes
  # `text` element text
  element: (name, attributes, text) ->
    if not name?
      throw new Error "Missing element name"

    name = '' + name or ''
    @assertLegalChar name
    attributes ?= {}

    # swap argument order: text <-> attribute
    if @is(attributes, 'String') and @is(text, 'Object')
      [attributes, text] = [text, attributes]
    else if @is(attributes, 'String')
      [attributes, text] = [{}, attributes]

    for own key, val of attributes
      val = '' + val or ''
      attributes[key] = @escape val

    child = new XMLFragment @, name, attributes

    if text?
      text = '' + text or ''
      text = @escape text
      @assertLegalChar text
      child.raw text

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

    if not name?
      throw new Error "Missing element name"

    name = '' + name or ''
    @assertLegalChar name
    attributes ?= {}

    # swap argument order: text <-> attribute
    if @is(attributes, 'String') and @is(text, 'Object')
      [attributes, text] = [text, attributes]
    else if @is(attributes, 'String')
      [attributes, text] = [{}, attributes]

    for own key, val of attributes
      val = '' + val or ''
      attributes[key] = @escape val

    child = new XMLFragment @parent, name, attributes

    if text?
      text = '' + text or ''
      text = @escape text
      @assertLegalChar text
      child.raw text

    i = @parent.children.indexOf @
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

    if not name?
      throw new Error "Missing element name"

    name = '' + name or ''
    @assertLegalChar name
    attributes ?= {}

    # swap argument order: text <-> attribute
    if @is(attributes, 'String') and @is(text, 'Object')
      [attributes, text] = [text, attributes]
    else if @is(attributes, 'String')
      [attributes, text] = [{}, attributes]

    for own key, val of attributes
      val = '' + val or ''
      attributes[key] = @escape val

    child = new XMLFragment @parent, name, attributes

    if text?
      text = '' + text or ''
      text = @escape text
      @assertLegalChar text
      child.raw text

    i = @parent.children.indexOf @
    @parent.children.splice i + 1, 0, child
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
    if not value?
      throw new Error "Missing element text"

    value = '' + value or ''
    value = @escape value
    @assertLegalChar value

    child = new XMLFragment @, '', {}, value
    @children.push child
    return @


  # Creates a CDATA node
  #
  # `value` element text without CDATA delimiters
  cdata: (value) ->
    if not value?
      throw new Error "Missing CDATA text"

    value = '' + value or ''
    @assertLegalChar value

    if value.match /]]>/
      throw new Error "Invalid CDATA text: " + value

    child = new XMLFragment @, '', {}, '<![CDATA[' + value + ']]>'
    @children.push child
    return @


  # Creates a comment node
  #
  # `value` comment text
  comment: (value) ->
    if not value?
      throw new Error "Missing comment text"

    value = '' + value or ''
    value = @escape value
    @assertLegalChar value

    if value.match /--/
      throw new Error "Comment text cannot contain double-hypen: " + value

    child = new XMLFragment @, '', {}, '<!-- ' + value + ' -->'
    @children.push child
    return @


  # Adds unescaped raw text
  #
  # `value` text
  raw: (value) ->
    if not value?
      throw new Error "Missing raw text"

    value = '' + value or ''

    child = new XMLFragment @, '', {}, value
    @children.push child
    return @


  # Gets the parent node
  up: () ->
    if @isRoot
      throw new Error "This node has no parent. Use doc() if you need to get the document object."
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


  # Clones self
  #
  # `deep` true to clone child nodes as well
  clone: (deep) ->
    clonedSelf = new XMLFragment @parent, @name, @attributes, @value
    if deep
      @children.forEach (child) ->
        clonedChild = child.clone(deep)
        clonedChild.parent = clonedSelf
        clonedSelf.children.push clonedChild
    return clonedSelf


  # Imports cloned root from another XMLBuilder
  #
  # `xmlbuilder` the instance of XMLBuilder to insert nodes from
  importXMLBuilder: (xmlbuilder) ->
    clonedRoot = xmlbuilder.root().clone(true)
    clonedRoot.parent = @
    @children.push clonedRoot
    clonedRoot.isRoot = false
    return @


  # Adds or modifies an attribute
  #
  # `name` attribute name
  # `value` attribute value
  attribute: (name, value) ->
    if not name?
      throw new Error "Missing attribute name"
    if not value?
      throw new Error "Missing attribute value"

    name = '' + name or ''
    value = '' + value or ''
    @attributes ?= {}

    @attributes[name] = @escape value

    return @


  # Removes an attribute
  #
  # `name` attribute name
  removeAttribute: (name) ->
    if not name?
      throw new Error "Missing attribute name"

    name = '' + name or ''

    delete @attributes[name]

    return @


  # Converts the XML fragment to string
  #
  # `options.pretty` pretty prints the result
  # `options.indent` indentation for pretty print
  # `options.newline` newline sequence for pretty print
  toString: (options, level) ->
    pretty = options? and options.pretty or false
    indent = options? and options.indent or '  '
    newline = options? and options.newline or '\n'
    level or= 0

    space = new Array(level + 1).join(indent)

    r = ''
    # open tag
    if pretty
      r += space
    if not @value?
      r += '<' + @name
    else
      r += '' + @value

    # attributes
    for attName, attValue of @attributes
      if @name == '!DOCTYPE'
        r += ' ' + attValue
      else
        r += ' ' + attName + '="' + attValue + '"'

    if @children.length == 0
      # empty element
      if not @value?
        r += if @name == '?xml' then '?>' else if @name == '!DOCTYPE' then '>' else '/>'
      if pretty
        r += newline
    else if pretty and @children.length == 1 and @children[0].value
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


  # Escapes special characters <, >, ', ", &
  #
  # `str` the string to escape
  escape: (str) ->
    return str.replace(/&/g, '&amp;')
              .replace(/</g,'&lt;').replace(/>/g,'&gt;')
              .replace(/'/g, '&apos;').replace(/"/g, '&quot;')


  # Checks whether the given object is of the given type
  #
  # `obj` the object to check
  # `type` the type to compare to. (String, Number, Object, Date, ...)
  is: (obj, type) ->
    clas = Object.prototype.toString.call(obj).slice(8, -1)
    return obj? and clas is type


  # Aliases
  ele: (name, attributes, text) -> @element name, attributes, text
  txt: (value) -> @text value
  dat: (value) -> @cdata value
  att: (name, value) -> @attribute name, value
  com: (value) -> @comment value
  doc: () -> @document()
  e: (name, attributes, text) -> @element name, attributes, text
  t: (value) -> @text value
  d: (value) -> @cdata value
  a: (name, value) -> @attribute name, value
  c: (value) -> @comment value
  r: (value) -> @raw value
  u: () -> @up()

module.exports = XMLFragment

