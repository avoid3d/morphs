morphs = window.angular.module 'morphs'

morphs.controller 'SurveysController', class SurveysController
  constructor: ($scope, SurveysService) ->
    $scope.ctrl = @
    @surveys = SurveysService.surveys
    SurveysService.refresh()
