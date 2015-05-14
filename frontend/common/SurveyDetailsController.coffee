morphs = window.angular.module 'morphs'


morphs.controller 'SurveyDetailsController', class SurveyDetailsController
  constructor: ($scope, @SurveyService, $stateParams) ->
    $scope.ctrl = @
    @survey = {}
    @SurveyService.get_survey($stateParams.survey_id)
      .then (survey) =>
        window.angular.copy survey, @survey
        console.log survey, @survey


