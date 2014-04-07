console.log "ApplicationRoute"


App = require '../app.coffee'

module.exports = App.ApplicationRoute = Ember.Route.extend
  templateName: "chat"
  setupController: (controller) ->
    socket = controller.get('store.socket')
    console.log "CONTROLLER => ", controller
    @setupEvents(socket)

  setupEvents: (socket) ->
    console.log "setupEvents"
    socket.on "connect", =>
      console.log "SOCKET: CONNECTED"
      @controller.init()

    socket.on "MESSAGE", (data) =>
      console.log "SOCKET: MESSAGE"
      @controller.addMessage(data)


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
      socket = @get "store.socket"
      console.log "CONNECT"
      ircOpts =
        server: "server.minmax.me"
        port: "6667"
        nick: "switchboard-test-client"
        channels: ["#switchboard"]

      socket.emit 'CONNECT', ircOpts

      return this.disconnectOutlet
        outlet: 'modal'
        parentView: 'application'

    disconnect: ->
      socket = @get "store.socket"
      console.log "DISCONNECT"
      socket.emit 'DISCONNECT'

