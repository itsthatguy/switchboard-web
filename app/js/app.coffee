
module.exports = window.App = Ember.Application.create()

App.Router.map ->
  @resource "chat", { path: "/chat/:name" }

App.ChatsArray = Ember.ArrayProxy.extend
  init: ->
    @chats = Ember.A()
    @set("content", @chats)

    @_super()


  # created this to avoid overwriting find, until i understand this better
  joinChat: (data) ->
    chat = App.chats.findBy("name", data.name)
    unless chat?
      chat = App.chats.addChat(data)
    return chat


  addChat: (data) ->
    chat = App.MessagesArray.create(data)
    @chats.pushObject(chat)
    return chat


  addMessage: (data) ->
    console.log "yep"



App.MessagesArray = Ember.ArrayProxy.extend
  init: (data) ->
    console.log "App.MessagesArray::init", this.name
    messages = Ember.A()
    @set("content", messages)

    @_super()


App.chats = App.ChatsArray.create()


# ChatController
App.ChatController = Ember.ArrayController.extend
  needs: "application"
  msg: ""
  actions:
    sendMessage: ->
      console.log "ACTIVE", this
      @pushObject(this.get("msg"))
      @set("msg", "")

# ChatRoute
App.ChatRoute = Ember.Route.extend
  model: (params, queryParams) ->
    messages = App.chats.joinChat({name: params.name})
    return messages
  render: ->
    $("#new-message").focus()
    @_super()


# ScrollingDivComponent
App.ScrollingDivComponent = Ember.Component.extend
  scheduleScrollIntoView: (->
    Ember.run.scheduleOnce("afterRender", this, "scrollIntoView")
  ).observes("update-when.@each")

  scrollIntoView: ->
    this.$().scrollTop(this.$().prop("scrollHeight"))

App.ChatsTabsController = Ember.ArrayController.extend
  itemController: App.chats
  init: ->
    @set "content", App.ChatsArray.content
    ["hi", "no"]


# ChatTabsView
App.ChatTabsView = Ember.View.extend
  tagName: 'ul'
  classNames: ["chat-tabs-wrapper"]
  controller: App.chats
  templateName: "chat-tabs"


App.ChatTabsController = Ember.ArrayController.extend
  actions:
    joinChannel: ->
      reg = /^(#)/
      name = this.get("msg")
      unless reg.test(name) then name = "##{name}"
      App.chats.joinChat({name: name})
      @set("msg", "")

App.ChatTabView = Ember.View.extend
  tagName: 'li'
  templateName: "chat-tab"
  classNames: ['active']
  active: ->
    console.log "bloop"




# module.exports = App = Ember.Application.create
#   ###*
#     Name of the application

#     @property name
#     @type String
#   ###
#   name: 'App'


# App.Store = DS.Store.extend
#   revision: 12
#   adapter: DS.FixtureAdapter.extend
#     queryFixtures: (fixtures, query, type) ->
#       return [] if typeof query isnt "object"
#       hit = Object.keys(query).length
#       fixtures = fixtures.filter (item) ->
#         match = 0
#         for key, val of query
#           match += 1 if item[key] is val
#         if match is hit then true else false
#       return fixtures
#   socket: io.connect "http://localhost:3002/"

# App.ApplicationAdapter = DS.FixtureAdapter.extend()

# Ember.View.reopen
#   init: ->
#     this._super()
#     self = this

#     # this lets us add data-attributes to handlebars
#     Em.keys(this).forEach (key) ->
#       if (key.substr(0, 5) == 'data-')
#         self.get('attributeBindings').pushObject(key)



# # require './socket.coffee'
# require './controllers/index.coffee'
# require './routes.coffee'
# require './routes/index.coffee'
# require './models/index.coffee'
# require './views/index.coffee'
# require './components/index.coffee'

# window.App = App
