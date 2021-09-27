through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1

  transform = (chunk, encoding, cb) ->
    data = chunk.split('\n').filter (i) -> i
    lines = data.length
    words = 0
    data.forEach (d) -> 
      quotedWords = (d.match(/"[^"]+"/) || []).length

      # remove the words in quotes
      unCountedWords = d.replace(/"[^"]+"/,'').trim()      

      # split the camelCase words in separated words.
      unCountedWords = unCountedWords.replace(/([a-z])([A-Z])/g, '$1 $2')
      tokens = unCountedWords.split(' ').filter (i) -> i
      words += tokens.length + quotedWords
    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
