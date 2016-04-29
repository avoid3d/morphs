from flask.ext.restful import fields
from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import relationship
from backend import db
from backend.models import Entity


class Survey(db.Model, Entity):
  __tablename__ = 'surveys'

  marshaller = {
    'id_': fields.Integer,
    'name': fields.String,
    'comments': fields.String,
  }

  name = Column(String)
  comments = Column(String)

  user_id = Column(Integer, ForeignKey('users.id_'))
  user = relationship('User')

  searches = relationship('Search')
  search_results = relationship('SearchResult', secondary='searches', order_by='SearchResult.id_')
  
  fields = relationship('SurveyField')
