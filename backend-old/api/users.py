import json
from functools import wraps
from flask import jsonify
from flask.ext.restful import marshal_with, fields, reqparse
from backend import db
from backend.api import api
from backend.models import Survey, User, Session, SurveyField
from utils import my_jsonify, paginate_marshaller


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
@marshal_with(paginate_marshaller(Survey.marshaller))
def get_users_surveys(user_id):
  users_surveys = Survey.query.filter(Survey.user_id==user_id).all()
  return {
    'results': users_surveys
  }

@api.route('/users/<int:user_id>/surveys', methods=['POST'])
@my_jsonify
@marshal_with(Survey.marshaller)
def user_create_survey(user_id):
  parser = reqparse.RequestParser()
  parser.add_argument('name', type=str)
  parser.add_argument('comments', type=str)
  parser.add_argument('fields', location='json', type=list)
  args = parser.parse_args()
  survey = Survey(
    user_id=user_id,
    name=args.name,
    comments=args.comments,
  )

  for survey_field_arg in args.fields:
    survey_field = SurveyField(
      survey=survey,
      label=survey_field_arg['label'],
      field_type=survey_field_arg['field_type'],
    )
    if 'options' in survey_field_arg:
      survey_field.options=json.dumps(survey_field_arg['options'])
    db.session.add(survey_field)
  db.session.add(survey)
  db.session.commit()
  return survey