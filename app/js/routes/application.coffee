console.log "ApplicationRoute"


App = require '../app.coffee'


module.exports = App.ApplicationRoute = Ember.Route.extend
  model: ->
    console.log "ApplicationRoute.model"
    return Em.Object.create({name: 'Mitch'})
  actions:
    openModal: (modalName, model) ->
      @controllerFor(modalName).set('model', model)
      return @render modalName,
        into: 'application'
        outlet: 'modal'

    closeModal: ->
      return this.disconnectOutlet
        outlet: 'modal'
        parentView: 'application'


