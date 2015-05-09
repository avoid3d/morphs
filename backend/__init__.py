from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy

db = SQLAlchemy

def create_app(environment='dev'):
  app = Flask(__name__)

  db.init_app(app)

  return app
