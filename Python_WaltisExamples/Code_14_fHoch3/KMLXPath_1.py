#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KMLXPath_1.py
#
# Description: Accesses a XML Document via xPath
# https://riptutorial.com/python/example/29019/searching-the-xml-with-xpath
# https://docs.python.org/3/library/xml.etree.elementtree.html
#
# Autor: Walter Rothlin
#
# History:
# 03-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from lxml import etree

data = """<link rel="index" href="/index.php" />
<link rel="contents" href="/getdata.php" />
<link rel="copyright" href="/blabla.php" />
<link rel="shortcut icon" href="/img/all/favicon.ico" />
"""

d = etree.HTML(data)

value = d.xpath('//link[@rel="shortcut icon"]/@href')
print(value)
