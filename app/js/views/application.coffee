console.log "ApplicationView"


App = require '../app.coffee'

module.exports = App.ApplicationView = Ember.View.extend
  templateName: 'application'
  didInsertElement: ->
    console.log "Application.didInsertElement"

