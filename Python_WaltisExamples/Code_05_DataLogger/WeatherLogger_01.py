# ------------------------------------------------------------------
# Name: WeatherLogger.py
#
# Description: Polling REST Service and write values to console
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version ()
# 10-Oct-2021   Walter Rothlin      Adapted for BWI-A20
# ------------------------------------------------------------------

import requests
import json
import time

pollingTime = float(input("Polling-Time [s]:"))
serviceURL = "https://api.openweathermap.org/data/2.5/weather"
appId = "144747fd356c86e7926ca91ce78ce170"
while True:
    responseStr = requests.get(serviceURL + "?q=Uster&units=metric&lang=de&appid=" + appId)
    jsonResponse = json.loads(responseStr.text)

    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']

    print(temp, pressure, humidity, lon, lat, cloud)
    time.sleep(pollingTime)
