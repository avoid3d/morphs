morphs = window.angular.module 'morphs'


morphs.controller 'CreateSearchController', class CreateSearchController
  constructor: ($scope, @$state, @$stateParams, @SearchesService) ->
    @create_search_form = {
      name: null,
      comments: null,
    }
    $scope.ctrl = @ 

  create_search:  =>
    @SearchesService.create_search @$stateParams.survey_id, @create_search_form
      .then (search) =>
        @$state.go 'surveys.details.searches.list', {survey_id: @$stateParams.survey_id}

