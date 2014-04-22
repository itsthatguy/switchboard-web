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
    console.log "Clients::newClient (socket, id) ->", id
    client = @getClient(id)
    if client.id?
      console.log "CLIENT"
      client.adapter = new IRCAdapter(socket)
    else
      console.log "NO CLIENT", id
      client = {id: id, adapter: new IRCAdapter(socket), socket: socket}
      @clients.push(client)

    @createClientEvents(socket, client)
    return client

  createClientEvents: (socket, client) ->
    socket.on "CONNECT", (data) =>
      # console.log "CONNECT <-", data
      socket.emit("OK")
      client.adapter.connect(data)


    socket.on "DISCONNECT", (data) =>
      # console.log "DISCONNECTING"
      client.adapter.disconnect()


    socket.on "JOIN", (data) =>
      command = [client, "join", data]
      @addQueue(command)

    socket.on "MESSAGE", (data) =>
      command = [client, "message", data]
      @addQueue(command)

  addQueue: (client, fn, data) ->
    console.log "Clients::addQueue", fn, data


  clearQueue: (client) ->
    console.log "Clients::clearQueue"



  getClient: (id) ->
    for client in @clients
      if client.id == id
        console.log "FOUND CLIENT"
      else
        client.id = null
        client.adapter = null
        console.log "UNABLE TO FIND CLIENT"
      return client

  disconnect: ->
    @adapter.disconnect()







module.exports = new Clients()
