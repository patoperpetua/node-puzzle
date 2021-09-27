fs = require 'fs'


exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  fs.readFile "#{__dirname}/../data/geo.txt", 'utf8', (err, data) ->
    if err then return cb err

    data = data.toString().split '\n'

    filteredData = data.filter (d) -> d.includes(countryCode);

    counter = filteredData.reduce (acc, line) ->
      line = line.split '\t'
      +line[1] - +line[0] + acc
    , 0

    cb null, counter
