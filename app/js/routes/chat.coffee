console.log "ChatRoute"


App = require '../app.coffee'

module.exports = App.ChatRoute = Ember.Route.extend
  needs: "application"
  model: (params, queryParams) ->
    console.log data = "hello" # App.Server.chats[params.location]
    return data

  setupController: (controller, model) ->
    controller.set('model', model)
