# ------------------------------------------------------------------
# Name: 01a_Search_TelSearch.py
#
# Description: Does a search via REST request to tel.search (XML)
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_14_fHoch3/SearchLocationREST_Calls/01a_Search_TelSearch.py
#
# Autor: Walter Rothlin
#
# History:
# 01-Nov-2021   Walter Rothlin      Initial Version
# 02-Jul-2024   Walter Rothlin      Changes for BWI-A21
# ------------------------------------------------------------------
import requests
from lxml import etree
import xml.etree.ElementTree as ET


# search.ch: https://tel.search.ch/api/?q=Walter%20Rothlin%208855&key=8e8a84fd0f10d3b44920e49bc3b06a37
# API:  https://tel.search.ch/api/help
searchCriteria = "Rothlin%208855"
appId = "8e8a84fd0f10d3b44920e49bc3b06a37"
serviceURL = "https://tel.search.ch/api/?q={search:2s}&key={appId:2s}"
requestStr = serviceURL.format(search=searchCriteria, appId=appId)
responseStr = requests.get(requestStr).content

print("Request:\n", requestStr)
print("Response:\n", responseStr, "\n\n\n")


namespaces = {'tel': 'http://tel.search.ch/api/spec/result/1.0/',
              'openSearch': 'http://a9.com/-/spec/opensearchrss/1.0/'} # add more as needed

print("Parsed values:")

# https://docs.python.org/2/library/xml.etree.elementtree.html#parsing-xml-with-namespaces
dom = ET.fromstring(responseStr)
print("Root:", dom.tag, "(", dom.attrib, ")")
for child in dom:
    print("     Child:", child.tag, "   (", child.attrib, ")")
print("title     :", dom.find('{http://www.w3.org/2005/Atom}title').text)
print("totResults:", dom.find('{http://a9.com/-/spec/opensearchrss/1.0/}totalResults').text)


print("\n\nvia XPath:")

dom = etree.HTML(responseStr)
value = dom.xpath('//entry')
print("  Elements found  :", len(value))

for aEntry in value:
    telNr = aEntry.find("phone", namespaces).text
    zip = aEntry.find("zip", namespaces).text
    content = aEntry.find("content", namespaces).text
    print("  aEntry  :", aEntry)
    print("  Content :\n   ", content)
    print("  telNr   :", telNr)
    print("  Zip     :", zip)
    print()


