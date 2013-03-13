_ = require 'underscore'

exports.toURL = (parts...) ->
  parts = ['http://www.spiegel.de'].concat parts
  return parts.join '/'

exports.flatten = (data, sep = '_') ->
  out = {}
  for k, v of data
    if _.isArray(v)
      for o in v
        for ik, iv of exports.flatten o, sep
          ak = k + sep + ik
          if out[ak]?
            out[ak].push iv
          else
            out[ak] = [iv]
    else if _.isObject(v)
      for ik, iv of exports.flatten v, sep
        out[k + sep + ik] = iv
    else
        out[k] = v
  return out

