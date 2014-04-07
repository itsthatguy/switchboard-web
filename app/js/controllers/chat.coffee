
console.log "ChatController"

App = require "../app.coffee"

App.ChatController = Ember.ObjectController.extend
  chats: ->
    return App.Server.chats
