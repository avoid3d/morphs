morphs = window.angular.module 'morphs'


morphs.controller 'SearchesController', class SearchController
  constructor: ($scope, $stateParams, @$window, SearchesService) ->
    $scope.ctrl = @
    @searches = []
    SearchesService.get_searches($stateParams.survey_id)
      .then (searches) =>
        window.angular.copy searches, @searches

  run_search: (search) =>
    query_string = encodeURIComponent(search.search_query)
    url = 'http://www.google.com/images?q=' + query_string + '#morphic'
    @$window.open url

