from sqlalchemy import Column, String
from backend import db
from backend.models import Entity


class User(db.Model, Entity):
  __tablename__ = 'users'
  
  username = Column(String)

  password_hash = Column(String)
  password_salt = Column(String)

  #surveys = relationship('Survey')
  #searches = relationship('Searches')

  def set_password(self, password):
    pass
