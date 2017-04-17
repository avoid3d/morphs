morphs = window.angular.module 'morphs'


morphs.controller 'ListSearchResultsController', class ListSearchResultsController
  constructor: ($scope, @$stateParams, @SearchResultsService) ->
    @tags = []
    @search_results = []
    @filter = []
    @current_page = 0
    @per_page = 60
    $scope.ctrl = @

    @SearchResultsService.get_tags(@$stateParams.survey_id)
      .then (tags) =>
        window.angular.copy (tag.value for tag in tags), @tags

    @get_search_results()

  get_search_results: (filter, page) =>
    @SearchResultsService.get_search_results(@$stateParams.survey_id, filter, page)
      .then (search_results) =>
        window.angular.copy search_results, @search_results
        @total_search_results = search_results.meta.count

  filter_search_results: =>
    @get_search_results @filter

  page_changed: =>
    @get_search_results @filter, @current_page
