# ------------------------------------------------------------------
# Name: CH_Adress_search.py
#
# Description: Does a search via REST request to geo.admin (JSON), tel.search (XML) and google
#
# Autor: Walter Rothlin
#
# History:
# 14-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import requests
from rich import print
import json
from lxml import etree
import xml.etree.ElementTree as ET
import time

doTrace = False
resultsFound = 10000

def getResults_geoAdmin(searchCriteriaEncoded, doTrace = False):
    serviceURL = "https://api3.geo.admin.ch/1912100956/rest/services/ech/SearchServer?sr=2056&searchText={search:2s}&lang=en&type=locations"
    appId = ""
    requestStr = serviceURL.format(search=searchCriteriaEncoded)
    responseStr = requests.get(requestStr)
    jsonResponse = json.loads(responseStr.text)
    # print("Request:\n", requestStr) if doTrace else False
    # print("Response:\n", jsonResponse, "\n") if doTrace else False
    returnJSON = {'criteria' : searchCriteriaEncoded,
                  'count' : int(len(jsonResponse['results'])),
                  'results' : []}

    recNr = 1
    # print("Parsed values (Records found:{recCount:2d}):".format(recCount=len(jsonResponse['results'])))
    for entry in jsonResponse['results']:
        details = entry['attrs']['detail']
        lon = entry['attrs']['lon']
        lat = entry['attrs']['lat']
        x = entry['attrs']['x']
        y = entry['attrs']['y']
        details = {'details' : details,
                   'longitude' : lon,
                   'latitude' : lat,
                   'ch_x' : x,
                   'ch_y' : y}
        returnJSON['results'].append(details)
        print("\nRecord No: ", recNr) if doTrace else False
        print("  detail  :", details) if doTrace else False
        print("  lon     :", lon) if doTrace else False
        print("  lat     :", lat) if doTrace else False
        print("  x       :", x) if doTrace else False
        print("  y       :", y) if doTrace else False
        recNr += 1
    return returnJSON

def getFieldFromTelSearchXML(searchCH_Entry, namespaces, fieldname="type"):
    try:
        retVal = searchCH_Entry.find(fieldname, namespaces).text
    except AttributeError:
        retVal = ""
    return retVal

def getResults_search_ch(searchCriteriaEncoded, doTrace = False):
    appId = "8e8a84fd0f10d3b44920e49bc3b06a37"
    serviceURL = "https://tel.search.ch/api/?q={search:2s}&key={appId:2s}"
    requestStr = serviceURL.format(search=searchCriteriaEncoded, appId=appId)
    responseStr = requests.get(requestStr).content
    print("Request:\n", requestStr)  # if doTrace else False
    # print("Response:\n", responseStr, "\n\n\n")  if doTrace else False


    namespaces = {'tel': 'http://tel.search.ch/api/spec/result/1.0/',
                  'openSearch': 'http://a9.com/-/spec/opensearchrss/1.0/'} # add more as needed
    dom = ET.fromstring(responseStr)
    countFound = int(dom.find('{http://a9.com/-/spec/opensearchrss/1.0/}totalResults').text)
    returnJSON = {'criteria' : searchCriteriaEncoded,
                  'count' : countFound,
                  'results' : []}
    dom = etree.HTML(responseStr)
    value = dom.xpath('//entry')
    print("  Elements found  :", len(value)) if doTrace else False

    for aEntry in value:
        entryType = getFieldFromTelSearchXML(aEntry, namespaces, "type")
        name = getFieldFromTelSearchXML(aEntry, namespaces, "name")
        subname = getFieldFromTelSearchXML(aEntry, namespaces, "subname")
        firstname = getFieldFromTelSearchXML(aEntry, namespaces, "firstname")
        street = getFieldFromTelSearchXML(aEntry, namespaces, "street")
        streetno = getFieldFromTelSearchXML(aEntry, namespaces, "streetno")
        zip = getFieldFromTelSearchXML(aEntry, namespaces, "zip")
        city = getFieldFromTelSearchXML(aEntry, namespaces, "city")
        canton = getFieldFromTelSearchXML(aEntry, namespaces, "canton")
        country = getFieldFromTelSearchXML(aEntry, namespaces, "country")
        telNr = getFieldFromTelSearchXML(aEntry, namespaces, "telNr")
        content = getFieldFromTelSearchXML(aEntry, namespaces, "content")
        details = {'entryType': entryType,
                   'name' : name,
                   'subname' : subname,
                   'firstname': firstname,
                   'street' : street,
                   'streetno': streetno,
                   'zip': zip,
                   'city': city,
                   'canton' : canton,
                   'country': country,
                   'telNr': telNr,
                   'content': content
                  }
        returnJSON['results'].append(details)

        print("  aEntry  :", aEntry) if doTrace else False
        print("  Content :\n", content) if doTrace else False
        print("  telNr   :", telNr) if doTrace else False
        print("  Zip     :", zip) if doTrace else False
        print()

    return returnJSON


while resultsFound > 1:
    searchCriteria = input("Suchkriterium:")
    if len(searchCriteria) == 0:
        print("Application stopped!")
        break

    searchCriteriaEncoded = searchCriteria.replace(" ", "%20")
    results = getResults_geoAdmin(searchCriteriaEncoded, False)
    resultsFoundInMapGeoAdmin = results['count']
    print("Records found with geo.admin.ch:{recCount:2d}".format(recCount=resultsFoundInMapGeoAdmin))
    print(json.dumps(results, indent=4))

    results = getResults_search_ch(searchCriteriaEncoded, False)
    resultsFoundInTelSearch = results['count']
    print("Records found with search.ch   :{recCount:2d}".format(recCount=resultsFoundInTelSearch))
    print(json.dumps(results, indent=4))

    if resultsFoundInTelSearch == 1 and resultsFoundInMapGeoAdmin == 1:
        print("====>>   Combine results <<======")
