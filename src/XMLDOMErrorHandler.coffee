
# Represents the error handler for DOM operations
module.exports = class XMLDOMErrorHandler


  # Initializes a new instance of `XMLDOMErrorHandler`
  #
  constructor: () ->

  # Called on the error handler when an error occurs.
  #
  # `error` the error message as a string
  handleError: (error) ->
    throw new Error(error)
