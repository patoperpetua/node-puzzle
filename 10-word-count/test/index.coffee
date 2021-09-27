assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'

helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'test files provided', (done) ->
    fs.readdir "#{__dirname}/fixtures",  (err, files) -> 
      totalTests = files.length
      files.forEach (file) -> 
        fs.readFile "#{__dirname}/fixtures/"+file, 'utf8', (err, data) ->
          params = file.split(',')
          helper data, { words: params[1], lines: params[0] }, () -> {}
    return done()
