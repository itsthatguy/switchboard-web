console.log "ApplicationRoute"


App = require '../app.coffee'


module.exports = App.ApplicationRoute = Ember.Route.extend
  templateName: "chat"
  setupController: ->

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

    connect: ->
      console.log "CONNECT"
      ircOpts =
        server: "irc.freenode.net"
        port: "6667"
        nick: "testviking-client"
        channels: ["#vikinghug"]

      App.Socket.emit 'CONNECT', ircOpts

      return this.disconnectOutlet
        outlet: 'modal'
        parentView: 'application'

    disconnect: ->
      console.log "DISCONNECT"
      App.Socket.emit 'DISCONNECT'


