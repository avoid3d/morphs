users = window.angular.module 'users', []

users.config ($stateProvider) ->
  $stateProvider.state 'sign-in', {
    url: '/sign-in'
    templateUrl: 'users/templates/sign-in.html'
    controller: 'SignInController'
    is_private: false
  }

  $stateProvider.state 'sign-up', {
    url: '/sign-up'
    templateUrl: 'users/templates/sign-up.html'
    controller: 'SignUpController'
    is_private: false
  }

