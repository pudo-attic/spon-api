config = require './config'
cheerio = require 'cheerio'


parseData = (data, res) ->
  $ = cheerio.load data,
    xmlMode: true

  el = $ 'weburl'
  console.log $('weburl').text()
  res.send 200


exports.handleReq = (req, res) ->

  if not req.query.secret?
    res.send 401

  if req.query.secret isnt config.secret
    res.send 403

  data = ''
  req.setEncoding 'utf-8'
  req.on 'data', (d) ->
    data += d

  req.on 'end', () ->
    parseData data, res

