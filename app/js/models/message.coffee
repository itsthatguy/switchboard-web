
App = require "../app.coffee"

module.exports = App.Message = DS.Model.extend
  nick: DS.attr('string')
  message: DS.attr('string')
  location: DS.attr('string')


App.Message.FIXTURES = [
  {id: 1, nick: "itg", message: "first messsage", location: "#switchboard"}
  {id: 2, nick: "Stadl0r", message: "oh hai friend2", location: "#switchboard"}
  {id: 3, nick: "Stadl0r", message: "oh hai friend3", location: "#switchboard"}
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
