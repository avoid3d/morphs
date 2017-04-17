import os, sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
import logging
from backend import create_app


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()
logger.setLevel(logging.INFO)
logger.info("Creating app for wsgi.")
logger.info("Logging at level: %s", logging.getLevelName(logger.level))

app = create_app()

