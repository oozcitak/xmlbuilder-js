# Represents a list of string entries
module.exports = class XMLDOMStringList


  # Initializes a new instance of `XMLDOMStringList`
  # This is just a wrapper around an ordinary
  # JS array.
  #
  # `arr` the array of string values
  constructor: (arr) ->
    @arr = arr or []

  # Returns the number of strings in the list.
  Object.defineProperty @::, 'length', get: () -> @arr.length

  # Returns the indexth item in the collection.
  #
  # `index` index into the collection
  item: (index) -> @arr[index] or null

  # Test if a string is part of this DOMStringList.
  #
  # `str` the string to look for
  contains: (str) -> @arr.indexOf(str) isnt -1
