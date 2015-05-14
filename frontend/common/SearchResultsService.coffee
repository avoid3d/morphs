morphs = window.angular.module 'morphs'

morphs.service 'SearchResultsService', class SearchResultsService
  constructor: (@Restangular) ->
    
  get_search_results: (survey_id) =>
    return @Restangular.one('surveys', survey_id).all('search_results').getList()
