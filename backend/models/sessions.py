from backend import db
from backend.models import Entity


class Session(db.Model, Entity):
  __tablename__ = 'sessions'
