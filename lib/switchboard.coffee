# socketManager = require("./socketmanager")

webserver      = require("./webserver")
io             = require("socket.io")
ClientsManager = require("./clientsmanager")
parseCookie    = require("cookie-parser")

switchboard = (options = {}) ->
  server = webserver(options)
  socketServer = io.listen(server, {log: false})
  socketServer.setMaxListeners(12)

  socketServer.sockets.on 'connection', (socket) =>
    calmsoul.info " >> <HELLO> "
    socket.emit("HELLO")

    calmsoul.info " << <connection> "

    socket.on "HANDSHAKE", (data) ->
      client = {id, adapter} = ClientsManager.getClient(data.sid)
      calmsoul.info " << HANDSHAKE"

      # if we don't have a client
      # - create new client in clientManager
      if not client.id? and not client.adapter?
        calmsoul.info " - NO client.id? & NO client.adapter?"
        client = ClientsManager.newClient(socket, data.sid, "flowdock")

      # if we have a client but no client adapter
      # - create a new client adapter
      else if client.id? and not client.adapter?
        calmsoul.info " - YES client.id? & NO client.adapter?"
        client = ClientsManager.newClient(socket, data.sid, "flowdock")

      # if we have a client and a client adapter
      # - check. cool
      else if client.id? and client.adapter?
        calmsoul.info " - YES client.id & YES client.adapter?"
        ClientsManager.setSocket(socket, client)
        ClientsManager.refresh(client)

module.exports = switchboard
