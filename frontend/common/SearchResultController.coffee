morphs = window.angular.module 'morphs'


morphs.controller 'SearchResultController', class SearchResultController
  constructor: ($scope, $stateParams, @SurveyService) ->
    $scope.ctrl = @
    @survey = {}

    @SurveyService.get_survey($stateParams.survey_id)
      .then (survey) =>
        window.angular.copy survey, @survey