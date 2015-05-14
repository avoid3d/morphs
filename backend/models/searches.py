from sqlalchemy import Column, Integer, String, ForeignKey
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
  }

  survey_id = Column(Integer, ForeignKey('surveys.id_'))

  name = Column(String)

  comments = Column(String)

  search_query = Column(String)
