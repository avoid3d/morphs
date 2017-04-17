import re
from urllib import unquote
from lxml.cssselect import CSSSelector
from lxml.etree import HTML, tostring


class GoogleImagesSERPParser(object):
  def __init__(self):
    self.link_re = re.compile(r'.*?imgres\?imgurl=(.*?)&imgrefurl')
    self.visible_link_re = re.compile(r'.*?imgrefurl=(.*?)&')

  def double_unquote(self, double_quoted_string):
    return unquote(unquote(double_quoted_string))

  def parse_serp(self, html):
    elements = HTML(html)
    container = CSSSelector('div#isr_mc')(elements)[0]
    results = CSSSelector('div.rg_di')(container)

    for result in results:
      result_containers = CSSSelector('a.rg_l')(result)
      if not result_containers:
        continue

      result_container = result_containers[0]
      result_href = result_container.get('href')
      if not result_href:
        continue

      double_quoted_link = self.link_re.match(result_href).group(1)
      link = self.double_unquote(double_quoted_link)

      double_quoted_visible_link = self.visible_link_re.match(result_href).group(1)
      visible_link = self.double_unquote(double_quoted_visible_link)

      yield link, visible_link



