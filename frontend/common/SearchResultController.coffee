morphs = window.angular.module 'morphs'


morphs.controller 'SearchResultController', class SearchResultController
  constructor: ($scope, @$stateParams, @$state, @SurveyService, @SearchResultsService) ->
    $scope.ctrl = @
    @survey = {}
    @search_result = {}

    @SurveyService.get_survey(@$stateParams.survey_id)
      .then (survey) =>
        window.angular.copy survey, @survey

    @SearchResultsService.get_search_result(@$stateParams.search_result_id)
      .then (search_result) =>
        window.angular.copy search_result, @search_result

  update_search_result: (completion_state) =>
    search_result = {
      completion_state: completion_state
      field_values: @search_result.field_values
    }
    return @SearchResultsService.update_search_result @$stateParams.search_result_id, search_result

  next: =>
    @$state.go 'surveys.details.search-results.details', {search_result_id: parseInt(@$stateParams.search_result_id) + 1}

  previous: =>
    @$state.go 'surveys.details.search-results.details', {search_result_id: parseInt(@$stateParams.search_result_id) - 1}

  done_and_next: =>
    @update_search_result 'DONE'
      .then =>
        @next()

  revisit_and_next: =>
    @update_search_result 'REVISIT'
      .then =>
        @next()

  not_usable_and_next: =>
    @update_search_result 'NOT_USABLE'
      .then =>
        @next()

  save_updates: =>
    @update_search_result @search_result.completion_state