from flask import Flask, request
from flask.ext.sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def add_cors(response):
  response.headers['Access-Control-Allow-Origin'] = request.headers.get('Origin', '*')
  response.headers['Access-Control-Allow-Credentials'] = 'true'
  response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization,Morphs-Handle-Errors-Generically'
  response.headers['Access-Control-Allow-Methods'] = 'PUT,DELETE,PATCH'
  return response

def create_app(environment='dev'):
  app = Flask(__name__)

  app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://morphs:dontlook@localhost:5432/prod'
  app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024


  db.init_app(app)

  from backend.api import api
  app.after_request(add_cors)

  app.register_blueprint(api)

  return app
