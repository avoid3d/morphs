morphs = window.angular.module 'morphs'


morphs.controller 'UpdateSearchResultController', class SearchResultController
  constructor: ($rootScope, $scope, @$stateParams, @$state, @SurveysService, @SearchResultsService) ->
    $rootScope.extra_survey_nav_item = {
      label: "Search Result (#{@$stateParams.search_result_id})"
      state: 'surveys.details.search-results.details'
    }

    $scope.$on '$destroy', ->
      $rootScope.extra_survey_nav_item = {}


    $scope.ctrl = @
    @survey = {}
    @search_result = {}
    @saving = false 

    @SurveysService.get_survey(@$stateParams.survey_id)
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
    @saving = true
    promise = @SearchResultsService.update_search_result @$stateParams.search_result_id, search_result
    promise.finally => @saving = false


  get_label: ->
    classes = {
      'DONE': 'label-success'
      'REVISIT': 'label-warning'
      'NOT_USABLE': 'label-danger'
    }

    labels = {
      'DONE': 'Done'
      'REVISIT': 'Revisit'
      'NOT_USABLE': 'Not usable'
    }

    return {
      'class': classes[@search_result.completion_state]
      'label': labels[@search_result.completion_state]
    }

  should_show_next: =>
    #TODO: Show based on search_results for this search.
    true

  should_show_previous: =>
    #TODO: Show based on search_results for this search.
    return @$stateParams.search_result_id > 0

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