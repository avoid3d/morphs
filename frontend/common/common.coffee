morphs = window.angular.module 'morphs', [
  'ui.router',
  'restangular',
  'nav',
]

morphs.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  $stateProvider.state 'surveys', {
    url: '/'
    templateUrl: 'common/templates/surveys.html'
    controller: 'SurveysController'
  }
