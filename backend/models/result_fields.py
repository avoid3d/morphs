from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from backend import db
from backend.models import Entity


class ResultField(db.Model, Entity):
  __tablename__ = 'result_fields'
  search_result_id = Column(Integer, ForeignKey('search_results.id_'))
  search_result = relationship('SearchResult')

  survey_field_id = Column(Integer, ForeignKey('survey_fields.id_'))
  survey_field = relationship('SurveyField')

