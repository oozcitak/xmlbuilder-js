XMLBuilder = require './XMLBuilder'

module.exports.create = (name, xmldec, doctype) ->
  if name?
    # Create a new document and return the root node for
    # chain-building the document tree
    new XMLBuilder(name, xmldec, doctype).root()
  else
    # This path allows for documents without an xml prolog
    # It is being kept for compatibility with earlier versions
    # but should be deprecated in the future
    new XMLBuilder()

module.exports.withopts = (options) ->
    create: (name, xmldec, doctype) ->
        if name?
            new XMLBuilder(name, xmldec, doctype, options).root()
        else
            new XMLBuilder(null, null, null, options).root()

