
module.exports = App = Ember.Application.create
  ###*
    Name of the application

    @property name
    @type String
  ###
  name: 'App'


App.Store = DS.Store.extend
  revision: 12
  adapter: DS.FixtureAdapter.extend
    queryFixtures: (fixtures, query, type) ->
      return [] if typeof query isnt "object"
      hit = Object.keys(query).length
      fixtures = fixtures.filter (item) ->
        match = 0
        for key, val of query
          match += 1 if item[key] is val
        if match is hit then true else false
      return fixtures
  socket: io.connect "http://localhost:3002/"

App.ApplicationAdapter = DS.FixtureAdapter.extend()

Ember.View.reopen
  init: ->
    this._super()
    self = this

    # this lets us add data-attributes to handlebars
    Em.keys(this).forEach (key) ->
      if (key.substr(0, 5) == 'data-')
        self.get('attributeBindings').pushObject(key)



# require './socket.coffee'
require './controllers/index.coffee'
require './routes.coffee'
require './routes/index.coffee'
require './models/index.coffee'
require './views/index.coffee'
require './components/index.coffee'

window.App = App
