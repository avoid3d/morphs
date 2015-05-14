from functools import wraps
from flask import jsonify
from flask.ext.restful import marshal_with, fields, reqparse
from backend import db
from backend.api import api
from backend.models import Survey, User, Session

def my_jsonify(f):
  import json
  @wraps(f)
  def wrapped(*args, **kwargs):
    raw = f(*args, **kwargs)
    return json.dumps(raw)
  return wrapped

@api.route('/users', methods=["POST"])
@my_jsonify
@marshal_with({'user': fields.Nested(User.marshaller), 'session': fields.Nested(Session.marshaller)})
def sign_up():
  parser = reqparse.RequestParser()
  parser.add_argument('email_address')
  parser.add_argument('password')
  args = parser.parse_args()

  user = User(email_address=args.email_address)
  user.set_password(args.password)
  db.session.add(user)

  session = user.create_new_session()
  db.session.add(session)

  db.session.commit()

  return {'user': user, 'session': session}

@api.route('/users/<int:user_id>/surveys')
@my_jsonify
@marshal_with(Survey.marshaller)
def get_users_surveys(user_id):
  users_surveys = Survey.query.filter(Survey.user_id==user_id).all()
  return users_surveys

@api.route('/users/<int:user_id>/surveys', methods=['POST'])
@my_jsonify
@marshal_with(Survey.marshaller)
def user_create_survey(user_id):
  parser = reqparse.RequestParser()
  parser.add_argument('name', str)
  parser.add_argument('comments', str)
  args = parser.parse_args()
  survey = Survey(
    user_id=user_id,
    name=args.name,
    comments=args.comments,
  )
  db.session.add(survey)
  db.session.commit()
  return survey