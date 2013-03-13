util = require './util'
body = require './body'

exports.parse = ($) ->

  $article = $ 'article'
  data =
    site: $article.find('metadata > site').text()
    status: $article.find('metadata > status').text()
    launchdate: $article.find('metadata > launchdate').text()
    modificationdate: $article.find('metadata > modificationdate').text()
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
      url: util.toURL $article.find('metadata > channel > path').text()
    rubric:
      id: $article.find('metadata > rubric > id').text()
      name: $article.find('metadata > rubric > name').text()
      url: util.toURL $article.find('metadata > rubric > path').text()
    topics: []
    authors: []

  for child in $article.find('metadata > topics > topic')
    $child = $ child
    data.topics.push
      id: $child.find('topic > id').text()
      name: $child.find('topic > name').text()
      url: util.toURL 'thema', $child.find('topic > path').text()
      category: $child.find('topic > category').text()
      channel:
        id: $child.find('displaychannel > id').text()
        name: $child.find('displaychannel > name').text()
        url: util.toURL $child.find('displaychannel > path').text()

  for child in $article.find('metadata > authors > author')
    data.authors.push
      id: $(child).find('id').text()
      name: $(child).find('name').text()

  data.body = body.parse $, $('article > body')
  return data
