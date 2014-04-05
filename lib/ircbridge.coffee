IRC     = require("irc")
net     = require("net")

class IRCBridge
  io: null
  socket: null

  server: null
  port: null
  nick: null
  channels: null

  debug: false

  constructor: (socket) ->
    console.log("IRCBridge") unless @debug?
    @socket = socket

  connect: (data) ->
    @server = data.server
    @port = data.port
    @nick = data.nick
    @channels = data.channels if data.channels?

    @io = new IRC.Client @server, @nick,
      showErrors: @debug
      debug: @debug
      port: @port
      channels: @channels

    @io.addListener "registered", (message) =>
      connection =
        server: @server
        port: @port
        nick: @nick
        channels: @channels
      @socket.emit("CONNECTED", connection)

    @io.addListener "raw", (message) =>
      @eventsHandler(message)

  join: (data) ->
    for channel in data.channels
      @io.join(channel)

  eventsHandler: (message) ->
    command = message.command

    switch command
      when "JOIN"
        @socket.emit "JOIN", {nick: message.nick, channels: message.args}
      else
        "poop"


module.exports = IRCBridge
