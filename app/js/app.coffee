Cookies = require "../../bower_components/cookies-js/src/cookies.js"
moment  = require("../../bower_components/momentjs/moment.js")


module.exports = window.App = Ember.Application.create()

App.Socket = io.connect "http://localhost:3002/"
App.Socket.emit 'HANDSHAKE', sid: Cookies.get("sid")
data =
  server: "irc.freenode.net"
  port: "6667"
  nick: "testviking"
  channels: ["#vikinghug"]
App.Socket.emit "CONNECT", data

App.Socket.on "MESSAGE", (data) ->
  console.log "MESSAGE: ", data
  App.chats.addMessage(data)

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
    chat.set("notifications", null)
    return chat


  addChat: (data) ->
    data.notifications = null
    chat = App.MessagesArray.create(data)
    @chats.pushObject(chat)
    return chat


  addMessage: (data) ->
    console.log data
    chat = App.chats.findBy("name", data.location)
    time = moment().format('h:mm:ss a')
    chat.set("notifications", chat.notifications + 1)
    chat.pushObject(nick: data.nick, message: data.message, time: time)





App.MessagesArray = Ember.ArrayProxy.extend
  init: (data) ->
    console.log "App.MessagesArray::init", this.name
    messages = Ember.A()
    @set("content", messages)

    @_super()


# TopBar model
App.topbar =
  server: data.server


App.chats = App.ChatsArray.create()


# ChatController
App.ChatController = Ember.ArrayController.extend
  needs: "application"
  msg: ""
  actions:
    sendMessage: ->
      console.log "ACTIVE", this
      data =
        location: this.content.name
        nick: data.nick
        message: this.get("msg")

      App.chats.addMessage(data)

      App.Socket.emit("MESSAGE", data)
      @set("msg", "")

# ChatRoute
App.ChatRoute = Ember.Route.extend
  model: (params, queryParams) ->
    messages = App.chats.joinChat({name: params.name})
    App.Socket.emit("JOIN", {channels: [params.name]});
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
  tagName: 'div'
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
  tagName: 'div'
  templateName: "chat-tab"
  classNames: ['tab', 'current']
  current: false
  active: ->
    console.log "bloop"



Routes = require './routes.coffee'
