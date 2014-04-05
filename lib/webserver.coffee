
http    = require('http')
express = require('express')
path    = require('path')


app = express()
webserver = http.createServer(app)

app.engine('html', require('ejs').renderFile)

app.configure ->
  basePath = path.join(__dirname, '..')
  app.use('/.generated', express.static(basePath + '/.generated/'))
  app.use('/vendor', express.static(basePath + '/bower_components/'))

port = 3002
webserver.listen(port)

app.get '/', (req, res) ->
  res.render('../index.html')

module.exports = webserver
