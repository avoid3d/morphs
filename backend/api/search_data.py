from flask import abort
from flask.ext.restful import reqparse
from backend import db
from backend.api import api
from backend.models import User, Search, SearchResult
from google_images_serp_parser import GoogleImagesSERPParser


@api.route('/upload-google-results', methods=['POST'])
def upload_search_data():
  parser = reqparse.RequestParser()
  parser.add_argument('morphic_id', type=int)
  parser.add_argument('html')
  args = parser.parse_args()

  search = Search.query.filter(Search.id_==args.morphic_id).first()

  if search is None:
    abort(404)

  serp_parser = GoogleImagesSERPParser()

  for link, visible_link in serp_parser.parse_serp(args.html):
    search_result = SearchResult(
      direct_link=unicode(link, 'utf-8'),
      visible_link=unicode(visible_link, 'utf-8'),
      search=search,
    )
    db.session.add(search_result)

  search.are_results_uploaded = True

  db.session.add(search)
  db.session.commit()

  return 'OK', 200