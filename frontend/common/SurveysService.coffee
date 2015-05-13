morphs = window.angular.module 'morphs'

morphs.service 'SurveysService', class SurveysService
  constructor: (@Restangular) ->
    @surveys = ['hello']

  refresh: ->
    @Restangular
      .one 'user', 0 #user_id
      .all 'surveys'
      .getList()
      .then (surveys) ->
        window.angular.copy surveys, @surveys
      , (error) ->
        console.log error