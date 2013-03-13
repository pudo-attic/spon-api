config = require './config'
solr = require 'solr'

add_options =
  overwrite: true
  commit: true

client = solr.createClient
  host: config.solr.host
  port: config.solr.port
  path: config.solr.path

console.log client
