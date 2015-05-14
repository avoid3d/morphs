morphs = window.angular.module 'morphs'


morphs.service 'SurveyService', class SurveyService
  constructor: (@Restangular) ->

  get_survey: (survey_id) =>
    return @Restangular.one('surveys', survey_id).get()
