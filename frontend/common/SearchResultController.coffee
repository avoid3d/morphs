morphs = window.angular.module 'morphs'


morphs.controller 'SearchResultsController', class SearchResultsController
  constructor: ($scope, $stateParams, SearchResultsService) ->
    @tags = ['this', 'is', 'a', 'world']
    $scope.ctrl = @
    SearchResultsService.get_search_results($stateParams.survey_id)