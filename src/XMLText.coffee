NodeType = require './NodeType'
XMLCharacterData = require './XMLCharacterData'

# Represents a text node
module.exports = class XMLText extends XMLCharacterData


  # Initializes a new instance of `XMLText`
  #
  # `text` element text
  constructor: (parent, text) ->
    super parent

    if not text?
      throw new Error "Missing element text. " + @debugInfo()

    @name = "#text"
    @type = NodeType.Text
    @value = @stringify.text text


  # DOM level 3
  Object.defineProperty @::, 'isElementContentWhitespace',
    get: () ->
      throw new Error "This DOM method is not implemented." + @debugInfo()
  Object.defineProperty @::, 'wholeText', 
    get: () ->
      str = ''

      prev = @previousSibling
      while prev
        str = prev.data + str
        prev = prev.previousSibling
        
      str += @data

      next = @nextSibling
      while next
        str = str + next.data
        next = next.nextSibling
    
      return str


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
    @options.writer.text @, @options.writer.filterOptions(options)


  # DOM level 1 functions to be implemented later
  splitText: (offset) -> throw new Error "This DOM method is not implemented." + @debugInfo()

  # DOM level 3 functions to be implemented later
  replaceWholeText: (content) -> throw new Error "This DOM method is not implemented." + @debugInfo()