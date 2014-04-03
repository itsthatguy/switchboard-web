
http    = require('http')
express = require('express')
path    = require('path')


app = exports.app = express()
server = exports.server = http.createServer(app)

app.engine('html', require('ejs').renderFile)

app.configure ->
  basePath = path.join(__dirname, '..')
  app.use('/.generated', express.static(basePath + '/.generated/'))
  app.use('/vendor', express.static(basePath + '/bower_components/'))

port = 3002
server.listen(port)

app.get '/', (req, res) ->
  res.render('../index.html')
