morphs = window.angular.module 'morphs', [
  'ui.router',
  'ui.bootstrap',
  'ipCookie',
  'uiGmapgoogle-maps',
  'restangular',
  'users',
  'nav',
]

morphs.config (uiGmapGoogleMapApiProvider) ->
  uiGmapGoogleMapApiProvider.configure {
    #key: 'your api key',
    v: '3.17',
    libraries: 'places,geometry'
  }


morphs.config (RestangularProvider, API_ENDPOINT) ->
  RestangularProvider.setBaseUrl API_ENDPOINT

morphs.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/surveys/list'

  $stateProvider.state 'instructions', {
    url: '/instructions'
    templateUrl: 'morphs/templates/instructions.html'
    is_private: true
  }

  $stateProvider.state 'surveys', {
    url: '/surveys'
    abstract: 'true'
    template: '<div ui-view></div'
    is_private: true
  }

  $stateProvider.state 'surveys.list', {
    url: '/list'
    templateUrl: 'morphs/templates/surveys.list.html'
    controller: 'ListSurveysController'
    is_private: true
  }

  $stateProvider.state 'surveys.create', {
    url: '/create'
    templateUrl: 'morphs/templates/surveys.create.html'
    controller: 'CreateSurveyController'
    is_private: true
  }

  $stateProvider.state 'surveys.details', {
    abstract: true
    url: '/:survey_id'
    templateUrl: 'morphs/templates/surveys.details.html'
    controller: 'UpdateSurveyController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.search-results', {
    abstract: true
    url: '/search-results'
    template: '<div ui-view></div'
    is_private: true
  }

  $stateProvider.state 'surveys.details.search-results.list', {
    url: '/list'
    templateUrl: 'morphs/templates/surveys.details.search-results.list.html'
    controller: 'ListSearchResultsController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.search-results.details', {
    url: '/:search_result_id'
    templateUrl: 'morphs/templates/surveys.details.search-results.details.html'
    controller: 'UpdateSearchResultController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches', {
    abstract: true
    url: '/searches'
    template: '<div ui-view></div>'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches.list', {
    url: '/list'
    templateUrl: 'morphs/templates/surveys.details.searches.list.html'
    controller: 'ListSearchesController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches.create', {
    url: '/create'
    templateUrl: 'morphs/templates/surveys.details.searches.create.html'
    controller: 'CreateSearchController'
    is_private: true
  }

morphs.run ($rootScope, $state, $stateParams) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams

morphs.run ($rootScope, $state, UserService) ->
  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    if (toState.is_private and not UserService.is_signed_in())
      # Prevent the existing state change so that we can start a new one.
      event.preventDefault()
      $state.go 'sign-in'
