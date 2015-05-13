morphs = window.angular.module 'morphs'

morphs.controller 'SurveysController', class SurveysController
  constructor: ($scope, SurveysService) ->
    $scope.surveys = SurveysService.surveys
    SurveysService.refresh()
