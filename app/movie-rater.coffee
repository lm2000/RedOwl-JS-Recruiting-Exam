_ = require 'underscore'

module.exports = (ratings) ->
  throw new Error 'Invalid arguments' if arguments.length > 1
  throw new Error 'Invalid arguments' if ratings not instanceof Array
  throw new Error 'Not enough ratings' if _.uniq(ratings).length < 3

  min = _.min(ratings)
  max = _.max(ratings)

  filtered = _.filter(ratings, (num) =>
    num != min && num != max)

  average = _.reduce(filtered, (memo, num) ->
    memo + num
  , 0) / filtered.length

  return average;


