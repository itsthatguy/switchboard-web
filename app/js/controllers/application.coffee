
console.log "ApplicationController"

App = require "../app.coffee"

App.ApplicationController = Ember.ObjectController.extend
  addMessage: (data) ->
    console.log "ApplicationController.addMessage", data

  init: ->
    console.log "INIT", this
