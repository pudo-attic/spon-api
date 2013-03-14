assert = require 'assert'
url = require 'url'

exports.port = process.env.PORT or 3000
exports.solr = url.parse process.env.WEBSOLR_URL or 'http://localhost:8983/solr'
exports.baseurl = process.env.BASE_URL or 'http://localhost:3000'

exports.safe = process.env.NODE_ENV is 'production'

assert process.env.SPON_API_SECRET?, 'You must set SPON_API_SECRET for ingest POSTs!'
exports.secret = process.env.SPON_API_SECRET
