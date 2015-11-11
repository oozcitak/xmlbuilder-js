assign = require 'lodash/object/assign'

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
# `doctype.pubID` public identifier of the external subset
# `doctype.sysID` system identifier of the external subset
#
# `options.headless` whether XML declaration and doctype will be included: true or false
# `options.allowSurrogateChars` whether surrogates will be allowed: true or false
# `options.skipNullAttributes` whether attributes with null values will be ignored: true or false
# `options.ignoreDecorators` whether decorator strings will be ignored when converting JS objects: true or false
# `options.separateArrayItems` whether array items are created as separate nodes when passed as an object value: true or false
# `options.stringify` a set of functions to use for converting values to strings
module.exports.create = (name, xmldec, doctype, options) ->
  options = assign { }, xmldec, doctype, options
  new XMLBuilder(name, options).root()
