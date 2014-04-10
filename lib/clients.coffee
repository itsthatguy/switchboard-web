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
      console.log "CLIENT", client
      client.adapter = new IRCAdapter(socket)
    else
      client = {id: id, adapter: new IRCAdapter(@socket), socket: socket}
      @clients.push(client)
    return client.id

  getClient: (id) ->
    for client in @clients
      if client.id == id
        console.log "FOUND CLIENT"
        return client

  connect: (data) ->
    @adapter = new IRCAdapter(@socket)
    @adapter.connect(data)

    @socket.on "JOIN", (data) =>
      @adapter.join(data)

    @socket.on "MESSAGE", (data) =>
      @adapter.message(data)

    return

  disconnect: ->
    @adapter.disconnect()







module.exports = new Clients()
