
irc     = require("irc")
net     = require("net")
repl    = require("repl")
config  = require('config')

connections = 0
users = {}
app = {}

Object.defineProperty app, "socket",
  get: ->
    return ircclient.socket
  set: (newSocket) ->
    ircclient.socket = newSocket
    return
  enumerable: true
  configurable: true

ircclient = ->
  @client = null
  @socket = null

ircclient.prototype.start = ->
  app.client = new irc.Client config.server, config.nick,
    channels: ["#{config.channel}"]

  createListeners(app.client, app.socket)
  createRepl(app.client)


ircclient.prototype.setSocket = (socket) ->
  app.socket = socket

  socket.on 'disconnect', => console.log "DISCONNECT"


ircclient.prototype.say = (message) ->
  app.client.say("#vikinghug", message)


destroyListeners = (client) ->
  listeners = [
    "message"
    "names"
    "join"
    "part"
    "registered"
    "error"]



createListeners = (client, socket) ->
  client.addListener "message", (from, to, message) ->
    console.log "MESSAGE: #{from} => #{to} : #{message}"
    app.socket.emit("message", {from: from, to: to, message: message}) if app.socket?

  client.addListener "names#{config.channel}", (nicks) ->
    for key, value of nicks
      console.log "NAMES: #{key} : #{value}"
      users[key] = value
    console.log users

  client.addListener "join", (channel, nick, message) ->
    console.log "JOIN: #{nick} : #{message}"
    users[nick] = ''

  client.addListener "part", (channel, nick, reason, message) ->
    console.log "PART: #{nick} : #{message}"
    delete users[nick]

  client.addListener "registered", (message) ->
    console.log "REGISTERED: #{message}"

  client.addListener "error", (message) ->
    console.log "ERROR: #{message}"

  client.addListener '+mode', (channel, from, mode, argument, message) ->

  client.addListener "-mode", (channel, from, mode, argument, message) ->

  client.addListener "raw", (message) ->
    console.log "raw #{message}"
    app.socket.emit("raw", {message: message}) if app.socket?

  # client.addListener "", () ->
  # client.addListener "", () ->
  # client.addListener "", () ->
  # client.addListener "", () ->
  # client.addListener "", () ->
  # client.addListener "", () ->
  # client.addListener "", () ->


createRepl = (client) ->
  # REPL
  r = repl.start
    prompt: "> "
    input: process.stdin
    output: process.stdout

  r.context.say = (msg) ->
    client.say config.channel, msg
    return

  r.context.client = client
  r.context.users = users


module.exports = ircclient
