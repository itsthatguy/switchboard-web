
console.log "App.Socket"

App = require './app.coffee'

module.exports = App.Socket = io.connect('http://localhost:3002')
