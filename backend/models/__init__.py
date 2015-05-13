from sqlalchemy import Column, Integer
from backend import db


class Entity(object):
  id_ = Column(Integer, primary_key=True)

from sessions import Session
from users import User
from surveys import Survey
from tags import Tag
from survey_fields import SurveyField
from searches import Search
from images import Image
from search_results import SearchResult
from result_fields import ResultField
