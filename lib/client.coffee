IRCBridge = require('./ircadapter')


class Client
  socket: null
  adapter: null

  constructor: (socket) ->
    @socket = socket


  connect: (data) ->

    @adapter = new IRCBridge(@socket)
    @adapter.connect(data)

    @socket.on "JOIN", (data) =>
      @adapter.join(data)

    @socket.on "MESSAGE", (data) =>
      @adapter.message(data)

    return

  disconnect: ->
    @adapter.disconnect()







module.exports = Client
