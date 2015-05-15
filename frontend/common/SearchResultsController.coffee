morphs = window.angular.module 'morphs'


morphs.controller 'SearchResultsController', class SearchResultsController
  constructor: ($scope, $stateParams, SearchResultsService) ->
    @tags = ['this', 'is', 'a', 'world']
    @search_results = []
    $scope.ctrl = @
    SearchResultsService.get_search_results($stateParams.survey_id)
      .then (search_results) =>
        window.angular.copy search_results, @search_results