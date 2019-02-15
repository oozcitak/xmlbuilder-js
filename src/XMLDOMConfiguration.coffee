XMLDOMErrorHandler = require './XMLDOMErrorHandler'
XMLDOMStringList = require './XMLDOMStringList'

# Implements the DOMConfiguration interface
module.exports = class XMLDOMConfiguration

  constructor: () ->
    @defaultParams =
      "canonical-form": false
      "cdata-sections": false
      "comments": false
      "datatype-normalization": false
      "element-content-whitespace": true
      "entities": true
      "error-handler": new XMLDOMErrorHandler()
      "infoset": true
      "validate-if-schema": false
      "namespaces": true
      "namespace-declarations": true
      "normalize-characters": false
      "schema-location": ''
      "schema-type": ''
      "split-cdata-sections": true
      "validate": false
      "well-formed": true

    @params = clonedSelf = Object.create @defaultParams


  # Returns the list of parameter names
  Object.defineProperty @::, 'parameterNames', get: () -> 
    new XMLDOMStringList(Object.keys(@defaultParams))


  # Gets the value of a parameter.
  #
  # `name` name of the parameter
  getParameter: (name) ->
    if @params.hasOwnProperty(name)
      return @params[name]
    else
      return null


  # Checks if setting a parameter to a specific value is supported.
  #
  # `name` name of the parameter
  # `value` parameter value
  canSetParameter: (name, value) -> true


  # Sets the value of a parameter.
  #
  # `name` name of the parameter
  # `value` new value or null if the user wishes to unset the parameter
  setParameter: (name, value) ->
    if value?
      @params[name] = value
    else
      delete @params[name]
