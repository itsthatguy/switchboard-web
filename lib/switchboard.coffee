
app     = require("./webserver").app
server  = require("./webserver").server
irc     = require("./irc")
sock    = require("./socket")
io      = require("socket.io")

class Switchboard
  app: app
  server: server
  socket: null
  irc: null

  constructor: ->
    @irc = new irc()
    @app.io = io.listen(server, {log: false})
    @irc.start()

    @app.io.sockets.on 'connection', (socket) =>
      console.log "CONNECT"
      @socket = sock(socket, @irc)
      @irc.setSocket(socket)

module.exports = new Switchboard()
