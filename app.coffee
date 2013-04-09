
express = require 'express'
config = require './lib/config'
importer = require './lib/importer'
article = require './views/article'

app = express()
app.use express.logger()
app.use express.compress()
app.use express.errorHandler()
app.use express.static __dirname + '/static/_site'
app.disable "x-powered-by"

app.get '/status', (req, res) ->
  res.jsonp 200,
    status: 'ok'

app.post '/import', importer.handleReq

app.get '/v1/spon/article/:id', article.get
app.get '/v1/spon/article', article.index

app.listen config.port

