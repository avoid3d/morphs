from flask.ext.restful import fields
from sqlalchemy import Column, Integer, ForeignKey, String
from sqlalchemy.orm import relationship
from backend import db
from backend.models import Entity


class ResultField(db.Model, Entity):
  __tablename__ = 'result_fields'
  marshaller = {
    'search_result_id': fields.Integer,
    'survey_field_id': fields.Integer,
    'value': fields.String,
  }
  search_result_id = Column(Integer, ForeignKey('search_results.id_'))
  search_result = relationship('SearchResult')

  survey_field_id = Column(Integer, ForeignKey('survey_fields.id_'))
  survey_field = relationship('SurveyField')

  value = Column(String)