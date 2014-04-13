should = require("should")
expect = require("chai").expect
io = require('socket.io-client')
Switchboard = require('../lib/switchboard.coffee')

socketURL = 'http://localhost:3002'

ioOpts = {}

client = io.connect(socketURL, ioOpts)

describe "When Switchboard is initialized the client:", ->

  db = {}

  before (done) ->
    client.on "connect", ->
      db.connected = true

    client.on "HELLO", ->
      db.hello = true
      console.log "HELLO <-"
      console.log "HANDSHAKE ->"
      client.emit 'HANDSHAKE', sid: "test"
      this.removeAllListeners()
      done()

  it 'should connect to Switchboard socket server successfully', ->
    db.connected.should.be.true

  it 'should receive a "HELLO" event from the Switchboard socket server', ->
    db.hello.should.be.true


ircOpts =
  server: "irc.freenode.net"
  port: "6667"
  nick: "testviking"
  channels: ["#vikinghug"]



describe "When the client tells Switchboard to connect:", ->

  db = {}

  before (done) ->
    client.emit("CONNECT", ircOpts)

    client.on "OK", ->
      db.ok = true

    client.on "CONNECTED", (data) ->
      db.server = data.server
      db.port = data.port
      db.nick = data.nick


    client.on "JOIN", (data) ->
      db.channels = data.channels
      this.removeAllListeners()
      done()

  it 'should receive an "OK" message from the server', ->
    db.ok.should.be.true

  it "should connect to the #{ircOpts.server} server", ->
    db.server.should.equal ircOpts.server

  it "should use #{ircOpts.port} as the port", ->
    db.port.should.equal ircOpts.port

  it "should know you as #{ircOpts.nick}", ->
    db.nick.should.equal ircOpts.nick

  it "should know you have entered one the following channel(s): #{ircOpts.channels}", ->
    expect(ircOpts.channels)
      .to.include.members db.channels


describe "When another client joins a channel:", ->

  db = {}

  _ircOpts =
    server: "irc.freenode.net"
    port: "6667"
    nick: "alfkj32dsjkhf2b"
    channels: ["#alsdfkj32dsjkhfab"]

  before (done) ->
    client.emit("JOIN", {channels: _ircOpts.channels})

    newClient = io.connect(socketURL, ioOpts)
    newClient.emit("CONNECT", _ircOpts)



    client.on "JOIN", (data) ->
      if data.nick != ircOpts.nick
        db.join = true
        db.channels = data.channels
        db.nick = data.nick
        this.removeAllListeners()
        done()



  it "should receive a join message", ->
    db.join.should.be.true

  it "should be the user #{_ircOpts.nick}", ->
    db.nick.should.equal _ircOpts.nick

  it "should be one of the following channel(s) #{_ircOpts.channels}", ->
    expect(_ircOpts.channels)
      .to.include.members db.channels


