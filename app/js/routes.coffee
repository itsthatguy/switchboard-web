console.log "Routes"


App = require './app.coffee'

App.Router.map ->
  # put your routes here
  @resource('home', { path: '/' })
  @resource 'pages', ->
    @resource 'page', { path: '/:name' }

  @route('blog', { path: '/blog' })
  @route('server', { path: '/server' })
  @resource('chat', { path: '/chat/:name' })


Ember.Route.reopen
  activate: ->
    cssClass = @toCssClass()
    if (cssClass != 'application')
      Ember.$('body').addClass(cssClass)


  deactivate: ->
    Ember.$('body').removeClass(this.toCssClass())

  toCssClass: ->
    return this.routeName.replace(/\./g, '-').dasherize()
