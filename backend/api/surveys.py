import json
from flask.ext.restful import marshal_with, reqparse, fields
from sqlalchemy import func
from backend import db
from backend.api import api
from backend.models import Survey, SearchResult, Search, SurveyField, Tag
from utils import my_jsonify


m = {'fields': fields.Nested(SurveyField.marshaller)}
m.update(Survey.marshaller)
@api.route('/surveys/<int:survey_id>')
@my_jsonify
@marshal_with(m)
def get_survey(survey_id):
  # joined load onto survey, search, survey_fields and search_results and survey_result_fields.
  survey = Survey.query.filter(Survey.id_==survey_id).first()
  deserialized_fields = []
  for field in survey.fields:
    # Decode field.options if necessary.
    if field.options:
      field.options = json.loads(field.options)
    deserialized_fields.append(field)

  survey.fields = deserialized_fields
  return survey

@api.route('/surveys/<int:survey_id>/search_results')
@my_jsonify
@marshal_with(SearchResult.marshaller)
def get_surveys_search_results(survey_id):
  parser = reqparse.RequestParser()
  parser.add_argument('filter', type=str, default=None)
  args = parser.parse_args()

  query = (SearchResult.query
    .join(Search)
    .filter(Search.survey_id==survey_id)
  )

  args.filter = 'test field: green'

  if args.filter:
    query.join(Tag).filter(Tag.value==args.filter)

  return query.all()

@api.route('/surveys/<int:survey_id>/searches')
@my_jsonify
@marshal_with(Search.marshaller)
def get_surveys_searches(survey_id):
  searches = (Search.query
    .filter(Search.survey_id==survey_id)
    .all())
  return searches

@api.route('/surveys/<int:survey_id>/tags')
@my_jsonify
@marshal_with(Tag.marshaller)
def get_surveys_tags(survey_id):
  survey = Survey.query.filter(Survey.id_==survey_id).first()

  tags = Tag.query.join(SearchResult).join(Search).filter(Search.survey==survey).all()

  return tags

@api.route('/surveys/<int:survey_id>/searches', methods=['POST'])
@my_jsonify
@marshal_with(Search.marshaller)
def create_search(survey_id):
  parser = reqparse.RequestParser()
  parser.add_argument('name', str)
  parser.add_argument('comments', str)
  parser.add_argument('search_query', str)
  args = parser.parse_args()
  search = Search(
    survey_id=survey_id,
    name=args.name,
    comments=args.comments,
    search_query=args.search_query,
  )
  db.session.add(search)
  db.session.commit()
  return search