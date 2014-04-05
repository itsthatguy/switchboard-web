IRC     = require("irc")
net     = require("net")

class IRCBridge
  irc: null
  debug: false

  constructor: (server, port, nick, channels) ->
    console.log("IRCBridge") unless @debug?
    @irc = new IRC.Client server, nick,
      showErrors: @debug
      debug: @debug
      port: port
      channels: channels


module.exports = IRCBridge
