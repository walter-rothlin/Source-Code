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

while True:
    responseStr = requests.get("https://api.openweathermap.org/data/2.5/weather?q=Munich&units=metric&lang=de&appid=144747fd356c86e7926ca91ce78ce170")
    jsonResponse = json.loads(responseStr.text)

    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']

    print(temp, pressure, humidity, lon, lat, cloud)
    time.sleep(pollingTime)
