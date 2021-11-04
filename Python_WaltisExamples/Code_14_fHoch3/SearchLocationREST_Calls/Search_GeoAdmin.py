# ------------------------------------------------------------------
# Name: Search_GeoAdmin.py
#
# Description: Does a search via REST request to geo.admin (JSON)
#
# Autor: Walter Rothlin
#
# History:
# 01-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import requests
import json

searchCriteria = "Peterliwiese%203"

# map.geo.admin: https://api3.geo.admin.ch/1912100956/rest/services/ech/SearchServer?sr=2056&searchText=Peterliwiese%2033&lang=en&type=locations
# API: https://api3.geo.admin.ch/services/sdiservices.html
serviceURL = "https://api3.geo.admin.ch/1912100956/rest/services/ech/SearchServer?sr=2056&searchText={search:2s}&lang=en&type=locations"
appId = ""
requestStr = serviceURL.format(search=searchCriteria)
responseStr = requests.get(requestStr)
jsonResponse = json.loads(responseStr.text)
print("Request:\n", requestStr)
print("Response:\n", jsonResponse, "\n")
recNr = 1
print("Parsed values (Records found:{recCount:2d}):".format(recCount=len(jsonResponse['results'])))
for entry in jsonResponse['results']:
    print("\nRecord No: ", recNr)
    print("  detail  :", entry['attrs']['detail'])
    print("  lon     :", entry['attrs']['lon'])
    print("  lat     :", entry['attrs']['lat'])
    recNr += 1

print("-----------------------------------------------------------------")