morphs = window.angular.module 'morphs', [
  'ui.router',
  'ui.bootstrap',
  'ipCookie',
  'restangular',
  'nav',
]

morphs.config (RestangularProvider, API_ENDPOINT) ->
  RestangularProvider.setBaseUrl API_ENDPOINT

morphs.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/surveys/list'

  $stateProvider.state 'surveys', {
    url: '/surveys'
    abstract: 'true'
    template: '<div ui-view></div'
    is_private: true
  }

  $stateProvider.state 'surveys.list', {
    url: '/list'
    templateUrl: 'common/templates/list-surveys.html'
    controller: 'SurveysController'
    is_private: true
  }

  $stateProvider.state 'surveys.create', {
    url: '/create'
    templateUrl: 'common/templates/create-survey.html'
    controller: 'CreateSurveyController'
    is_private: true
  }

  $stateProvider.state 'surveys.details', {
    abstract: true
    url: '/:survey_id'
    templateUrl: 'common/templates/survey-details.html'
    controller: 'SurveyDetailsController'
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
    templateUrl: 'common/templates/surveys.details.search-results.html'
    controller: 'SearchResultsController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.search-results.details', {
    url: '/details'
    templateUrl: 'common/templates/surveys.details.search-results.details.html'
    controller: 'SearchResultController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches', {
    abstract: true
    url: '/searches'
    template: '<div ui-view></div>'
    controller: 'SearchesController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches.list', {
    url: '/list'
    templateUrl: 'common/templates/surveys.details.searches.list.html'
    controller: 'SearchesController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches.create', {
    url: '/create'
    templateUrl: 'common/templates/surveys.details.searches.create.html'
    controller: 'CreateSearchController'
    is_private: true
  }

  $stateProvider.state 'sign-in', {
    url: '/sign-in'
    templateUrl: 'common/templates/sign-in.html'
    controller: 'SignInController'
    is_private: false
  }

  $stateProvider.state 'sign-up', {
    url: '/sign-up'
    templateUrl: 'common/templates/sign-up.html'
    controller: 'SignUpController'
    is_private: false
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
