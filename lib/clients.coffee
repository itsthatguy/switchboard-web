IRCAdapter = require('./ircadapter')


class Clients
  adapter: null
  clients: [
    { id: "test", adapter: undefined }
    { id: 2309487, adapter: undefined }
    { id: 123456, adapter: undefined }
  ]

  constructor: -> return

  newClient: (socket, id) ->
    client = @getClient(id)
    if client?
      # console.log "CLIENT"
      client.adapter = new IRCAdapter(socket)
    else
      client = {id: id, adapter: new IRCAdapter(socket), socket: socket}
      @clients.push(client)

    @createClientEvents(socket, client)
    return client.id

  createClientEvents: (socket, client) ->
    socket.on "CONNECT", (data) =>
      # console.log "CONNECT <-", data
      socket.emit("OK")
      client.adapter.connect(data)


    socket.on "DISCONNECT", (data) =>
      # console.log "DISCONNECTING"
      client.adapter.disconnect()


    socket.on "JOIN", (data) =>
      client.adapter.join(data)

    socket.on "MESSAGE", (data) =>
      client.adapter.message(data)

  getClient: (id) ->
    for client in @clients
      if client.id == id
        # console.log "FOUND CLIENT"
        return client

  disconnect: ->
    @adapter.disconnect()







module.exports = new Clients()
