morphs = window.angular.module 'morphs'

morphs.service 'SurveysService', class SurveysService
  constructor: (@Restangular, @UserService) ->
    @surveys = []

  get_survey: (survey_id) =>
    return @Restangular.one('surveys', survey_id).get()

  refresh: =>
    @Restangular
      .one 'users', @UserService.user.id_
      .all 'surveys'
      .getList()
      .then (surveys) =>
        window.angular.copy surveys, @surveys
      , (error) ->
        console.log error

  create_survey: (survey_data) =>
    console.log 'createe', survey_data
    promise = @Restangular
      .one 'users', @UserService.user.id_
      .all 'surveys'
      .post (survey_data)

    promise.then (survey) =>
        @refresh()

    return promise
