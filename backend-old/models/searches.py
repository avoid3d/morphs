from sqlalchemy import Column, Integer, String, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from flask.ext.restful import fields
from backend import db
from backend.models import Entity


class Search(db.Model, Entity):
  __tablename__ = 'searches'
  marshaller = {
    'id_': fields.Integer,
    'name': fields.String,
    'comments': fields.String,
    'search_query': fields.String,
    'are_results_uploaded': fields.Boolean,
  }

  are_results_uploaded = Column(Boolean, default=False) 

  survey_id = Column(Integer, ForeignKey('surveys.id_'))
  survey = relationship('Survey')

  results = relationship('SearchResult')

  name = Column(String)

  comments = Column(String)

  search_query = Column(String)
