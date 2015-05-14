from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from flask.ext.restful import fields
from backend import db
from backend.models import Entity


class Session(db.Model, Entity):
  __tablename__ = 'sessions'
  marshaller = {'id_': fields.Integer}

  user_id = Column(Integer, ForeignKey('users.id_'))
  user = relationship('User')
