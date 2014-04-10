
# socketManager = require("./socketmanager")

webserver     = require("./webserver")
io            = require("socket.io")
Client        = require("./client")
parseCookie   = require("express").cookieParser()
dirty         = require('dirty');
db            = dirty('db/clients.db')


class Switchboard

  constructor: ->
    socketServer = io.listen(webserver, {log: false})

    socketServer.sockets.on 'connection', (socket) =>
      session = null

      socket.emit("HELLO")
      console.log "INITIAL CONNECTION"

      socket.on "HANDSHAKE", (data) ->
        console.log "HANDSHAKE"
        session = db.get(data.sid)
        session.socket = socket
        session.client ?= new Client(socket)
        this.emit("OK")

      socket.on "CONNECT", (data) ->
        console.log "CONNECT"
        session.client.connect(data)


      socket.on "DISCONNECT", (data) ->
        console.log "DISCONNECTING"
        session.client.disconnect()



module.exports = new Switchboard()
