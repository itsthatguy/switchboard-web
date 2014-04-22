
# socketManager = require("./socketmanager")

webserver     = require("./webserver")
io            = require("socket.io")
Clients       = require("./clients")
parseCookie   = require("express").cookieParser()


class Switchboard

  constructor: ->
    socketServer = io.listen(webserver, {log: false})

    socketServer.sockets.on 'connection', (socket) =>

      socket.emit("HELLO")
      console.log "INITIAL CONNECTION"

      socket.on "HANDSHAKE", (data) ->
        client = {id, adapter} = Clients.getClient(data.sid)
        console.log "HANDSHAKE <-"

        # if we don't have a client
        # - create new client in clientManager
        if not client.id? and not client.adapter?
          console.log "if we don't have a client id or adapter"
          client = Clients.newClient(socket, data.sid)

        # if we have a client but no client adapter
        # - create a new client adapter
        else if client.id? and not client.adapter?
          console.log "if we have a client but no client adapter"
          client = Clients.newClient(socket, data.sid)

        # if we have a client and a client adapter
        # - check. cool
        else if client.id? and client.adapter?
          console.log "if we have a client and a client adapter"




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





module.exports = new Switchboard()
