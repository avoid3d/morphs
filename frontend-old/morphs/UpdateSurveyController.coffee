morphs = window.angular.module 'morphs'


morphs.controller 'UpdateSurveyController', class UpdateSurveyController
  constructor: ($scope, @SurveysService, $stateParams) ->
    $scope.ctrl = @
    @survey = {}
    @SurveysService.get_survey($stateParams.survey_id)
      .then (survey) =>
        window.angular.copy survey, @survey
