XMLNode = require './XMLNode'
NodeType = require './NodeType'

# Represents a  CDATA node
module.exports = class XMLDocumentFragment extends XMLNode


  # Initializes a new instance of `XMLDocumentFragment`
  #
  constructor: () ->
    super null

    @name = "#document-fragment"
    @type = NodeType.DocumentFragment
