from flask.ext.restful import fields
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from backend import db
from backend.models import Entity


class Tag(db.Model, Entity):
  __tablename__ = 'tags'
  marshaller = {
    'search_result_id': fields.Integer,
    'value': fields.String,
  }

  search_result_id = Column(Integer, ForeignKey('search_results.id_'))
  search_result = relationship('SearchResult')
  
  value = Column(String)