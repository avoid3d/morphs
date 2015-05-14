from flask.ext.restful import marshal_with, reqparse
from backend import db
from backend.api import api
from backend.models import Survey, SearchResult, Search

def my_jsonify(f):
  from functools import wraps
  import json
  @wraps(f)
  def wrapped(*args, **kwargs):
    raw = f(*args, **kwargs)
    return json.dumps(raw)
  return wrapped

@api.route('/surveys/<int:survey_id>')
@my_jsonify
@marshal_with(Survey.marshaller)
def get_survey(survey_id):
  # joined load onto survey, search, survey_fields and search_results and survey_result_fields.
  survey = Survey.query.filter(Survey.id_==survey_id).first()
  return survey

@api.route('/surveys/<int:survey_id>/search_results')
@my_jsonify
@marshal_with(SearchResult.marshaller)
def get_surveys_search_results(survey_id):
  survey = Survey.query.filter(Survey.id_==survey_id).first()
  return survey.search_results

@api.route('/surveys/<int:survey_id>/searches')
@my_jsonify
@marshal_with(Search.marshaller)
def get_surveys_searches(survey_id):
  survey = Survey.query.filter(Survey.id_==survey_id).first()
  return survey.searches

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