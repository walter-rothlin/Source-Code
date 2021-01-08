# ------------------------------------------------------------------
# Name: WeatherLogger.py
#
# Description: Logges weather data received from a REST-Service (JSON)
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version (Polling REST Service and write values to console)
# ------------------------------------------------------------------

import requests
import json
import time

pollingTime = float(input("Polling-Time [s]:"))
doLoop = True
i = 0
while doLoop:
    responseStr = requests.get("http://api.openweathermap.org/data/2.5/weather?q=Munich&units=metric&lang=de&appid=144747fd356c86e7926ca91ce78ce170")
    jsonResponse = json.loads(responseStr.text)
    # print(jsonResponse, "\n\n")
    # print(jsonResponse['main'], "\n\n")
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    clouds = jsonResponse['weather'][0]['description']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']

    print(temp, pressure, humidity, clouds, lon, lat)
    i += 1
    time.sleep(pollingTime)
