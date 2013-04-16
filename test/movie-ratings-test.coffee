assert = require 'assert'
_ = require 'underscore'

MovieRatingsResource = require '../app/movie-ratings'

describe 'MovieRatingsResource', ->
  movieRatings = {}

  beforeEach ->
    movieRatings = new MovieRatingsResource
      'Bladerunner': [5, 1]
      'The Empire Strikes Back': [1, 1, 2, 3, 5]

  describe '#getAllMovieRatings()', ->
    it 'should return the correct ratings for all movies', ->
      expected =
        'Bladerunner': [1, 5]
        'The Empire Strikes Back': [5, 3, 2, 1, 1, 1]

      actual = movieRatings.getAllMovieRatings()

      _.each expected, (value, key) =>
        diff = _.difference(value, actual[key])
        throw new Error 'Wrong ratings' if diff.length > 0


  describe '#getMovieRatings()', ->
    it 'should return the correct movie ratings for the requested movie', ->
      expected = [1, 5]
      actual = movieRatings.getMovieRatings('Bladerunner')

      diff = _.difference(expected, actual)
      throw new Error 'Wrong ratings' if diff.length > 0

    it 'should throw an error if the requested movie does not exist in the repo', ->
      assert.throws ->
        movieRatings.getMovieRatings 'no movie'

  describe '#putMovieRatings()', ->
    it 'should put a new movie with ratings into the repo and return the ratings', ->
      movieRatings.putMovieRatings 'New movie', [1, 2, 3]
      diff = _.difference([3, 2, 1], movieRatings.getMovieRatings('New movie'))
      throw new Error 'Wrong ratings' if diff.length > 0

    it 'should overwrite the ratings of an existing movie in the repo and return the new ratings', ->
      movieRatings.putMovieRatings 'Bladerunner', [1, 2, 3]
      diff = _.difference([3, 2, 1], movieRatings.getMovieRatings('Bladerunner'))
      throw new Error 'Wrong ratings' if diff.length > 0

  describe '#postMovieRating()', ->

    it 'should put a new movie with rating into the repo if it does not already exist and return the rating', ->
      movieRatings.putMovieRatings 'New movie', [1, 2, 3]
      diff = _.difference([3, 2, 1], movieRatings.getMovieRatings('New movie'))
      throw new Error 'Wrong ratings' if diff.length > 0

    it 'should add a new rating to an existing movie in the repo and return the ratings', ->
      movieRatings.putMovieRatings 'Bladerunner', [1, 2, 3]
      diff = _.difference([3, 2, 1], movieRatings.getMovieRatings('Bladerunner'))
      throw new Error 'Wrong ratings' if diff.length > 0

  describe '#deleteMovieRatings()', ->

    it 'should delete a movie from the ratings repo', ->
      movieRatings.deleteMovieRatings 'Bladerunner'
      assert.throws -> movieRatings.getMovieRatings 'Bladerunner'
#
    it 'should throw an error when attempting to delete a movie that does not exist', ->
      assert.throws -> movieRatings.deleteMovieRatings 'no movie'
