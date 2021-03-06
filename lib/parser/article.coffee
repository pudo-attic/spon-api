util = require './util'
body = require './body'
_ = require 'underscore'

exports.parse = ($) ->
  $article = $ 'article'
  data =
    query: $article.attr('id')
    site: $article.find('metadata > site').text()
    status: $article.find('metadata > status').text()
    launchdate: util.isoDate $article.find('metadata > launchdate').text()
    modificationdate: util.isoDate $article.find('metadata > modificationdate').text()
    status: $article.find('metadata > status').text()
    language: $article.find('metadata > language').text()
    url: $article.find('metadata > weburl').text()
    topic: $('article > topic').text()
    authorline: $('article > authorline').html()
    headline: $('article > headlines > headline[type=article]').text()
    teaser: $('article > teasers > teaser[type=article]').text()
    channel:
      id: $article.find('metadata > channel > id').text()
      name: $article.find('metadata > channel > name').text()
      path: $article.find('metadata > channel > path').text()
      url: util.toURL $article.find('metadata > channel > path').text()
    rubric:
      id: $article.find('metadata > rubric > id').text()
      name: $article.find('metadata > rubric > name').text()
      path: $article.find('metadata > rubric > path').text()
      url: util.toURL $article.find('metadata > rubric > path').text()
    topics: []
    authors: []

  for child in $article.find('metadata > topics > topic')
    $child = $ child
    data.topics.push
      id: $child.find('topic > id').text()
      name: $child.find('topic > name').text()
      url: util.toURL 'thema', $child.find('topic > path').text()
      path: $child.find('topic > path').text()
      category: $child.find('topic > category').text()
      channel:
        id: $child.find('displaychannel > id').text()
        name: $child.find('displaychannel > name').text()
        path: $child.find('displaychannel > path').text()
        url: util.toURL $child.find('displaychannel > path').text()

  for child in $article.find('metadata > authors > author')
    data.authors.push
      id: $(child).find('id').text()
      name: $(child).find('name').text()
  
  data.id = _.last data.query.split '/'
  data.type = 'article'
  data.body = body.parse $, $('article > body')
  return data
