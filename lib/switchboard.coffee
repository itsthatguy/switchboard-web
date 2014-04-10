
# socketManager = require("./socketmanager")

webserver     = require("./webserver")
io            = require("socket.io")
Clients       = require("./clients")
parseCookie   = require("express").cookieParser()
# Datastore     = require('nedb')



# db = new Datastore({filename: 'db/switchboard.db', autoload: true})


sessions = []
session =
  socket: undefined
  client: undefined

class Switchboard

  constructor: ->
    socketServer = io.listen(webserver, {log: false})

    socketServer.sockets.on 'connection', (socket) =>

      socket.emit("HELLO")
      console.log "INITIAL CONNECTION"

      socket.on "HANDSHAKE", (data) ->
        client = {id, adapter} = Clients.getClient(data.sid)
        console.log "HANDSHAKE <-"
        unless client.adapter?
          console.log "unless client.adapter?"
          Clients.newClient(socket, data.sid)



        # handleData = (err, doc) ->
        #   unless doc?
        #     console.log "NO RECORDS"
        #     session =
        #       sid: data.sid
        #       clientID: Clients.newClient(socket, data.sid)
        #     console.log "clientID", session
        #     db.insert(session, (err, newDoc) ->
        #       console.log "WTF", err, newDoc
        #     )

        #   else
        #     console.log "FOUND RECORDS", Clients.getClientID(data.sid)
        #     session =
        #       socket: socket
        #       clientID:  || Clients.newClient(socket, data.sid)
        #     console.log data.sid
        #     db.update({sid: data.sid}, {$set: session}, {upsert: true}, (err) ->
        #       db.findOne({sid: data.sid}, (err, doc) -> console.log "HANDSHAKE <-", data.sid)
        #       createConnectionEvents()
        #     )

        # # NEED THIS
        # db.findOne({sid: data.sid}, handleData)


      createConnectionEvents = ->
        socket.emit("OK")

        socket.on "CONNECT", (data) ->
          console.log "CONNECT"
          session.client.connect(data)


        socket.on "DISCONNECT", (data) ->
          console.log "DISCONNECTING"
          session.client.disconnect()



module.exports = new Switchboard()
