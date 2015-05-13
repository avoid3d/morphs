morphs = window.angular.module 'morphs'

class SurveysController
  constructor: ($scope) ->
    $scope.surveys = []

morphs.controller 'SurveysController', SurveysController