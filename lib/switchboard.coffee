
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

      socket.on "CONNECT", (data) ->
        this.emit("OK")
        client = new Client(socket)
        client.connect(data.server, data.port, data.nick, data.channels)



module.exports = new Switchboard()
