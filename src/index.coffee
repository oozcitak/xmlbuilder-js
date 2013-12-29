_ = require 'underscore'

XMLBuilder = require './XMLBuilder'

# Creates a new document and returns the root node for
# chain-building the document tree
#
# `name` name of the root element
#
# `xmldec.version` A version number string, e.g. 1.0
# `xmldec.encoding` Encoding declaration, e.g. UTF-8
# `xmldec.standalone` standalone document declaration: true or false
#
# `doctype.ext` the external subset containing markup declarations
#
# `options.headless` whether XML declaration and doctype will be included: true or false
# `options.allowSurrogateChars` whether surrogates will be allowed: true or false
# `options.skipNullAttributes` whether attributes with null values will be ignored: true or false
# `options.stringify` a set of functions to use for converting values to strings
module.exports.create = (name, xmldec, doctype, options) ->
  options = _.extend { }, xmldec, doctype, options
  new XMLBuilder(name, options).root()
