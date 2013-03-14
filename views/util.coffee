config = require '../lib/config'

exports.unpackDocs = (docs) ->
  data = []
  for doc in docs
    d = JSON.parse doc.json
    d.score = doc.score
    data.push d
  return data

exports.url_for = (path...) ->
  parts = [config.baseurl].concat path
  return parts.join '/'

