from sqlalchemy import Column, Integer, String, ForeignKey
from backend import db
from backend.models import Entity


class SearchResult(db.Model, Entity):
  __tablename__ = 'search_results'
  # marshaller = {
  #   user_id:,
  #   search_id:,
  #   image_id:,
  #   visible_link:,
  #   direct_link:,
  # }

  user_id = Column(Integer, ForeignKey('users.id_'))
  #user = relationship(user)

  search_id = Column(Integer, ForeignKey('searches.id_'))
  #search = relationship(search)

  visible_link = Column(String)
  direct_link = Column(String)

  image_id = Column(Integer, ForeignKey('images.id_'))
  #image = relationship()

  #result_fields = relationship(result_fields)
