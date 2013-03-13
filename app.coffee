
express = require 'express'
config = require './lib/config'
importer = require './lib/importer'

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


app.listen config.port

