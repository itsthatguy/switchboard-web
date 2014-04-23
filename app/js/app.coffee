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
  App.chats.addMessage(data, "message")

App.Socket.on "NICK", (_data) ->
  console.log "NICK: ", _data

  oldnick = _data.oldnick
  newnick = _data.newnick
  channels = _data.channels

  console.log data.nick, oldnick
  if oldnick == data.nick
    oldnick = "You are"
    data.nick = newnick
  else
    oldnick = "#{oldnick} is"
  _data.message = "#{oldnick} now known as #{newnick}"

  for channel in channels
    _data.channel = channel
    console.log _data
    App.chats.addMessage(_data, "nick")

App.ChatsArray = Ember.ArrayProxy.extend
  init: ->
    @chats = Ember.A()
    @currentChat = null
    @set("content", @chats)

    @_super()


  # created this to avoid overwriting find, until i understand this better
  joinChat: (data) ->
    chat = App.chats.findBy("name", data.name)
    unless chat?
      chat = App.chats.addChat(data)
    chat.set("notifications", null)
    @currentChat = chat
    return chat


  addChat: (data) ->
    data.notifications = null
    chat = App.MessagesArray.create(data)
    @chats.pushObject(chat)
    return chat


  addMessage: (data, type) ->
    console.log data
    chat = App.chats.findBy("name", data.channel)
    chat.set("notifications", chat.notifications + 1) unless chat == @currentChat

    payload =
      nick      : data.nick
      message   : data.message
      time      : moment().format('h:mm:ss a')
      isNick    : (type == "nick")
      isMessage : (type == "message")
      isSystem  : (type == "system")

    chat.pushObject(payload)





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
        channel: this.content.name
        nick: data.nick
        message: this.get("msg")

      if (/^\//g.test(data.message))
        @commandHandler(data)
      else
        App.chats.addMessage(data, "message")
        App.Socket.emit("MESSAGE", data)

      @set("msg", "")

  commandHandler: (data) ->
    console.log "commandHandler", data
    commandTests =
      "nickCommand": /^\/nick/g
      "joinCommand": /^\/join/g

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
    App.Socket.emit("SETNICK", {nick: params})

  joinCommand: (params) ->
    console.log "joinCommand", params
    @transitionToRoute("chat", params)



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
      @transitionToRoute("chat", name)
      @set("msg", "")

App.ChatTabView = Ember.View.extend
  tagName: 'div'
  templateName: "chat-tab"
  classNames: ['tab', 'current']
  current: false
  active: ->
    console.log "bloop"



Routes = require './routes.coffee'
