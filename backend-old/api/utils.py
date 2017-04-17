import json
from functools import wraps
from flask.ext.restful import fields


def paginate_marshaller(m):
  return {
    'count': fields.Integer,
    'limit': fields.Integer,
    'offset': fields.Integer,
    'results': fields.Nested(m),
  }

def my_jsonify(f):
  @wraps(f)
  def wrapped(*args, **kwargs):
    raw = f(*args, **kwargs)
    return json.dumps(raw)
  return wrapped
