console.log "HomeRoute"


App = require '../app.coffee'


module.exports = App.HomeRoute = Ember.Route.extend
  model: ->
    console.log "HomeRoute.model"
    return Em.Object.create({name: 'Mitch'})
