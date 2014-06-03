
class CalmSoul

  _log: true
  _debug: false
  _info: true

  set: ->
    args = {}

    if typeof arguments[0] == 'object'
      args = Array.prototype.slice.call(arguments).reduce (x, y) -> x.concat(y)
    else args[arguments[0]] = arguments[1]

    for key, value of args
      property = "_#{key}"
      # making sure one of the known properties is what is being asked for
      @[property] = value if @[property]?



  get: (prop) -> return @["_#{prop}"]

  log: -> console.log.apply(console, arguments) if (@_log)

  debug: -> console.log.apply(console, arguments) if (@_debug)

  info: -> console.log.apply(console, arguments) if (@_info)

module.exports = new CalmSoul()
