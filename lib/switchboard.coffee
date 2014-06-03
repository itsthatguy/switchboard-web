
# socketManager = require("./socketmanager")

webserver      = require("./webserver")
io             = require("socket.io")
ClientsManager = require("./clientsmanager")
parseCookie    = require("express").cookieParser()


class Switchboard

  constructor: ->
    socketServer = io.listen(webserver, {log: false})
    socketServer.setMaxListeners(12)

    socketServer.sockets.on 'connection', (socket) =>

      socket.emit("HELLO")
      console.log "INITIAL CONNECTION"

      socket.on "HANDSHAKE", (data) ->
        client = {id, adapter} = ClientsManager.getClient(data.sid)
        console.log "HANDSHAKE <-"

        # if we don't have a client
        # - create new client in clientManager
        if not client.id? and not client.adapter?
          console.log "if we don't have a client id or adapter"
          client = ClientsManager.newClient(socket, data.sid, "flowdock")

        # if we have a client but no client adapter
        # - create a new client adapter
        else if client.id? and not client.adapter?
          console.log "if we have a client but no client adapter"
          client = ClientsManager.newClient(socket, data.sid, "flowdock")

        # if we have a client and a client adapter
        # - check. cool
        else if client.id? and client.adapter?
          console.log "if we have a client and a client adapter"
          ClientsManager.setSocket(socket, client)
          ClientsManager.refresh(client)


module.exports = new Switchboard()
