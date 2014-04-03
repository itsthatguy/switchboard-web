
module.exports = (socket, irc) ->
  socket.on "message", (data) =>
    console.log data
    irc.say(data.message)
