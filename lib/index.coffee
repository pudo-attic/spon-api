config = require './config'
solr = require 'solr'
util = require './parser/util'


add_options =
  overwrite: true
  commit: true

getClient = () ->
  return solr.createClient
    host: config.solr.hostname
    port: config.solr.port or 80
    path: config.solr.path
    auth: config.solr.auth

exports.add = (data, callback) ->
  flat = util.flatten data
  flat.json = JSON.stringify data
  client = getClient()
  client.add flat, add_options, (err) ->
    if err?
      callback err
    client.commit (err) ->
      console.log 'Indexed: ' + flat.url + ', ' + flat.query
      callback err

exports.query = (q, options, callback) ->
  options.fl = 'score,json'
  options.df = 'text'
  client = getClient()
  client.query q, options, (err, res) ->
    if err?
      try
        data = err.toString().substring 7
        err = JSON.parse(data).error
      catch fail
        err = 
          msg: err.toString()
      return callback null, err
    data = JSON.parse res
    return callback data, err

