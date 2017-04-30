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


module.exports.assign = assign
module.exports.isFunction = isFunction
module.exports.isObject = isObject
module.exports.isArray = isArray
module.exports.isEmpty = isEmpty
module.exports.isPlainObject = isPlainObject

