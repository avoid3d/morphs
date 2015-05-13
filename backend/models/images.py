from backend import db
from backend.models import Entity


class Image(db.Model, Entity):
  __tablename__ = 'images'
