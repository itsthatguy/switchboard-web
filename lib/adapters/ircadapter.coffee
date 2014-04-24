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
    console.log ">>>>>", data
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
      console.log "<< IRCAdapter::<registered>"
      connection =
        server: @server
        port: @port
        nick: @nick
        channels: @channels
      @socket.emit("CONNECTED", connection)

      @isConnected = true
      this.emit "REGISTERED"

    @io.addListener "join", (channel, nick, message) =>
      console.log "<< IRCAdapter::<join>", channel, nick, message
      payload =
        nick: nick
        channel: channel
        message: message
      @socket.emit "JOIN", payload

    @io.addListener "part", (channel, nick, message) =>
      console.log "<< IRCAdapter::<part>", channel, nick, message
      payload =
        nick: nick
        channel: channel
        message: message
      @socket.emit "PART", payload

    @io.addListener "quit", (nick, reason, channels, message) =>
      console.log "<< IRCAdapter::<quit>", nick, reason, channels, message
      @socket.emit "QUIT"

    @io.addListener "kick", (channel, nick, byNick, reason, message) =>
      console.log "<< IRCAdapter::<kick>", channel, nick, byNick, reason, message
      @socket.emit "KICK"

    @io.addListener "raw", (message) =>
      # console.log "<< IRCAdapter::<raw>"
      # @eventsHandler(message)

    @io.addListener "nick", (oldnick, newnick, channels, message) =>
      console.log "<< IRCAdapter::<nick>", oldnick, newnick, channels, message
      payload =
        oldnick: oldnick
        newnick: newnick
        channels: channels
        message: message
      @socket.emit "NICK", payload

    @io.addListener "names", (channel, nicks) =>
      console.log "<< IRCAdapter::<names>"
      payload =
        channel: channel
        nicks: nicks
      @socket.emit "NAMES", payload


  disconnect: -> @io.disconnect()

  whoAmI: ->
    console.log "> whoAmiI: "
    payload =
      server: @io.opt.server
      nick: @io.nick
      userName: @io.opt.userName
      realName: @io.opt.realName
    @socket.emit "YOUARE", payload

  refresh: -> @getChannels()

  join: (data) ->
    console.log "IRCAdapter::join (data) ->"
    io = @io
    for channel in data.channels
      io.join(channel)

  setNick: (data) ->
    @io.send("NICK", data.nick)

  getChannels: ->
    console.log @io.chans

  getNames: (data) ->
    console.log "getNames", data
    @io.send("NAMES", data.channel)

  message: (data) ->
    console.log "IRCAdapter::message (data) ->", data
    @io.say(data.channel, data.message)

  eventsHandler: (data) ->
    command = data.command

    # console.log "  [RAW] COMMAND: ", command

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
