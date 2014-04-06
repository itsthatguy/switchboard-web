
console.log "ChatView"

App = require '../app.coffee'

module.exports = App.ChatView = Ember.View.extend({
  templateName: 'chat'
  didInsertElement: ->
    console.log "Chat.didInsertElement"
})
