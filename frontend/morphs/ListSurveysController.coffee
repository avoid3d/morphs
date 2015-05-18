morphs = window.angular.module 'morphs'

morphs.controller 'ListSurveysController', class ListSurveysController
  constructor: ($scope, SurveysService) ->
    $scope.ctrl = @
    @surveys = SurveysService.surveys
    SurveysService.refresh()
