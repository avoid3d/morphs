import json
import unicodecsv
from flask import send_file
from flask.ext.restful import marshal_with, reqparse, fields
from sqlalchemy import func
from backend import db
from backend.api import api
from backend.models import Survey, SearchResult, Search, SurveyField, Tag
from utils import my_jsonify, paginate_marshaller
from io import BytesIO

@api.route('/surveys/<int:survey_id>/export-results')
def get_survey_results(survey_id):
  #TODO: joinedload .fields, .search_results and
  # search_result.result_fields and use a local cache
  # of survey_fields to get survey_field.label by id.
  survey = Survey.query.filter(Survey.id_==survey_id).first()

  field_names = ['morphic_id', 'completion_state']
  for field in survey.fields:
      label = field.label
      if field.field_type == 'location':
          label += " (lat, lon)"
      field_names.append(label.encode('utf-8'))
  field_names += ['search_name', 'search_query', 'visible_link', 'direct_link']

  f = BytesIO()

  writer = unicodecsv.DictWriter(f, field_names, encoding='utf-8')
  writer.writeheader()

  for search_result in survey.search_results:
    d = {
        'morphic_id': search_result.id_,
        'completion_state': search_result.completion_state,
        'search_name': search_result.search.name,
        'search_query': search_result.search.search_query,
        'visible_link': search_result.visible_link.encode('utf-8'),
        'direct_link': search_result.direct_link.encode('utf-8'),
    }
    for result_field in search_result.result_fields:
      label = result_field.survey_field.label
      value = result_field.value
      if result_field.survey_field.field_type == 'location':
          location_dict = json.loads(value)
          value = '%s, %s' % (location_dict['latitude'], location_dict['longitude'])
          label += " (lat, lon)"

      d[label.encode('utf-8')] = value.encode('utf-8')
    writer.writerow(d)

  f.seek(0)

  return send_file(f, mimetype='text/csv')


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
@marshal_with(paginate_marshaller(SearchResult.marshaller))
def get_surveys_search_results(survey_id):
  parser = reqparse.RequestParser()
  parser.add_argument('filter', type=str, default=None)
  parser.add_argument('per_page', type=int, default=60)
  parser.add_argument('page', type=int, default=1)
  args = parser.parse_args()

  offset = args.per_page*args.page - args.per_page

  search_results_query = (SearchResult.query
    .join(Search)
    .filter(Search.survey_id==survey_id)
    .order_by(SearchResult.id_)
  )

  if args.filter:
    search_results_query = (search_results_query
      .join(Tag)
      .filter(Tag.value==args.filter)
    )

  return {
    'count': search_results_query.count(),
    'results': (search_results_query
      .limit(args.per_page)
      .offset(offset)
      .all()
    ),
    'offset': offset,
    'limit': args.per_page,
  }

@api.route('/surveys/<int:survey_id>/searches')
@my_jsonify
@marshal_with(paginate_marshaller(Search.marshaller))
def get_surveys_searches(survey_id):
  searches = (Search.query
    .filter(Search.survey_id==survey_id)
    .all())
  return {
    'results': searches
  }

@api.route('/surveys/<int:survey_id>/tags')
@my_jsonify
@marshal_with(paginate_marshaller(Tag.marshaller))
def get_surveys_tags(survey_id):
  survey = Survey.query.filter(Survey.id_==survey_id).first()

  tags = Tag.query.join(SearchResult).join(Search).filter(Search.survey==survey).all()

  seen = {tag.value for tag in tags}

  return {'results': [Tag(value=value) for value in seen]}

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
