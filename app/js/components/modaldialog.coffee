App = require "../app"

module.exports = App.ModalDialogComponent = Ember.Component.extend
  actions:
    close: ->
      return this.sendAction()
