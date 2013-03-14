cheerio = require 'cheerio'
config = require './config'
article = require './parser/article'
index = require './index'

exports.parseData = (xml, respond) ->
  $ = cheerio.load xml,
    xmlMode: true
  try
    data = article.parse $
    if not data.id?
      respond 400
    index.add data, (err) ->
      if err?
        console.warn err
        respond 500
      respond 200
  catch error
    console.error error
    respond 500


exports.handleReq = (req, res) ->

  if not req.query.secret?
    res.send 401

  if req.query.secret isnt config.secret
    res.send 403

  respond = (status) ->
    res.send status

  data = ''
  req.setEncoding 'utf-8'
  req.on 'data', (d) ->
    data += d

  req.on 'end', () ->
    exports.parseData data, respond

