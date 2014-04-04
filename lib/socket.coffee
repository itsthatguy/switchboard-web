
module.exports = (socket, irc) ->
  socket.on "message", (data) =>
    irc.say(data.message)

  socket.on "getConnectionData", =>
    console.log "getConnectionData"
    socket.emit("setConnectionData", {nick: irc.nick})

