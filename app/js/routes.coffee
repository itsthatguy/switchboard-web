console.log "Routes"


App = require './app.coffee'

App.Router.map ->
  # put your routes here
  @route('home', { path: '/' })
  # @resource 'pages', ->
    # @resource 'page', { path: '/:name' }

  # @route('server', { path: '/server' })
  @resource "chat", { path: '/chat/:location' }


Ember.Route.reopen
  activate: ->
    cssClass = @toCssClass()
    if (cssClass != 'application')
      Ember.$('body').addClass(cssClass)


  deactivate: ->
    Ember.$('body').removeClass(this.toCssClass())

  toCssClass: ->
    return this.routeName.replace(/\./g, '-').dasherize()
