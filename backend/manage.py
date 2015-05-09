import os, sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

from flask.ext.script import Manager, Shell
from backend import create_app

app = create_app('dev')
manager = Manager(app)

def _make_context():
    from backend import db
    return dict(app=app, db=db)

manager.add_command("shell", Shell(make_context=_make_context))

if __name__ == "__main__":
    manager.run()
