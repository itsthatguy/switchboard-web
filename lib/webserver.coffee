
http    = require('http')
express = require('express')
path    = require('path')


app = express()
webserver = http.createServer(app)
basePath = path.join(__dirname, "../")

app.engine('html', require('ejs').renderFile)

app.configure ->
  app.use('/assets', express.static(basePath + '/.generated'))
  app.use('/vendor', express.static(basePath + '/bower_components'))

port = process.env.PORT || 3002
webserver.listen(port)

app.get '/', (req, res) ->
  res.render(path.join(basePath + '/index.html'))

module.exports = webserver
