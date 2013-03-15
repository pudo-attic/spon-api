_ = require 'underscore'
qs = require 'querystring'

index = require '../lib/index'
config = require '../lib/config'
util = require './util'

PAGE_SIZE = 10


baseOptions = () ->
  options =
    fq: ['+type:article', '+status:live']
  return options


buildOptions = (query) ->
  options = baseOptions()
  options.sort = query.sort or 'launchdate desc'

  if query.limit?
    options.rows = parseInt query.limit, 10
    if options.rows is NaN or options.rows > 500
      options.rows = PAGE_SIZE
  else
    options.rows = PAGE_SIZE

  options.start = parseInt query.offset, 0
  options.start = Math.max 0, options.start or 0

  options.fq = options.fq.concat util.asList query.filter
  if query.facet?
    facets = util.asList query.facet
    options.facet = true
    options['facet.mincount'] = 1
    options['facet.field'] = facets
    limit = parseInt query['facet-limit'], 10
    options['facet.limit'] = Math.min 500, limit or PAGE_SIZE

  return options


exports.index = (req, res) ->
  options = buildOptions req.query

  q = req.query.q or '*:*'
  index.query q, options, (data, err) ->
    if err?
      return res.jsonp 400, err

    resdata =
      count: data.response.numFound
      results: []

    for doc in util.unpackDocs data.response.docs
      delete doc.body
      delete doc.authors
      delete doc.topics
      delete doc.channel
      delete doc.rubric
      delete doc.query
      delete doc.type
      delete doc.authorline
      delete doc.status
      doc.api_url = util.urlFor 'v1/spon/article', doc.id
      resdata.results.push doc

    facets = util.getFacetCounts options['facet.field'], data
    if facets?
      resdata.facets = facets

    if not config.production
      resdata.options = options

    if options.start + options.rows < resdata.count
      q = qs.stringify _.extend {}, res.query,
        offset: options.start + options.rows
      resdata.next_url = util.urlFor 'v1/spon/article?' + q

    if options.start > 0
      q = qs.stringify _.extend {}, res.query,
        offset: Math.max 0, options.start - options.rows
      resdata.prev_url = util.urlFor 'v1/spon/article?' + q

    res.jsonp 200, resdata


exports.get = (req, res) ->
  options = baseOptions()
  index.query '+id:' + req.params.id, options, (data, err) ->
    if err?
      return res.jsonp 400, err

    if data.response.numFound isnt 1
      return res.jsonp 404,
        msg: 'Not found.'

    for doc in util.unpackDocs data.response.docs
      delete doc.score
      doc.api_url = util.urlFor 'v1/spon/article', doc.id
      res.jsonp 200, doc

