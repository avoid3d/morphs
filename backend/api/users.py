from flask import jsonify
from flask.ext.restful import marshal_with
from backend.api import api
from backend.models import Survey

def my_jsonify(f):
  import json
  def wrapped(*args, **kwargs):
    raw = f(*args, **kwargs)
    return json.dumps(raw)
  return wrapped

@api.route('/users/<int:user_id>/surveys')
@my_jsonify
@marshal_with(Survey.marshaller)
def get_users_surveys(user_id):
  users_surveys = Survey.query.filter(Survey.user_id==user_id).all()
  return users_surveys
