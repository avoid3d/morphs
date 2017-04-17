nav = window.angular.module 'nav', []

nav.directive 'mNav', ->
  restrict: 'E'
  templateUrl: 'nav/templates/nav.html'
