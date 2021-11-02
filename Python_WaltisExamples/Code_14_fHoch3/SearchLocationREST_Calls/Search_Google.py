# ------------------------------------------------------------------
# Name: Search_Google.py
#
# Description: Does a search via REST request to google
#
# Autor: Walter Rothlin
#
# History:
# 01-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import requests
import json


# Google API:    https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Peterliwiese+33&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyDAKgrjrKNmBPu47TUFP-x8hY_jp2Ainbk
searchCriteria = "Peterliwiese+33"
appId = "AIzaSyDAKgrjrKNmBPu47TUFP-x8hY_jp2Ainbk"
serviceURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input={search:2s}&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key={appId:2s}"
requestStr = serviceURL.format(search=searchCriteria, appId=appId)
responseStr = requests.get(requestStr)
jsonResponse = json.loads(responseStr.text)
print("Request:\n", requestStr)
print("Response:\n", jsonResponse, "\n")
