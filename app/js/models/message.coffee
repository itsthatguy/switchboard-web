
App = require "../app.coffee"

module.exports = App.Message = DS.Model.extend
  sentAt: DS.attr('date'),
  nick: DS.attr('string')
  message: DS.attr('string')


App.Message.FIXTURES = []
