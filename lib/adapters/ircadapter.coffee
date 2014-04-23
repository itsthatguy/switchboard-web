#
# IRCAdapter
#
# Interface Method Requirements:
# - setsocket(socket)
# - connect(data)
# - disconnect()
# - join(data)
# - message(data)
#
# Interface Property Requirements:
# - id: string
# - isConnected: boolean
#

IRC          = require("irc")
net          = require("net")
EventEmitter = require('events').EventEmitter

class IRCAdapter extends EventEmitter
  io: null
  socket: null
  id: null

  server: null
  port: null
  nick: null
  channels: null
  isConnected: false

  debug: false

  constructor: (socket, id) ->
    console.log("IRCAdapter") unless @debug?
    @id = id
    @socket = socket

  setSocket: (socket) ->
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
      console.log "IRCAdapter::<registered>"
      connection =
        server: @server
        port: @port
        nick: @nick
        channels: @channels
      @socket.emit("CONNECTED", connection)

      @isConnected = true
      this.emit "REGISTERED"

    @io.addListener "raw", (message) =>
      @eventsHandler(message)

    @io.addListener "nick", (oldnick, newnick, channels, message) =>
      payload =
        oldnick: oldnick
        newnick: newnick
        channels: channels
        message: message
      @socket.emit "NICK", payload


  disconnect: -> @io.disconnect()


  join: (data) ->
    console.log "IRCAdapter::join (data) ->"
    io = @io
    for channel in data.channels
      io.join(channel)

  setNick: (data) ->
    @io.send("NICK", data.nick)

  message: (data) ->
    console.log "IRCAdapter::message (data) ->", data
    @io.say(data.channel, data.message)

  eventsHandler: (data) ->
    command = data.command

    console.log "COMMAND: ", command

    switch command
      when "JOIN"
        @socket.emit "JOIN", {nick: data.nick, channels: data.args}
      when "PRIVMSG"
        # console.log data
        payload =
          nick: data.nick
          message: data.args.splice(1)[0]
          channel: data.args.shift()
        @socket.emit "MESSAGE", payload
      else
        "poop"

module.exports = IRCAdapter
