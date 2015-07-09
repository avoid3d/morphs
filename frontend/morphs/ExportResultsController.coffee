morphs = window.angular.module 'morphs'


morphs.controller 'ExportResultsController', class ExportResultsController 
  constructor: ($scope, $stateParams, @API_ENDPOINT)->
    @survey_id = $stateParams.survey_id
    $scope.ctrl = @

  getExportResultsURL: ->
    return @API_ENDPOINT + '/surveys/' + @survey_id + '/export-results'
