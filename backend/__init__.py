from flask import Flask

def create_app(environment='dev'):
  app = Flask(__name__)

  return app
