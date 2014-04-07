
# socketManager = require("./socketmanager")

webserver     = require("./webserver")
io            = require("socket.io")
Client        = require("./client")


clients = []

class Switchboard


  constructor: ->
    socketServer = io.listen(webserver, {log: false})

    socketServer.sockets.on 'connection', (socket) =>
      socket.emit("HELLO")
      console.log "INITIAL CONNECTION", socket

      client = null
      socket.on "CONNECT", (data) ->
        this.emit("OK")
        client = new Client(socket)
        client.connect(data)


      socket.on "DISCONNECT", (data) ->
        console.log "DISCONNECTING"
        client.disconnect()



module.exports = new Switchboard()
