@app.route('/surveys/<int:survey_id>')
def get_survey(user, survey_id):
  # joined load onto survey, search, survey_fields and search_results and survey_result_fields.
  survey = Survey.query.filter(Survey.id==survey_id).first()
  return survey