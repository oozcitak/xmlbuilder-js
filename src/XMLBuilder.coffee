XMLFragment = require './XMLFragment'

# Represents an XML builder
class XMLBuilder extends XMLFragment

  # Initializes a new instance of `XMLBuilder`
  constructor: () -> super null, '', {}, ''


  # Starts building an XML document
  begin: (name) ->
    if not name
      throw new Error "Root element needs a name"
    @name = name
    @children = []
    return @


module.exports = XMLBuilder
