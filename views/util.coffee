config = require '../lib/config'
_ = require 'underscore'

exports.unpackDocs = (docs) ->
  data = []
  for doc in docs
    d = JSON.parse doc.json
    d.score = doc.score
    data.push d
  return data

exports.urlFor = (path...) ->
  parts = [config.baseurl].concat path
  return parts.join '/'

exports.asList = (data) ->
  if not data?
    return []
  if not _.isArray data
    return [data]
  return data

exports.getFacetCounts = (fields, data) ->
  facets = {}
  if not fields
    return facets
  for facet in fields
    facets[facet] = {}
    key = null
    for kv in data.facet_counts.facet_fields[facet]
      if key?
        facets[facet][key] = kv
        key = null
      else
        key = kv
  return facets

