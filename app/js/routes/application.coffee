console.log "ApplicationRoute"


App = require '../app.coffee'

module.exports = App.ApplicationRoute = Ember.Route.extend

  setupController: (controller) ->
    socket = controller.get('store.socket')
    console.log "CONTROLLER => ", controller, @controller
    @setupSocketEvents(socket, controller)

  setupSocketEvents: (socket, controller) ->
    console.log "setupEvents", this, socket, controller
    socket.on "connect", =>
      console.log "SOCKET: CONNECTED"
      controller.init()

    socket.on "MESSAGE", (data) =>
      c4 = this.controllerFor('chat')
      console.log "SOCKET: MESSAGE", c4
      @send "addMessage", data

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
        nick: "sb-ts-c"
        channels: ["#switchboard"]

      socket.emit 'CONNECT', ircOpts

      return this.disconnectOutlet
        outlet: 'modal'
        parentView: 'application'

    disconnect: ->
      socket = @get "store.socket"
      console.log "DISCONNECT"
      socket.emit 'DISCONNECT'

