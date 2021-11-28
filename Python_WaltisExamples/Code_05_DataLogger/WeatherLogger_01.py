# ------------------------------------------------------------------
# Name: WeatherLogger.py
#
# Description: Polling REST Service and write values to console
# https://openweathermap.org/current
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version ()
# 10-Oct-2021   Walter Rothlin      Adapted for BWI-A20
# 28-Nov-2021   Walter Rothlin      Changed URL-encoding und request URL Parameter Uebergabe
# ------------------------------------------------------------------
import datetime
import requests
import json
import time

def getTimestamp():
    return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())

serviceURL = "https://api.openweathermap.org/data/2.5/weather"
pollingTime = float(input("Polling-Time [s]:"))
ort = input("Ort  [*Uster]   :")
if ort == "":
    ort = 'Uster'

appId = "144747fd356c86e7926ca91ce78ce170"


firstTime = True
while True:
    requestStr = serviceURL + "?q=" + ort + "&units=metric&lang=de&appid=" + appId
    print("Request:\n", requestStr, "\n\n") if firstTime else False
    responseStr = requests.get(requestStr)
    print("Response:\n", responseStr.text, "\n\n") if firstTime else False

    jsonResponse = json.loads(responseStr.text)

    ortsname = jsonResponse['name']
    land = jsonResponse['sys']['country']
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']
    windSpeed = jsonResponse['wind']['speed']
    windDirection = jsonResponse['wind']['deg']

    print(getTimestamp(), ": ", ortsname, "[", land, "]", "(", lon, "/", lat, ")      ", temp, "°C ", pressure, "mBar ", humidity, "% ", cloud, "  Wind:", windSpeed, "m/s ", windDirection, "° ", sep='')
    time.sleep(pollingTime)
    firstTime = False
