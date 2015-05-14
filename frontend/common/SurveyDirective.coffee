morphs = window.angular.module 'morphs'


morphs.directive 'msSurvey', ->
  restrict: 'A' 
  templateUrl: 'common/templates/survey.html'
  scope: {
    survey: '='
    ctrl: '='
  }
