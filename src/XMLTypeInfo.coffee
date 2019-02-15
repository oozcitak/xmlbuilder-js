Derivation = require './Derivation'

# Represents a type referenced from element or attribute nodes.
module.exports = class XMLTypeInfo


  # Initializes a new instance of `XMLTypeInfo`
  #
  constructor: (@typeName, @typeNamespace) ->


  # DOM level 3 functions to be implemented later
  isDerivedFrom: (typeNamespaceArg, typeNameArg, derivationMethod) ->
    throw new Error "This DOM method is not implemented."
