import logging
from backend.models import SearchResult
from backend.models import Image as ImageModel


logger = logging.getLogger()
logging.basicConfig(level=logging.INFO)

def done_scraping_image(search_result, success):
  if success:
    search_result.image_scraped_state = SearchResult.ImageScrapedStates.SUCCESS
  else:
    search_result.image_scraped_state = SearchResult.ImageScrapedStates.FAILURE

  db.session.add(search_result)
  db.session.commit()

def do_unscraped_image(unscraped_search_result):
  if not unscraped_search_result.link:
    logger.warn("Search result %s missing link." % unscraped_search_result)
    done_scraping_image(unscraped_search_result, success=False)
    return

  raw_image_response = requests.get(unscraped_search_result.link, timeout=10)
  if raw_image_response.status_code != 200:
    logger.warn("Search result %s image link %s returned non 200 response." % (unscraped_search_result, unscraped_search_result.link))
    done_scraping_image(unscraped_search_result, success=False)
    return

  raw_image_file = BytesIO(raw_image_response.content)

  image = Image.open(raw_image_file)
  image_file = BytesIO()
  image.save(image_file, 'JPEG')

  image_hash = imagehash.phash(image)

  image.thumbnail((500, 500), Image.ANTIALIAS)
  thumbnail_file = BytesIO()
  image.save(thumbnail_file, 'JPEG')

  unscraped_search_result.image = ImageModel(
    image_file=image_file.getvalue(),
    thumbnail_file=thumbnail_file.getvalue(),
    image_hash=str(image_hash),
  )

  done_scraping_image(unscraped_search_result, success=True)

def do_work():
  while True:
    unscraped_search_result = (SearchResult
      .query
      .filter(SearchResult.is_image_scraped==False)
      .first())

    if unscraped_search_result is None:
      sleep(5)
      continue
