
App = require "../app.coffee"

# module.exports = App.Chat = DS.Model.extend
#   nick: DS.attr('string')
#   location: DS.attr('string')
#   message: DS.hasMany('App.Message', {async: true})

module.exports = App.ChatsArray = Ember.ArrayProxy.extend

  chats: null

  init: ->
    @chats = Ember.A()

  joinChat: (name) ->
    @chats.pushObject(name)

  partChat: (name) ->
    @chats = chats.without(name)


App.Chat.FIXTURES = [
  {
    id: 1,
    location: "#switchboard"
    messages: [{id: 1, nick: "itg", message: "oh hai1", location: "#switchboard"}]

  }
  {
    id: 2,
    location: "itg"
    messages: [
      {id: 2, nick: "Stadl0r", message: "oh hai friend2", location: "#vikinghug"}
      {id: 3, nick: "Stadl0r", message: "oh hai friend3", location: "#vikinghug"}
      {id: 4, nick: "Stadl0r", message: "oh hai friend4", location: "#vikinghug"}
      {id: 5, nick: "Stadl0r", message: "oh hai friend5", location: "#vikinghug"}
      {id: 6, nick: "Stadl0r", message: "oh hai friend6", location: "#vikinghug"}
      {id: 7, nick: "Stadl0r", message: "oh hai friend7", location: "#vikinghug"}
      {id: 8, nick: "Stadl0r", message: "oh hai friend8", location: "#vikinghug"}
      {id: 9, nick: "Stadl0r", message: "oh hai friend9", location: "#vikinghug"}
      {id: 10, nick: "Stadl0r", message: "oh hai friend10", location: "#vikinghug"}
      {id: 11, nick: "Stadl0r", message: "oh hai friend11", location: "#vikinghug"}
      {id: 12, nick: "Stadl0r", message: "oh hai friend12", location: "#vikinghug"}
      {id: 13, nick: "Stadl0r", message: "oh hai friend13", location: "#vikinghug"}
    ]
  }
]
