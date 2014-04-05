IRCBridge = require('./ircbridge')


class Client
  socket: null
  server: null
  port: null
  nick: null
  channels: []
  ircbridge: null

  constructor: (socket) ->
    @socket = socket


  connect: (server, port, nick, channels) ->
    @server = server
    @port = port
    @nick = nick
    @channels = channels if channels?

    @ircbridge = new IRCBridge(server, port, nick, channels)

    @ircbridge.irc.addListener "registered", (message) =>
      connection =
        server: @server
        port: @port
        nick: @nick
        channels: @channels
      @socket.emit("CONNECTED", connection)

    @ircbridge.irc.addListener "raw", (message) =>
      @eventsHandler(message)

    return

  eventsHandler: (message) ->
    command = message.command

    switch command
      when "JOIN"
        @socket.emit "JOIN", {nick: message.nick, channels: message.args}
      else
        "poop"







module.exports = Client
