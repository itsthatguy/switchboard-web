
IRCAdapter      = require('./adapters/ircadapter')
FlowdockAdapter = require('./adapters/flowdockadapter')
calmsoul        = require('calmsoul')

class ClientsManager
  adapter: null
  clients: [
    { id: "test", adapter: undefined }
    { id: 2309487, adapter: undefined }
    { id: 123456, adapter: undefined }
  ]

  constructor: ->
    calmsoul.info "\n\n@@ClientsManager::constructor ->"
    return

  setSocket: (socket, client) ->
    calmsoul.info "\nClientsManager::setSocket (socket, client) ->"
    oldSocket = client.adapter.socket
    @removeClientEvents(oldSocket)
    client.adapter.setSocket(socket)
    @createClientEvents(socket, client)


  refresh: (client) ->
    client.adapter.refresh()

  getAdapter: (adapterType) ->
    calmsoul.info "\nClientsManager::getAdapter (adapterType) ->"
    switch adapterType
      when "irc"
         calmsoul.info " = IRC"
      when "flowdock"
        calmsoul.info " = Flowdock"
      else calmsoul.info " ! nothing found"

    return FlowdockAdapter


  newClient: (socket, id, adapterType) ->
    calmsoul.info "\nClientsManager::newClient (socket, id) ->"
    calmsoul.debug id

    Adapter = @getAdapter(adapterType)

    client = @getClient(id)
    if client.id?
      calmsoul.info " - CLIENT"
      client.adapter = new Adapter(socket, id)
    else
      calmsoul.info " - NO CLIENT"
      calmsoul.debug id
      client = {id: id, adapter: new Adapter(socket, id)}
      @clients.push(client)

    @createClientEvents(socket, client)
    client.queue = []
    return client

  getClient: (id) ->
    calmsoul.info "\nClientsManager::getClient (id) ->"
    calmsoul.debug @clients
    foundClient = { id: null, adapter: null }
    for client in @clients
      calmsoul.info " - @clients => client"
      calmsoul.debug id, client.id
      if client.id == id
        calmsoul.info " - FOUND CLIENT"
        foundClient = client
      else
        calmsoul.info " - UNABLE TO FIND CLIENT"
    return foundClient

  removeClientEvents: (socket) ->
    calmsoul.info "\nClientsManager::removeClientEvents (socket) ->"
    socket.removeAllListeners()


  createClientEvents: (socket, client) ->
    calmsoul.info "\nClientsManager::createClientEvents (socket, client) ->"

    socket.on "CONNECT", (data) =>
      calmsoul.info " << CONNECT"
      calmsoul.debug client.adapter.isConnected
      socket.emit("OK")
      if client.adapter.isConnected is false
        client.adapter.connect(data)

    client.adapter.on "REGISTERED", =>
      calmsoul.info " >> REGISTERED"
      @clearQ(client)

    socket.on "DISCONNECT", (data) =>  client.adapter.disconnect()

    socket.on "WHOAMI", => @Q(client, "whoAmI")

    socket.on "JOIN", (data) => @Q(client, "join", data)

    socket.on "MESSAGE", (data) => @Q(client, "message", data)

    socket.on "SETNICK", (data) => @Q(client, "setNick", data)

    socket.on "NAMES", (data) => @Q(client, "getNames", data)

  Q: (client, fn, data) ->
    calmsoul.info "\nClientsManager::Q (client, fn, data) ->"
    calmsoul.debug client.id
    if client.adapter.isConnected is false
      client["queue"].push({fn: fn, data: data})
    else
      client.adapter[fn](data)



  clearQ: (client) ->
    calmsoul.info "\nClientsManager::clearQ (client) ->"
    for item, n in client["queue"]
      calmsoul.info ">> "
      calmsoul.debug item, n
      if item?
        client.adapter[item.fn](item.data)
        delete client["queue"][n]


  disconnect: ->
    calmsoul.info "\nClientsManager::disconnect ->"
    @adapter.disconnect()


module.exports = new ClientsManager()
