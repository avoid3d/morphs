def get_search_result(user, search_result_id):
  # joined load onto image, tags, survey and survey_result_fields.
  search_result = SearchResult.query.filter(SearchResult.id_==search_result_id).first()