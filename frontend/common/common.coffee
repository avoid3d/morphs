morphs = window.angular.module 'morphs', [
  'ui.router',
  'restangular',
  'nav',
]

morphs.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl 'http://localhost:5000'

morphs.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  $stateProvider.state 'surveys', {
    url: '/'
    templateUrl: 'common/templates/surveys.html'
    controller: 'SurveysController'
    is_private: true
  }

  $stateProvider.state 'sign_in', {
    url: '/sign-in'
    templateUrl: 'common/templates/sign-in.html'
    controller: 'SignInController'
    is_private: false
  }

morphs.run ($rootScope, $state, UserService) ->
  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    if (toState.is_private and not UserService.is_signed_in)
      # Prevent the existing state change so that we can start a new one.
      event.preventDefault()
      $state.go 'sign_in'
