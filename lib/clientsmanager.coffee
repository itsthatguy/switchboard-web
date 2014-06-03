
IRCAdapter      = require('./adapters/ircadapter')
FlowdockAdapter = require('./adapters/flowdockadapter')


class ClientsManager
  adapter: null
  clients: [
    { id: "test", adapter: undefined }
    { id: 2309487, adapter: undefined }
    { id: 123456, adapter: undefined }
  ]

  constructor: -> return

  setSocket: (socket, client) ->
    oldSocket = client.adapter.socket
    @removeClientEvents(oldSocket)
    client.adapter.setSocket(socket)
    @createClientEvents(socket, client)


  refresh: (client) ->
    client.adapter.refresh()

  getAdapter: (adapterType) ->
    switch adapterType
      when "irc"
        console.log "IRC"
      when "flowdock"
        console.log "flowdock"
      else console.log "nothing found"

    return FlowdockAdapter


  newClient: (socket, id, adapterType) ->
    console.log "ClientsManager::newClient (socket, id) ->", id

    Adapter = @getAdapter(adapterType)

    client = @getClient(id)
    if client.id?
      console.log "CLIENT"
      client.adapter = new Adapter(socket, id)
    else
      console.log "NO CLIENT", id
      client = {id: id, adapter: new Adapter(socket, id)}
      @clients.push(client)

    @createClientEvents(socket, client)
    client.queue = []
    return client

  getClient: (id) ->
    console.log "ClientsManager::getClient (id) ->", @clients
    foundClient = { id: null, adapter: null }
    for client in @clients
      console.log "@clients => client", id, client.id
      if client.id == id
        console.log "FOUND CLIENT"
        foundClient = client
      else
        console.log "UNABLE TO FIND CLIENT"
    return foundClient

  removeClientEvents: (socket) ->
    socket.removeAllListeners()


  createClientEvents: (socket, client) ->
    console.log "ClientsManager::createClientEvents (socket, client) ->"

    socket.on "CONNECT", (data) =>
      console.log "CONNECT <-", client.adapter.isConnected
      socket.emit("OK")
      if client.adapter.isConnected is false
        client.adapter.connect(data)

    client.adapter.on "REGISTERED", =>
      console.log "> REGISTERED"
      @clearQ(client)

    socket.on "DISCONNECT", (data) =>  client.adapter.disconnect()

    socket.on "WHOAMI", => @Q(client, "whoAmI")

    socket.on "JOIN", (data) => @Q(client, "join", data)

    socket.on "MESSAGE", (data) => @Q(client, "message", data)

    socket.on "SETNICK", (data) => @Q(client, "setNick", data)

    socket.on "NAMES", (data) => @Q(client, "getNames", data)

  Q: (client, fn, data) ->
    console.log "ClientsManager::Q", client.id
    if client.adapter.isConnected is false
      client["queue"].push({fn: fn, data: data})
    else
      client.adapter[fn](data)



  clearQ: (client) ->
    console.log "ClientsManager::clearQ"
    for item, n in client["queue"]
      console.log ">> ", item, n
      if item?
        client.adapter[item.fn](item.data)
        delete client["queue"][n]


  disconnect: ->
    @adapter.disconnect()


module.exports = new ClientsManager()
