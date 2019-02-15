XMLNode = require './XMLNode'

# Represents a character data node
module.exports = class XMLCharacterData extends XMLNode


  # Initializes a new instance of `XMLCharacterData`
  #
  constructor: (parent) ->
    super parent

    @value = ''

  # DOM level 1
  Object.defineProperty @::, 'data', 
    get: () -> @value
    set: (value) -> @value = value or ''
  Object.defineProperty @::, 'length', get: () -> @value.length

  # DOM level 3
  Object.defineProperty @::, 'textContent', 
    get: () -> @value
    set: (value) -> @value = value or ''

    
  # Creates and returns a deep clone of `this`
  clone: () ->
    Object.create @


  # DOM level 1 functions to be implemented later
  substringData: (offset, count) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  appendData: (arg) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  insertData: (offset, arg) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  deleteData: (offset, count) -> throw new Error "This DOM method is not implemented." + @debugInfo()
  replaceData: (offset, count, arg) -> throw new Error "This DOM method is not implemented." + @debugInfo()


  isEqualNode: (node) ->
    if not super.isEqualNode(node) then return false
    if node.data isnt @data then return false

    return true