
App = require "../app.coffee"

attr = DS.attr

App.Message = DS.Model.extend
  type: attr('string')
  from: attr('string')
  to: attr('string')
  message: attr('string')

