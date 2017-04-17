morphs = window.angular.module 'morphs'

morphs.service 'SearchesService', class SearchesService
  constructor: (@Restangular) ->

  get_search: (search_id) =>
  	return @Restangular.one('searches', search_id).get()
    
  get_searches: (survey_id) =>
    return @Restangular.one('surveys', survey_id).all('searches').getList()

  create_search: (survey_id, search_data) =>
    return @Restangular.one('surveys', survey_id).all('searches').post(search_data)
