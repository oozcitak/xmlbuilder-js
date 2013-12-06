XMLBuilder = require './XMLBuilder'

module.exports.create = (name, xmldec, doctype, options) ->
  # Create a new document and return the root node for
  # chain-building the document tree
  new XMLBuilder(name, xmldec, doctype, options).root()
