from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from backend import db
from backend.models import Entity


class SurveyField(db.Model, Entity):
  __tablename__ = 'survey_fields'
  survey_id = Column(Integer, ForeignKey('surveys.id_'))
  survey = relationship('Survey')

  label = Column(String)
  field_type = Column(String)