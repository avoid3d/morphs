from sqlalchemy import Column, Integer, String, ForeignKey
from flask.ext.restful import fields
from backend import db
from backend.models import Entity


class SearchResult(db.Model, Entity):
  __tablename__ = 'search_results'
  marshaller = {
     'user_id': fields.Integer,
     'search_id': fields.Integer,
     'image_id': fields.Integer,
     'visible_link': fields.String,
     'direct_link': fields.String,
  }

  user_id = Column(Integer, ForeignKey('users.id_'))
  #user = relationship(user)

  search_id = Column(Integer, ForeignKey('searches.id_'))
  #search = relationship(search)

  visible_link = Column(String)
  direct_link = Column(String)

  image_id = Column(Integer, ForeignKey('images.id_'))
  #image = relationship()

  #result_fields = relationship(result_fields)
