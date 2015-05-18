morphs = window.angular.module 'morphs'


morphs.controller 'ListSearchesController', class ListSearchController
  constructor: ($scope, $stateParams, @$window, SearchesService) ->
    $scope.ctrl = @
    @searches = []
    SearchesService.get_searches($stateParams.survey_id)
      .then (searches) =>
        window.angular.copy searches, @searches

  run_search: (search) =>
    query_string = encodeURIComponent(search.search_query)
    url = 'https://www.google.com/images?q=' + query_string
    @$window.open url
