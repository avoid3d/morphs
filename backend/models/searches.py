from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from backend import db
from backend.models import Entity


class Search(db.Model, Entity):
  __tablename__ = 'searches'

  survey_id = Column(Integer, ForeignKey('surveys.id_'))
  #survey = relationship(Survey)

  name = Column(String)

  search_query = Column(String)
