require '../../bower_components/ember-data/ember-data.js'

module.exports = App = Ember.Application.create
  ###*
    Name of the application

    @property name
    @type String
  ###
  name: 'App'


App.Store = DS.Store.extend
  revision: 12
  socket: io.connect "http://localhost:3002/"

Ember.View.reopen
  init: ->
    this._super()
    self = this

    # this lets us add data-attributes to handlebars
    Em.keys(this).forEach (key) ->
      if (key.substr(0, 5) == 'data-')
        self.get('attributeBindings').pushObject(key)


App.Server = {
  server: "server.minmax.me"
  port: 6667
  password: null
  chats: [
    {nick: "itsthatguy", message: "oh hai", location: "#switchboard"}
    {nick: "itsthatguy", message: "oh hai friend", location: "#switchboard"}
    {nick: "itsthatguy", message: "oh hai", location: "switchboard-tes"}
  ]
}


# require './socket.coffee'
require './routes.coffee'
require './routes/index.coffee'
require './models/index.coffee'
require './controllers/index.coffee'
require './views/index.coffee'
require './components/index.coffee'

window.App = App