from sqlalchemy import Column, String
from sqlalchemy.orm import relationship
from flask.ext.restful import fields
from backend import db
from backend.models import Entity, Session


class User(db.Model, Entity):
  __tablename__ = 'users'

  marshaller = {'id_': fields.Integer, 'email_address': fields.String}
  
  email_address = Column(String)

  password_hash = Column(String)
  password_salt = Column(String)

  surveys = relationship('Survey')
  searches = relationship('Search', secondary="surveys")

  def set_password(self, password):
    self.password_hash = password

  def has_password(self, password):
    return self.password_hash == password

  def create_new_session(self):
    session = Session(user=self)
    return session
