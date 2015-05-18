import json
from functools import wraps


def my_jsonify(f):
  @wraps(f)
  def wrapped(*args, **kwargs):
    raw = f(*args, **kwargs)
    return json.dumps(raw)
  return wrapped
