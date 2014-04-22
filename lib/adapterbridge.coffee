
class AdapterBridge
  listener: null
  clients: []

  constructor: (listener) ->
    console.log "AdapterBridge::constructor (listener) ->", listener
    @listener = listener
    return

  addClient: (client) ->
    console.log "AdapterBridge::addClient (client) ->", client
    client.on "REGISTERED", (data) ->
      console.log "ClientsManager::createClientEvents:<REGISTERED>"
    @clients.push client


module.exports = AdapterBridge
