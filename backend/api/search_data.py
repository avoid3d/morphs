from flask import abort
from flask.ext.restful import reqparse
from backend import db
from backend.api import api
from backend.models import User, Search, SearchResult
import json


@api.route('/upload-google-results', methods=['POST'])
def upload_search_data():
  parser = reqparse.RequestParser()
  parser.add_argument('morphic_id', type=int)
  parser.add_argument('results')
  args = parser.parse_args()

  search = Search.query.filter(Search.id_==args.morphic_id).first()

  if search is None:
    abort(404)

  for result in json.loads(args.results):
    search_result = SearchResult(
      direct_link=result['image_link'],
      visible_link=result['visible_link'],
      search=search,
    )
    db.session.add(search_result)

  search.are_results_uploaded = True

  db.session.add(search)
  db.session.commit()

  return 'OK', 200
