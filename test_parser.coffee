
config = require './lib/config'
importer = require './lib/importer'
fs = require 'fs'

data = fs.readFileSync('test/sample.xml')
importer.parseData data, (x) ->
  console.log x

