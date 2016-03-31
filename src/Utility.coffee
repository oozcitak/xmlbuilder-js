# Copies all enumerable own properties from `sources` to `target`
assign = (target, sources...) ->
  if isFunction Object.assign
    Object.assign.apply null, arguments
  else
    for source in sources when source?
      target[key] = source[key] for own key of source

  return target

# Determines if `val` is a Function object
isFunction = (val) ->
  !!val and Object.prototype.toString.call(val) is '[object Function]'

# Determines if `val` is an Object
isObject = (val) ->
  !!val and typeof val in ['function', 'object']

# Determines if `val` is an Array
isArray = (val) ->
  if isFunction Array.isArray
     Array.isArray val
  else
    Object.prototype.toString.call(val) is '[object Array]'

# Determines if `val` is an empty Array or an Object with no own properties
isEmpty = (val) ->
  if isArray val
    return !val.length
  else
    for own key of val
      return false
    return true

# Determines if `val` is a plain Object
isPlainObject = (val) ->
  isObject(val) and
    (proto = Object.getPrototypeOf val) and
    (ctor = proto.constructor) and
    (typeof ctor is 'function') and
    (ctor instanceof ctor) and
    (Function.prototype.toString.call(ctor) is Function.prototype.toString.call(Object))

# Splits the given string into words
words = (val) ->
  (val.split(/[-_\s]+|(?=[A-Z][a-z])/) or []).filter((n) -> !!n)

# Converts the string to camel case
camelCase = (val) ->
  r = ''
  for word, index in words(val)
    r += if index then capitalize(word.toLowerCase()) else word.toLowerCase()
  return r

# Converts the string to title case
titleCase = (val) ->
  r = ''
  for word, index in words(val)
    r += capitalize(word.toLowerCase())
  return r

# Converts the string to kebab case
kebabCase = (val) ->
  r = ''
  for word, index in words(val)
    r += (if index then '-' else '') + word.toLowerCase()
  return r

# Converts the string to snake case
snakeCase = (val) ->
  r = ''
  for word, index in words(val)
    r += (if index then '_' else '') + word.toLowerCase()
  return r

# Capitalize the first letter of the string
capitalize = (val) ->
  val.charAt(0).toUpperCase() + val.slice(1);


module.exports.assign = assign
module.exports.isFunction = isFunction
module.exports.isObject = isObject
module.exports.isArray = isArray
module.exports.isEmpty = isEmpty
module.exports.isPlainObject = isPlainObject

module.exports.camelCase = camelCase
module.exports.titleCase = titleCase
module.exports.kebabCase = kebabCase
module.exports.snakeCase = snakeCase
module.exports.capitalize = capitalize
module.exports.words = words

