index = require '../lib/index'
config = require '../lib/config'
util = require './util'

baseOptions = () ->
  options =
    fq = ['+type:article']
  if config.safe
    options.fq.push '+state:live'
  return options


exports.index = (req, res) ->
  options = baseOptions()
  q = req.query.q or '*:*'
  index.query q, options, (data, err) ->
    if err?
      res.status 400
      res.send err
    results = []
    for doc in util.unpackDocs data.response.docs
      delete doc.body
      delete doc.authors
      delete doc.topics
      doc.api_url = util.url_for 'v1/spon/article', doc.id
      results.push doc
    res.send 
      count: data.response.numFound
      results: doc


exports.get = (req, res) ->
  options = baseOptions()
  index.query '+id:' + req.params.id, options, (data, err) ->
    if err?
      res.status 400
      res.send err

    if data.response.numFound isnt 1
      res.send 404

    for doc in util.unpackDocs data.response.docs
      delete doc.score
      doc.api_url = util.url_for 'v1/spon/article', doc.id
      res.send doc

