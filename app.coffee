
express = require 'express'
config = require './lib/config'
importer = require './lib/importer'
article = require './views/article'

app = express()
app.use express.logger()
app.use express.compress()
app.use express.errorHandler()
# app.use express.bodyParser()
app.use express.static __dirname + '/static'

app.get '/status', (req, res) ->
  res.send 
    hello: 'world!'

app.post '/import', importer.handleReq

app.get '/v1/spon/article/:id', article.get
app.get '/v1/spon/article', article.index

app.listen config.port

