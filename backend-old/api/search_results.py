from flask.ext.restful import marshal_with, fields, reqparse, marshal
from backend import db
from backend.models import SearchResult, ResultField, SurveyField, Tag, Search
from backend.api import api
from utils import my_jsonify


@api.route('/search_results/<int:search_result_id>')
@my_jsonify
def get_search_result(search_result_id):
  # joined load onto image, tags, survey and survey_result_fields.
  search_result = SearchResult.query.filter(SearchResult.id_==search_result_id).first()
  marshaller = SearchResult.marshaller

  field_values = {}
  field_values_marshaller = {}
  for result_field in search_result.result_fields:
    field_values[result_field.survey_field.label] = result_field.value
    field_values_marshaller[result_field.survey_field.label] = fields.String

  marshaller['field_values'] = fields.Nested(field_values_marshaller)
  marshaller['search'] = fields.Nested(Search.marshaller)

  search_result.field_values = field_values
  return marshal(search_result, marshaller)

@api.route('/search_results/<int:search_result_id>', methods=['PATCH'])
@my_jsonify
@marshal_with(SearchResult.marshaller)
def update_search_result(search_result_id):
  parser = reqparse.RequestParser()
  parser.add_argument('completion_state', type=str)
  parser.add_argument('field_values', location='json', type=dict, default={})
  args = parser.parse_args()

  search_result = SearchResult.query.filter(SearchResult.id_==search_result_id).first()
  search_result.completion_state = args.completion_state
  survey = search_result.search.survey

  for field_label, field_value in args.field_values.iteritems():
    survey_field = (SurveyField.query
      .filter(SurveyField.label==field_label)
      .filter(SurveyField.survey==survey)
      .first()
    )
    result_field = (ResultField.query
      .join(SurveyField)
      .filter(SurveyField.survey==survey_field)
      .filter(SurveyField.label==field_label)
      .first()
    )
    if result_field is None:
      result_field = ResultField(
        search_result=search_result,
        survey_field=survey_field,
      )
    result_field.value = field_value

    db.session.add(result_field)

  search_result.update_tags()

  db.session.add(search_result)
  db.session.commit()

  return search_result
