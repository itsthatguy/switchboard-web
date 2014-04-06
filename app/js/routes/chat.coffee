console.log "ChatRoute"


App = require '../app.coffee'


module.exports = App.ChatRoute = Ember.Route.extend
  model: (params, queryParams) ->
    console.log "ChatRoute.model"
    return "hi"
