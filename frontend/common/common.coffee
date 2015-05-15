morphs = window.angular.module 'morphs', [
  'ui.router',
  'ui.bootstrap',
  'ipCookie',
  'restangular',
  'nav',
]

morphs.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl 'http://localhost:5000'

morphs.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/surveys/list'

  $stateProvider.state 'surveys', {
    abstract: 'true'
    template: '<div ui-view></div'
    is_private: true
  }

  $stateProvider.state 'surveys.list', {
    url: '/surveys/list'
    templateUrl: 'common/templates/list-surveys.html'
    controller: 'SurveysController'
  }

  $stateProvider.state 'surveys.create', {
    url: '/surveys/create'
    templateUrl: 'common/templates/create-survey.html'
    controller: 'CreateSurveyController'
  }

  $stateProvider.state 'surveys.details', {
    abstract: true
    url: '/surveys/:survey_id'
    templateUrl: 'common/templates/survey-details.html'
    controller: 'SurveyDetailsController'
  }

  $stateProvider.state 'surveys.details.search-results', {
    abstract: true
    url: '/search-results'
    template: '<div ui-view></div'
  }

  $stateProvider.state 'surveys.details.search-results.list', {
    url: '/list'
    templateUrl: 'common/templates/surveys.details.search-results.html'
    controller: 'SearchResultsController'
  }

  $stateProvider.state 'surveys.details.search-results.details', {
    url: '/details'
    templateUrl: 'common/templates/surveys.details.search-results.details.html'
    controller: 'SearchResultController'
  }

  $stateProvider.state 'surveys.details.searches', {
    abstract: true
    url: '/searches'
    template: '<div ui-view></div>'
    controller: 'SearchesController'
  }

  $stateProvider.state 'surveys.details.searches.list', {
    url: '/list'
    templateUrl: 'common/templates/surveys.details.searches.list.html'
    controller: 'SearchesController'
  }

  $stateProvider.state 'surveys.details.searches.create', {
    url: '/create'
    templateUrl: 'common/templates/surveys.details.searches.create.html'
    controller: 'CreateSearchController'
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
