XMLBuilder = require './XMLBuilder'

module.exports.create = (name, xmldec, doctype, options) ->
  if name?
    # Create a new document and return the root node for
    # chain-building the document tree
    new XMLBuilder(name, xmldec, doctype, options).root()
  else
    # This path allows for documents without an xml prolog
    # It is being kept for compatibility with earlier versions
    # but should be deprecated in the future
    new XMLBuilder()

