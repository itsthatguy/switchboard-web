require '../index.coffee'

http = require('http')
send = require('send')
url = require('url')
port = process.env.PORT || 3002

app = http.createServer (req, res) ->
  # your custom error-handling logic:
  error = (err) ->
    res.statusCode = err.status || 500
    res.end(err.message)

  # your custom directory handling logic:
  redirect = ->
    res.statusCode = 301
    res.setHeader('Location', req.url + '/')
    res.end('Redirecting to ' + req.url + '/')


  # transfer arbitrary files from within
  # /www/example.com/public/*
  send(req, url.parse(req.url).pathname)
  .root('.')
  .index('index.html')
  .on('error', error)
  .on('directory', redirect)
  .pipe(res)
.listen(port)
