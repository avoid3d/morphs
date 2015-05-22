morphs = window.angular.module 'morphs'

morphs.service 'SearchResultsService', class SearchResultsService
  constructor: (@Restangular) ->
    
  get_search_results: (survey_id, filter, page) =>
    return @Restangular.one('surveys', survey_id).all('search_results').getList({filter: filter, page: page})

  get_search_result: (search_result_id) =>
    return @Restangular.one('search_results', search_result_id).get()
    
  update_search_result: (search_result_id, search_result) =>
    return @Restangular.one('search_results', search_result_id).patch(search_result)

  get_tags: (survey_id) =>
    return @Restangular.one('surveys', survey_id).all('tags').getList()