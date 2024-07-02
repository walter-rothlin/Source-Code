# ------------------------------------------------------------------
# Name: 01b_Search_TelSearch.py
#
# Description: Does a search via REST request to tel.search (XML)
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_14_fHoch3/SearchLocationREST_Calls/01bSearch_TelSearch.py
#
# Autor: Walter Rothlin
#
# Usefull links:
#   search.ch: https://tel.search.ch/api/?q=Walter%20Rothlin%208855&key=8e8a84fd0f10d3b44920e49bc3b06a37
#   API:  https://tel.search.ch/api/help
#   XML-Paser: https://docs.python.org/2/library/xml.etree.elementtree.html#parsing-xml-with-namespaces
#
#
#
# History:
# 01-Nov-2021   Walter Rothlin      Initial Version
# 02-Jul-2024   Walter Rothlin      Changes for BWI-A21
# 02-Jul-2024   Walter Rothlin      Put it in a function
# ------------------------------------------------------------------
import requests
from lxml import etree
import xml.etree.ElementTree as ET

def search_tel_search_ch(search_criteria="Rothlin+8855", verbal=True):
    appId = "8e8a84fd0f10d3b44920e49bc3b06a37"
    request_url = f"https://tel.search.ch/api/?q={search_criteria}&key={appId}"
    responseStr = requests.get(request_url).content

    if verbal:
        print("Request:\n", request_url)
        print("Response:\n", responseStr, "\n\n\n")


    namespaces = {'tel': 'http://tel.search.ch/api/spec/result/1.0/',
                  'openSearch': 'http://a9.com/-/spec/opensearchrss/1.0/'} # add more as needed

    # print("Parsed values:")


    dom = ET.fromstring(responseStr)
    # print("Root:", dom.tag, "(", dom.attrib, ")")
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
        type = aEntry.find("type", namespaces).text
        lastname = aEntry.find("name", namespaces).text
        if type == 'Person':
            firstname = aEntry.find("firstname", namespaces).text
        else:
            firstname = ''
        category = aEntry.find("category", namespaces)
        print(category)
        street = aEntry.find("street", namespaces).text
        street_no = aEntry.find("streetno", namespaces).text
        zip = aEntry.find("zip", namespaces).text
        city = aEntry.find("city", namespaces).text
        canton = aEntry.find("canton", namespaces).text
        country = aEntry.find("country", namespaces).text


        print("  aEntry   :", aEntry)
        print("  Content  :\n   ", content)
        print("  Type     :", type)
        print("  category     :", category)
        print("  Name     :", lastname)
        print("  Firstname:", firstname)
        print("  Street   :", street)
        print("  Street_No:", street_no)
        print("  Zip      :", zip)
        print("  City     :", city)
        print("  Canton   :", canton)
        print("  Country  :", country)
        print("  telNr    :", telNr)
        print("  Zip      :", zip)
        print()


search_tel_search_ch()
