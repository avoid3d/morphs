morphs = window.angular.module 'morphs'


morphs.controller 'SearchResultsController', class SearchResultsController
  constructor: ($scope, @$stateParams, @SearchResultsService) ->
    @tags = []
    @search_results = []
    $scope.ctrl = @
    @filter = []

    @SearchResultsService.get_tags(@$stateParams.survey_id)
      .then (tags) =>
        window.angular.copy (tag.value for tag in tags), @tags

    @get_search_results()

  get_search_results: (filter) =>
    @SearchResultsService.get_search_results(@$stateParams.survey_id, filter)
      .then (search_results) =>
        window.angular.copy search_results, @search_results

  filter_search_results: =>
    @get_search_results @filter
