irc = require("irc")
net = require("net")
repl = require("repl")
config = require('config')

connections = 0
users = {}

client = new irc.Client config.server, config.nick,
  channels: ["#{config.channel}"]


client.addListener "message", (from, to, message) ->
  console.log from + " => " + to + ": " + message
  return

client.addListener "names#{config.channel}", (nicks) ->
  for key, value of nicks
    console.log key, value
    users[key] = value
  console.log users

client.addListener "join#{config.channel}", (nick, message) ->
  console.log nick, message
  users[nick] = ''

client.addListener "part#{config.channel}", (nick, message) ->
  console.log nick, message
  delete users[nick]


# REPL
r = repl.start
  prompt: "> "
  input: process.stdin
  output: process.stdout

r.context.say = (msg) ->
  client.say config.channel, msg
  return

r.context.client = client
r.context.users = users
