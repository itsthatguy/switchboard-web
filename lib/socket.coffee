
app     = require('./webserver').app
server  = require('./webserver').server
io      = require('socket.io')

app.io = io.listen(server)

app.io.sockets.on 'connection', (socket) ->
  socket.emit('news', { hello: 'world' })
  socket.on 'my other event', (data) ->
    console.log(data)
