#!/bin/python

# START------------------------------------------------------------------------
# Author:        Walter Rothlin
# Description:   getAlertDetails
#
#
# Calling:       getAlertDetails.py
# REST service to get more details about a mailing adress pattern (Peterliwiese 33 8855 --> Walter Rothlin Peterliwiese 33 8855 Wangen SZ +41 55 460 14 40 47 47.1723 / 8.8674
# History:
# 04-Mar-2020    V1.0   Walter Rothlin	Initial Version
#
# END--------------------------------------------------------------------------

import requests 

print("HTTP/1.1 200 OK")
print("Access-Control-Allow-Origin: *")
print("Content-type: application/json\n")

# api-endpoint 
URL = "http://maps.googleapis.com/maps/api/geocode/json"
URL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${address}&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyDAKgrjrKNmBPu47TUFP-x8hY_jp2Ainbk"
 
# location given here 
location = "delhi technological university"
  
# defining a params dict for the parameters to be sent to the API 
# PARAMS = {'address':location} 
  
# sending get request and saving the response as response object 
r = requests.get(url = URL, params = PARAMS) 
  
# extracting data in json format 
data = r.json() 
  
  
# extracting latitude, longitude and formatted address  
# of the first matching location 
latitude = data['results'][0]['geometry']['location']['lat'] 
longitude = data['results'][0]['geometry']['location']['lng'] 
formatted_address = data['results'][0]['formatted_address'] 
  
# printing the output 
print("Latitude:%s\nLongitude:%s\nFormatted Address:%s"
      %(latitude, longitude,formatted_address)) 
