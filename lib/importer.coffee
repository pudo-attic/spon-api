cheerio = require 'cheerio'
config = require './config'
article = require './parser/article'
index = require './index'

exports.parseData = (data, respond) ->
  $ = cheerio.load data,
    xmlMode: true
  data = article.parse $
  index.add data, (err) ->
    if err?
      console.warn err
      respond 500
    respond 200


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

