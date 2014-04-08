console.log "ChatRoute"


App = require '../app.coffee'

module.exports = App.ChatRoute = Ember.Route.extend
  model: (params, queryParams) ->
    return this.store.findAll(App.Chat)

  # afterModel: (chats, transition) ->
  #   transition.send "joinChannel", transition.params.location

  setupController: (controller, model) ->
    controller.set('model', model)


  actions: {
    addMessage: (data) ->
      console.log "ChatView.addMessage", data, this.store
      this.store.push('chat', data)
      return "shapow!"

    joinChannel: (channel) ->
      socket = @get "store.socket"
      console.log channel
  }

