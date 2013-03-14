assert = require 'assert'
url = require 'url'

exports.port = process.env.PORT or 3000
exports.solr = url.parse process.env.WEBSOLR_URL or 'http://localhost:8983/solr'
exports.baseurl = process.env.SPON_BASE_URL or 'http://localhost:3000'

exports.production = process.env.NODE_ENV is 'production'

assert process.env.SPON_IMPORT_SECRET?, 'You must set SPON_IMPORT_SECRET for import POSTs!'
exports.secret = process.env.SPON_IMPORT_SECRET
