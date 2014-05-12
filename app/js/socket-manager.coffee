App = require("./app.coffee")
Cookies = require("../../bower_components/cookies-js/src/cookies.js")

class SocketManager

  Socket: null

  constructor: (data) ->
    @Socket = io.connect "http://" + window.location.host
    @Socket.emit 'HANDSHAKE', sid: Cookies.get("sid")
    @createListeners()
    @Socket.emit("WHOAMI")


  createListeners: ->
    @Socket.on "MESSAGE", (data) ->
      console.log "MESSAGE: ", data
      App.chats.addMessage(data, "message")

    @Socket.on "NICK", (data) ->
      console.log "NICK: ", data

      oldnick = data.oldnick
      newnick = data.newnick
      channels = data.channels

      if oldnick == App.serverData.nick
        oldnick = "You are"
        App.serverData.set("nick", newnick)
        App.serverData.set("avatarURL", "http://adorable-avatars.herokuapp.com/avatar/#{newnick}")
      else
        oldnick = "#{oldnick} is"
      data.message = "#{oldnick} now known as #{newnick}"

      for channel in channels
        data.channel = channel
        App.chats.addMessage(data, "nick")

    @Socket.on "JOIN", (data) ->
      console.log "JOIN: ", data
      data.message = "#{data.nick} has joined the channel."
      App.chats.addMessage(data, "join")

    @Socket.on "PART", (data) ->
      console.log "PART: ", data
      data.message = "#{data.nick} has left the channel."
      App.chats.addMessage(data, "part")

    @Socket.on "NAMES", (data) ->
      payload =
        channel: data.channel
        members: []
      for nick, attributes of data.nicks
        payload.members.push {nick: nick, attributes: attributes}
      console.log "payload", payload
      App.chats.addMembers(payload)

    @Socket.on "YOUARE", (data) ->
      console.log "YOUARE: ", {channels: data.channels}
      App.serverData.set("nick", data.nick)
      App.serverData.set("avatarURL", "http://adorable-avatars.herokuapp.com/avatar/#{data.nick}")
      App.chats.joinChats({channels: data.channels})
      App.chats.addMessage(message: JSON.stringify(data), "system")


  connect: (data) -> @Socket.emit "CONNECT", data

  disconnect: -> console.log "SocketManager::disconnect()"

module.exports = new SocketManager()
