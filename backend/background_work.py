import socket
from io import BytesIO
from PIL import Image
import imagehash
import requests
import logging
import warnings
from time import sleep
from backend.models import SearchResult, Search
from backend.models import Image as ImageModel
from backend import db


logger = logging.getLogger()
logging.basicConfig(level=logging.INFO)

def done_scraping_image(search_result, success):
  if success:
    search_result.image_scraped_state = SearchResult.ImageScrapedStates.SUCCESS
  else:
    search_result.image_scraped_state = SearchResult.ImageScrapedStates.FAILURE

  db.session.add(search_result)
  db.session.commit()

def do_unscraped_search_result(unscraped_search_result):
  logger.info('Processing search_result %s' % unscraped_search_result.id_)
  if not unscraped_search_result.direct_link:
    logger.warn("Search result %s missing link." % unscraped_search_result)
    done_scraping_image(unscraped_search_result, success=False)
    return

  try:
    print(unscraped_search_result.id_)
    raw_image_response = requests.get(unscraped_search_result.direct_link, timeout=10)
  except requests.exceptions.RequestException, socket.timeout:
    logger.warn("Timout fetching image at url %s." % unscraped_search_result.direct_link)
    done_scraping_image(unscraped_search_result, success=False)
    return

  if raw_image_response.status_code != 200:
    logger.warn("Search result %s image link %s returned non 200 response." % (unscraped_search_result, unscraped_search_result.direct_link))
    done_scraping_image(unscraped_search_result, success=False)
    return

  raw_image_file = BytesIO(raw_image_response.content)

  warnings.simplefilter('error', Image.DecompressionBombWarning)
  try:
    image = Image.open(raw_image_file)

    image_hash = imagehash.phash(image)

    image = image.convert('RGB')
    image_file = BytesIO()
    image.save(image_file, 'JPEG')

    image.thumbnail((500, 500), Image.ANTIALIAS)
    thumbnail_file = BytesIO()
    image.save(thumbnail_file, 'JPEG')

    unscraped_search_result.image = ImageModel(
      image_file=image_file.getvalue(),
      thumbnail_file=thumbnail_file.getvalue(),
      image_hash=str(image_hash),
    )
  except (IOError, Image.DecompressionBombWarning) as _:
    logger.warn("Issue with PIL processing image.")
    done_scraping_image(unscraped_search_result, success=False)
    return

  duplicate_pool = (
    SearchResult.query
    .join(ImageModel)
    .join(Search)
    .filter(Search.survey == unscraped_search_result.search.survey)
    .filter(ImageModel.image_hash == unscraped_search_result.image.image_hash)
    .all()
  )

  if (len(duplicate_pool) > 1):
      logger.warn("Removing duplicate: %s" % unscraped_search_result)
      db.session.delete(unscraped_search_result)
      db.session.commit()
  else:
    done_scraping_image(unscraped_search_result, success=True)

def do_work():
  while True:
    from  sqlalchemy.sql.expression import func

    unscraped_search_result = (SearchResult
      .query
      .filter(SearchResult.image_scraped_state=='NEW')
      .order_by(func.random())
      .first())


    if unscraped_search_result is None:
      sleep(5)
      logger.info('Done processing.')
      continue

    do_unscraped_search_result(unscraped_search_result)
