
http    = require('http')
express = require('express')
path    = require('path')
crypto  = require('crypto')

generateKey = ->
  sha = crypto.createHash('sha256')
  sha.update(Math.random().toString())
  return sha.digest('hex')

app = express()
webserver = http.createServer(app)
basePath = path.join(__dirname, "../")
staticPath = path.join(basePath, '.generated')

app.engine('html', require('ejs').renderFile)

app.configure ->
  app.use(express.cookieParser())
  app.use(express.session({secret: '5003d152ff759b75b06580008d554ca52f878f5b93e751a1aa8770c4ec4946be'}))
  app.use('/assets', express.static(staticPath))
  app.use('/vendor', express.static(basePath + '/bower_components'))

port = process.env.PORT || 3002
webserver.listen(port)

app.get '/', (req, res) ->
  previousSession = req.cookies.sid
  if previousSession?
    console.log "I see you have a previous session."
  else unless previousSession?
    console.log "No previous session. let me generate one for you."
    sid = generateKey()
    res.cookie("sid", sid)
  res.render(path.join(basePath, '/index.html'))

app.get '/styleguide', (req, res) ->
  res.render(path.join(staticPath, 'styleguide', 'index.html'))

module.exports = webserver
