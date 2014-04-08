console.log "ChatRoute"


App = require '../app.coffee'

module.exports = App.ChatRoute = Ember.Route.extend
  model: (params, queryParams) ->
    messages = this.store.find(App.Message, {location: params.location})
    console.log "messsssssssagggesss", messages
    return messages

  # afterModel: (chats, transition) ->
  #   transition.send "joinChannel", transition.params.location

  setupController: (controller, model) ->
    controller.set('model', model)


  actions: {
    addMessage: (data) ->
      console.log "ChatView.addMessage", data, this.store
      return "shapow!"

    joinChannel: (channel) ->
      socket = @get "store.socket"
      console.log channel
  }

