config = require './config'
solr = require 'solr'
util = require './parser/util'


add_options =
  overwrite: true
  commit: true

getClient = () ->
  return solr.createClient
    host: config.solr.hostname
    port: config.solr.port
    path: config.solr.path

exports.add = (data, callback) ->
  flat = util.flatten data
  flat.json = JSON.stringify data
  client = getClient()
  client.add flat, add_options, (err) ->
    if err?
      callback err
    client.commit (err) ->
      console.log 'Indexed: ' + flat.query
      callback err

