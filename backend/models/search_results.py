from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from flask.ext.restful import fields
from backend import db
from backend.models import Entity


class SearchResult(db.Model, Entity):
  __tablename__ = 'search_results'
  marshaller = {
    'id_': fields.Integer,
    'user_id': fields.Integer,
    'search_id': fields.Integer,
    'image_id': fields.Integer,
    'visible_link': fields.String,
    'direct_link': fields.String,
  }

  user_id = Column(Integer, ForeignKey('users.id_'))
  user = relationship('User')

  search_id = Column(Integer, ForeignKey('searches.id_'))
  search = relationship('Search')

  visible_link = Column(String)
  direct_link = Column(String)

  class ImageScrapedStates:
    NEW = 'NEW'
    STARTED = 'STARTED'
    SUCCESS = 'SUCCESS'
    FAILURE = 'FAILURE'

  image_scraped_state = Column(String, default='NEW')
  image_id = Column(Integer, ForeignKey('images.id_'))
  image = relationship('Image')

  result_fields = relationship('ResultField')
