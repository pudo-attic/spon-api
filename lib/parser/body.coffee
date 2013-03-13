util = require './util'

parseAssets = ($) ->
  assets = {}
  for tag_ in $('assets > asset')
    el = $ tag_
    asset =
      cid: el.attr 'cid'
    for attr in el.find 'attribute'
      ael = $ attr
      asset[ael.attr 'name'] = ael.html()
    if asset.cid is 'ilink' and asset.type is 'article' and asset.site is 'spon'
      slug = asset.seoline + '-a-' + asset.articleid + '.html'
      asset.url = util.toURL asset.context, slug
    assets[el.attr 'oid'] = asset
  return assets


exports.parse = ($, body) ->
  assets = parseAssets $
  for cetag in body.find('cetag')
    tag = $ cetag
    switch tag.attr 'cid'
      when 'contentad'
        tag.replaceWith '<span class="cetag contentad"></span>'
      when 'topiclink'
        topicid = tag.find('attribute[name=topicid]').text()
        content = tag.find('attribute[name=content]').text()
        asset = assets['topiclink_' + topicid]
        url = util.toURL 'thema', asset.path
        tag.replaceWith "<a href='#{url}'
          class='cetag topiclink'
          data-topic-id='#{topicid}'
          data-topic-path='#{asset.path}'>#{content}</a>"
      when 'ilink'
        asset = assets[tag.attr 'oid']
        content = tag.find('attribute[name=content]').text()
        if asset.url?
          tag.replaceWith "<a href='#{asset.url}'
            class='cetag ilink'
            data-article-id='#{asset.articleid}'
            data-topic='#{asset.topic}'
            title='#{asset.headline}'>#{content}</a>"
        else
          tag.replaceWith content
      else
        console.warn 'Unknown CETAG: ' + tag.attr 'cid' #$.html tag
        tag.replaceWith '<!-- removed cetag -->'

  return body.html()
