
console.log "ChatView"

App = require '../app.coffee'

module.exports = App.ChatView = Ember.View.extend
  templateName: 'chat'

  didInsertElement: ->
    console.log "Chat.didInsertElement"
    console.log @get("controller")

    Ember.observer App.Message, ->
      console.log "APPPPPDSFKLJSDFLJDSFLKSJDLFKDSJFLKDSJHFIUIEWHBKEWC(*&"
      App.store.commit()

  submit: (event) ->
    socket = controller.get('store.socket')
    socket.emit "MESSAGE", "hello"

  newMessage: ( ->
    console.log "shapow"
  ).observes('controller.chat')

