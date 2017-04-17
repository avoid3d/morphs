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
    morphic_id = search.id_
    url = "https://www.google.com/search?q=#{query_string}&fg=1&tbm=isch&tbs=itp:photo,morphic_id:#{morphic_id}"
    @$window.open url, '_blank'

