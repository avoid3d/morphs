import os, sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

from flask.ext.script import Manager, Shell
from backend import create_app, db

app = create_app('dev')
manager = Manager(app)

@manager.command
def dedup():
  from backend.models import SearchResult, Search, Image
  search_results = SearchResult.query.filter(SearchResult.image_scraped_state == 'SUCCESS').limit(100).offset(10000).all()
  for search_result in search_results:
    duplicate_pool = (
      SearchResult.query
      .join(Image)
      .join(Search)
      .filter(Search.survey == search_result.search.survey)
      .filter(Image.image_hash == search_result.image.image_hash)
      .all()
    )
    print(search_result.id_, len(duplicate_pool))
  

@manager.command
def background_work():
	app = create_app('prod')
	from background_work import do_work
	do_work()

def _make_context():
    from backend.models import Survey, User, Session, SearchResult
    return dict(app=app, db=db, Survey=Survey, User=User, Session=Session, SearchResult=SearchResult)

manager.add_command("shell", Shell(make_context=_make_context))

@manager.command
def create_all():
  db.create_all()

@manager.command
def drop_all():
  db.drop_all()

@manager.command
def reload_database():
  drop_all()
  create_all()

if __name__ == "__main__":
    manager.run()
