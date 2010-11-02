module.exports = 

  builder: (options) ->
    new @XMLBuilder options

module.exports.__defineGetter__ 'XMLBuilder', ->
  require './xmlbuilder'
