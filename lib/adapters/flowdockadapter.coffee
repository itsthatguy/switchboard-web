
# **************************************************************************
#
## Flowdock
#
# **************************************************************************
#
## Interface Method Requirements:
#   - setsocket(socket)
#   - connect(data)
#   - disconnect()
#   - join(data)
#   - message(data)
#
## Client socket messages:
#   These are event messages that are used to communicate with the client.
#   - (see SERVICE:LISTENERS below)
#
## Backend socket messages:
#   - this.emit('REGISTERED')
#     - Use this only after a successful connection to let the
#       ClientsManager know to clear it's queued call stack
#
#
## Interface Property Requirements:
#   - id: string
#   - isConnected: boolean
#
# **************************************************************************

Config       = require(process.env.PWD + '/config/default.coffee').flowdock
calmsoul      = require(process.env.PWD + '/lib/utilities/calmsoul.coffee')
Flowdock     = require("Flowdock").Session
net          = require("net")
EventEmitter = require('events').EventEmitter

# calmsoul.set("log", on)
# calmsoul.set("debug", on)
# calmsoul.set("info", on)

calmsoul.set("info": on, "debug": off, "pee": on, "poop": off, )

calmsoul.log "CalmSoul::log -> Log Enabled"
calmsoul.debug "CalmSoul::debug -> Debug Enabled"
calmsoul.info "CalmSoul::info -> Info Enabled"

class Flowdock extends EventEmitter
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
    loggins.log("Flowdock") unless @debug?
    @id = id
    @socket = socket

  setSocket: (socket) ->
    @socket = socket


  connect: (data) ->
    loggins.log ">>>>>", data
    @server = data.server
    @port = data.port
    @nick = data.nick
    @channels = data.channels if data.channels?

    @io = new Flowdock(Config.token)



    # **************************************************************************
    #
    ## SERVICE:LISTENERS
    #
    # **************************************************************************
    #
    ## Description:
    #   Service Listeners are listening to the adapter service only. In this
    #   case, Flowdock. After intercepting a message from the service, you  will
    #   need to emit a message on the socket (to the client) which will
    #   inform it to react.
    #
    ## Available outgoing messages
    #   - this.socket.emit('CONNECTED', connection)
    #   - this.socket.emit("MESSAGE", payload)
    #   - this.socket.emit("NICK", payload)
    #   - this.socket.emit("JOIN", payload)
    #   - this.socket.emit("PART", payload)
    #   - this.socket.emit("QUIT", payload)
    #   - this.socket.emit("NAMES", payload)
    #   - this.socket.emit("YOUARE", payload)
    #
    # **************************************************************************

    #
    # SERVICE:LISTENER::registered
    @io.addListener "registered", (message) =>
      loggins.log "<< Flowdock::<registered>"
      connection =
        server: @server
        port: @port
        nick: @nick
        channels: @channels
      @socket.emit("CONNECTED", connection)

      @isConnected = true
      this.emit "REGISTERED"

    #
    # SERVICE:LISTENER::message
    @io.addListener "message", (nick, to, text, message) =>
      loggins.log "<< Flowdock::<message>", nick, to, text
      payload =
        nick: nick
        message: text
        channel: to
      @socket.emit "MESSAGE", payload

    #
    # SERVICE:LISTENER::join
    @io.addListener "join", (channel, nick, message) =>
      loggins.log "<< Flowdock::<join>", channel, nick, message
      payload =
        nick: nick
        channel: channel
        message: message
      @socket.emit "JOIN", payload

    #
    # SERVICE:LISTENER::part
    @io.addListener "part", (channel, nick, message) =>
      loggins.log "<< Flowdock::<part>", channel, nick, message
      payload =
        nick: nick
        channel: channel
        message: message
      @socket.emit "PART", payload

    #
    # SERVICE:LISTENER::quit
    @io.addListener "quit", (nick, reason, channels, message) =>
      loggins.log "<< Flowdock::<quit>", nick, reason, channels, message
      @socket.emit "QUIT"

    #
    # SERVICE:LISTENER::kick
    @io.addListener "kick", (channel, nick, byNick, reason, message) =>
      loggins.log "<< Flowdock::<kick>", channel, nick, byNick, reason, message
      @socket.emit "KICK"

    #
    # SERVICE:LISTENER::nick
    @io.addListener "nick", (oldnick, newnick, channels, message) =>
      loggins.log "<< Flowdock::<nick>", oldnick, newnick, channels, message
      payload =
        oldnick: oldnick
        newnick: newnick
        channels: channels
        message: message
      @socket.emit "NICK", payload

    #
    # SERVICE:LISTENER::names
    @io.addListener "names", (channel, nicks) =>
      loggins.log "<< Flowdock::<names>"
      payload =
        channel: channel
        nicks: nicks
      @socket.emit "NAMES", payload

    #
    # SERVICE:LISTENER::raw
    @io.addListener "raw", (message) =>
      # loggins.log "<< Flowdock::<raw>"
      # @eventsHandler(message)

  disconnect: -> @io.disconnect()

  whoAmI: ->
    loggins.log "> whoAmiI: "
    payload =
      server: @io.opt.server
      nick: @io.nick
      userName: @io.opt.userName
      realName: @io.opt.realName
      channels: @getChannels()
    @socket.emit "YOUARE", payload

  refresh: -> @getChannels()

  join: (data) ->
    loggins.log "Flowdock::join (data) ->"
    io = @io
    for channel in data.channels
      io.join(channel)

  setNick: (data) ->
    @io.send("NICK", data.nick)

  getChannels: -> return @io.chans

  getNames: (data) ->
    loggins.log "getNames", data
    @io.send("NAMES", data.channel)

  message: (data) ->
    loggins.log "Flowdock::message (data) ->", data
    @io.say(data.channel, data.message)

  eventsHandler: (data) ->
    command = data.command

    # loggins.log "  [RAW] COMMAND: ", command

    switch command
      when "JOIN"
        @socket.emit "JOIN", {nick: data.nick, channels: data.args}
      when "PRIVMSG"
        # loggins.log data
        payload =
          nick: data.nick
          message: data.args.splice(1)[0]
          channel: data.args.shift()
        @socket.emit "MESSAGE", payload
      else
        "poop"

module.exports = Flowdock
