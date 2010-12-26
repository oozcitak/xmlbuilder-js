module.exports =

  builder: () ->
    new @XMLBuilder

module.exports.__defineGetter__ 'XMLBuilder', ->
  require './XMLBuilder'

