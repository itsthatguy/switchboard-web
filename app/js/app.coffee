
module.exports = window.App = Ember.Application.create()

App.serverData =
  server: "irc.freenode.net"
  port: "6667"
  nick: "testviking"
  channels: ["#vikinghug"]

moment  = require("../../bower_components/momentjs/moment.js")
App.io = require("./socket-manager.coffee")

App.io.connect(App.serverData)

App.ApplicationRoute = Ember.Route.extend
  actions:
    openSidebar: (name) ->
      console.log "YES!"
      App.chats.getNames(App.currentModel.name)
      @render "sidebar-members",
        into: 'chat'
        outlet: "sidebar-members"
        controller: App.currentModel


App.setNick = (nick) ->
  App.serverData.nick = nick

App.getNick = (nick) ->
  return App.serverData.nick

App.ChatsArray = Ember.ArrayProxy.extend
  init: ->
    @chats = Ember.A()
    @set("content", @chats)

    @_super()

  getNames: (channel) ->
    App.io.Socket.emit("NAMES", {channel: channel})

  addMembers: (data) ->
    console.log "addMembers", data
    chat = App.chats.findBy("name", data.channel)
    console.log "addMembers:chat", chat
    chat.set("members", data.members)

  # created this to avoid overwriting find, until i understand this better
  joinChat: (data) ->
    chat = App.chats.findBy("name", data.name)
    unless chat?
      chat = App.chats.addChat(data)
    chat.set("notifications", null)
    App.currentModel = chat
    @getNames(data.name)
    return chat


  addChat: (data) ->
    data.notifications = null
    chat = App.MessagesArray.create(data)
    @chats.pushObject(chat)
    return chat


  addMessage: (data, type) ->
    console.log data
    channel = data.channel or App.currentModel.name
    chat = App.chats.findBy("name", channel)
    chat.set("notifications", chat.notifications + 1) unless chat == App.currentModel

    payload =
      nick      : data.nick
      message   : data.message
      time      : moment().format('h:mm:ss a')
      isNick    : (type == "nick")
      isMessage : (type == "message")
      isSystem  : (type == "system")

    chat.pushObject(payload)


App.chats = App.ChatsArray.create()


App.MessagesArray = Ember.ArrayProxy.extend
  init: (data) ->
    console.log "App.MessagesArray::init", this.name
    messages = Ember.A()
    members = Ember.A()
    @set("content", messages)
    @set("members", members)

    @_super()


# TopBar model
App.topbar =
  server: App.serverData.server

# ChatController
App.ChatController = Ember.ArrayController.extend
  needs: "application"
  msg: ""
  actions:
    sendMessage: ->
      console.log "ACTIVE", this, App.serverData
      data =
        channel: this.content.name
        nick: App.getNick()
        message: this.get("msg")

      if (/^\//g.test(data.message))
        @commandHandler(data)
      else
        App.chats.addMessage(data, "message")
        App.io.Socket.emit("MESSAGE", data)

      @set("msg", "")

  commandHandler: (data) ->
    console.log "commandHandler", data
    commandTests =
      "nickCommand": /^\/nick/g
      "joinCommand": /^\/join/g
      "whoCommand": /^\/who/g

    for command, regexp of commandTests
      if (regexp.test(data.message))
        params = data.message.match(/^(?:\w*\/\S+)\s(.*)/)?[1]
        return @[command](params)

    command = data.message.match(/^(\/\S*)\s*/g)[0]
    data.message = "Sorry, <strong>#{command}</strong> is not a command that I understand."
    data.name = App.chats.content[0].name
    App.chats.addMessage(data, "system")
    console.log data.message


  nickCommand: (params) ->
    console.log "nickCommand", params
    App.io.Socket.emit("SETNICK", {nick: params})

  joinCommand: (params) ->
    console.log "joinCommand", params
    @transitionToRoute("chat", params)

  whoCommand: ->
    console.log "whoCommand"
    App.io.Socket.emit("WHOAMI")



# ChatRoute
App.ChatRoute = Ember.Route.extend
  model: (params, queryParams) ->
    messages = App.chats.joinChat({name: params.name})
    App.io.Socket.emit("JOIN", {channels: [params.name]});
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
      @transitionToRoute("chat", name)
      @set("msg", "")

App.ChatTabView = Ember.View.extend
  tagName: 'div'
  templateName: "chat-tab"
  classNames: ['tab', 'current']
  current: false

App.SidebarComponent = Ember.Component.extend

App.SidebarButtonView = Ember.View.extend Ember.ViewTargetActionSupport,
  action: "openSidebar"
  mouseEnter: (e) ->
    console.log "SidebarButtonView:hello"
    @triggerAction()

App.SidebarMembersView = Ember.View.extend
  members: -> return App.currentModel.members
  mouseEnter: (e) -> console.log "SidebarMembersView:hello"

Routes = require './routes.coffee'
