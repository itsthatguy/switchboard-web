events = require("./events.coffee")
moment = require("../../bower_components/momentjs/moment.js")

EventHandler = null

# EH = {
#   clearState: ->
#   sendMessage: (msg) -> console.log "EventHandler::sendMessage: -> msg: #{msg}"
#   sendState: (sid, state) -> console.log "EventHandler::sendState: -> sid: #{sid}, state: #{state}"
# }


class Main

  logging: true

  colors: [
    "yellow",
    "red",
    "ruby",
    "green",
    "cyan",
    "teal",
    "blue",
    "orange",
    "purple",
    "lime",
    "brown"]

  $input: $("#input")

  $templates: []

  userColor: {}
  scrollTolerance: 15

  user: {
    nick: "{{FAKEDATA}}"
  }

  constructor: ->
    EventHandler = new events(this)
    @$templates["message"] = $('#chat').find("[data-template='message']").remove()
    @$templates["join"] = $('#chat').find("[data-template='join']").remove()
    @$templates["nick"] = $('#chat').find("[data-template='nick']").remove()
    @shuffleArray()
    @setupEvents()
    @$input.focus()

  setUser: (user) ->
    console.log user
    @user = user

  setNick: (data) ->
    @user.nick = data.newnick
    @addNick(data)

  addUsers: (users) ->
    for user in users
      @addUser(user)

  addUser: (user) ->
    sid = user["sid"]
    @log "addUser", sid
    if ($(".avatar[data-sid='#{sid}']").length<1)
      @setColor(sid)
      $el = @avatarTemplate.clone()
      $el.css("margin-left": "20px", "margin-right": "-20px")
      $el.animate("margin-left": 0, "margin-right": 0)
      $el.appendTo($('.avatars'))
      $el.attr("data-sid", sid)
      img = if !!user["image"] then user["image"] else './.generated/img/vikinghug-avatar.png'
      $el.find('img').attr("src", img)
      $el.find('.name').text(user["nick"])
      $el.find('.circle').attr('data-color', @userColor[sid])

  removeUsers: (users) ->
    for user in users
      @removeUser(user)

  removeUser: (user) ->
    sid = user["sid"]
    if ($(".avatar[data-sid='#{sid}']").length>0)
      $(".avatar[data-sid='#{sid}']").remove()
      delete @userColor[sid]

  focusInput: -> setTimeout ( => @$input.focus() ), 0

  setupEvents: ->
    _self = @
    $(window).on 'keydown', (e) =>
      code = e.keyCode || e.which
      if (code == 9)
        @focusInput()
        e.preventDefault()

    $("#modal button").on "click", (e) ->
      $("#modal").removeClass('open')

    @$input.on 'focus', (e) =>
      $('.input-wrapper').addClass('focus')

    @$input.on 'blur', (e) =>
      $('.input-wrapper').removeClass('focus')


    @$input.on "keyup", (e) =>
      if (e.keyCode == 13 && !e.shiftKey)
        $("form").submit()

    $('a.button, button').on 'click', (e) => @focusInput()


    _self = @
    $("form").submit (e) =>
      e.preventDefault()
      if (@$input.val().length > 0)
        from = @user.nick
        message = @$input.val()
        if (message == "/reset")
          EventHandler.clearState()
        else if (/^\/nick/g.test(message))
          message = message.replace(/^\/nick\s*/g, "")
          EventHandler.setNick(message)
        else
          _self.addMessage
            from: "#{from}"
            message: message
          EventHandler.sendMessage(message)
        @$input.val('')
      return false

  getTime: ->
    return moment().format('h:mm:ss a')

  addPart: (data) ->
    @log "addPart", data
    message = "#{data.nick} has left #{data.channel}"
    @addChannelMessage(message)

  addJoin: (data) ->
    @log "addJoin", data
    message = "#{data.nick} has joined #{data.channel}"
    @addChannelMessage(message)

  addChannelMessage: (message) ->
    $el = @$templates["join"].clone()
    currentTime = @getTime()
    $el.find('.time').html(currentTime)
    $el.find('.message').html(message)
    $("#chat-messages").append($el)
    $('#messages li:first').remove() if $('#messages').find('li').length > 20
    @handleScroll()


  addNick: (data) ->
    @log "addNick", data

    $el = @$templates["nick"].clone()
    currentTime = @getTime()
    $el.find('.time').html(currentTime)
    $el.find('.message').html("#{data.oldnick} is now known as #{data.newnick}")
    $("#chat-messages").append($el)
    $('#messages li:first').remove() if $('#messages').find('li').length > 20
    @handleScroll()

  addMessage: (data) ->
    @log "addMessage", data
    message = @parseMessage(data.message)
    from = data.from

    $el = @$templates["message"].clone()
    currentTime = @getTime()
    $el.find('.time').html(currentTime)
    $el.find('.nickname').html(from)
    $el.find('.message').html(message)
    $("#chat-messages").append($el)
    $('#messages li:first').remove() if $('#messages').find('li').length > 20
    @handleScroll()

  setColor: (sid) -> @userColor[sid] = @getColor()

  getColor: ->
    color = @colors.shift()
    @colors.push(color)
    return color

  shuffleArray: -> @colors = @colors.sort -> 0.5 - Math.random()

  handleScroll: ->
    @log "handleScroll ->", $('#chat-messages').outerHeight()
    scrollTo = $('#chat').scrollTop() + $('#chat-messages > li:last').outerHeight()
    scrollCurrent = $('#chat-messages').outerHeight() - $('#chat').outerHeight()
    if scrollTo >= scrollCurrent - @scrollTolerance
      $('#chat').animate({ scrollTop: $('#chat-messages').outerHeight() })

  parseMessage: (text) ->
    text = @htmlEntities(text)
    text = @toLink(text)
    text = @checkForCode(text)

  checkForCode: (text) ->
    regex = /^\s{2,}/g
    regexInline = /\u0060([^\u0060]*)\u0060/g
    if regex.test(text)
      text = text.replace(/^\s{2,}/g, '')
      text = '<pre><code>' + text.replace(/\\r\\n/g, '<br />') + '</code></pre>'

    if regexInline.test(text)
      text = text.replace(/\u0060([^\u0060]*)\u0060/g, "<code>$&</code>")
      text = text.replace(/\u0060/g, '')

    return text

  breakupText: (text) ->
    text = text.match(/.{1,36}/g).map (txt) ->  txt + '<wbr></wbr>'
    text.join("")

  toLink: (text) ->
    urlRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/)(%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

    if urlRegex.test(text)
      return text.replace urlRegex, (url) =>
        if ( ( url.indexOf(".jpg") > 0 ) || ( url.indexOf(".png") > 0 ) || ( url.indexOf(".gif") > 0 ) )
          return '<a href="' + url + '" target="_blank" class="icon-link"><img src="' + url + '" class="thumb"></a>'
        else
          return '<a href="' + url + '" target="_blank" class=" break-all"><i class="icon-link"></i><span>' + url + '</span></a>'
    else @breakupText(text)

  htmlEntities: (str) ->
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')

  log: (params...) ->
    console.log(params) if @logging

module.exports = new Main()
