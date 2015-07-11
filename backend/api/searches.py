from backend.models import Search
from backend.api import api
from flask.ext.restful import marshal_with
from utils import my_jsonify


@api.route('/searches/<int:search_id>')
@my_jsonify
@marshal_with(Search.marshaller)
def get_search(search_id):
  search = Search.query.filter(Search.id_ == search_id).first()
  return search
