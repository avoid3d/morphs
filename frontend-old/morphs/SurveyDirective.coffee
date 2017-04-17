morphs = window.angular.module 'morphs'


morphs.directive 'msSurvey', ->
  restrict: 'A' 
  templateUrl: 'morphs/templates/survey.html'
  scope: {
    survey: '='
    searchResult: '='
    ctrl: '='
    saving: '='
    showComments: '='
  }
