
console.log "ChatView"

App = require '../app.coffee'

module.exports = App.ChatView = Ember.View.extend
  templateName: 'chat'

  didInsertElement: ->
    console.log "Chat.didInsertElement"
    console.log @get("controller")

  newMessage: ( ->
    console.log "shapow"
  ).observes('controller.chat')

