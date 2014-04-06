
App = require "../app.coffee"

console.log "ModalController"

module.exports = App.ModalController = Ember.ObjectController.extend
  actions:
    close: ->
      return this.send('closeModal')
