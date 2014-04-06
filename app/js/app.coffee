

module.exports = App = Ember.Application.create
  ###*
    Name of the application

    @property name
    @type String
  ###
  name: 'App'

Ember.View.reopen({
  init: ->
    this._super()
    self = this

    # this lets us add data-attributes to handlebars
    Em.keys(this).forEach (key) ->
      if (key.substr(0, 5) == 'data-')
        self.get('attributeBindings').pushObject(key)
})

require './routes.coffee'
require './routes/index.coffee'
require './controllers/index.coffee'
require './views/index.coffee'
require './components/index.coffee'
