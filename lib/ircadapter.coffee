IRC     = require("irc")
net     = require("net")

class IRCAdapter
  io: null
  socket: null

  server: null
  port: null
  nick: null
  channels: null

  debug: false

  constructor: (socket) ->
    console.log("IRCAdapter") unless @debug?
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

  disconnect: -> @io.disconnect()


  join: (data) ->
    for channel in data.channels
      @io.join(channel)

  message: (data) ->
    @io.say(data)

  eventsHandler: (data) ->
    command = data.command

    console.log command

    switch command
      when "JOIN"
        @socket.emit "JOIN", {nick: data.nick, channels: data.args}
      when "PRIVMSG"
        console.log data
        payload =
          nick: data.nick
          message: data.args.splice(1)[0]
          location: data.args.shift()
        @socket.emit "MESSAGE", payload
      else
        "poop"


module.exports = IRCAdapter
