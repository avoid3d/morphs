import os, sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))


from flask.ext.script import Manager
from backend import create_app

app = create_app('dev')
manager = Manager(app)

if __name__ == "__main__":
    manager.run()
