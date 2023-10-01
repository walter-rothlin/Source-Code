# ------------------------------------------------------------------
# Name  : WeatherLogger.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_01.py
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
# 25-Oct-2022   Walter Rothlin      Abbruch der Polling-Schleife
# 29-Sep-2023   Walter Rothlin      Endpoint-URL
# ------------------------------------------------------------------
import datetime
import requests
import json
import time

def getTimestamp():
    return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())

end_point_url = "https://api.openweathermap.org/data/2.5/weather"
pollingTime = float(input("Polling-Time [s]:"))
ort = input("Ort  [*Uster]   :")
if ort == "":
    ort = 'Uster'

max_counter = int(input("Anzahl requests :"))

appId = "144747fd356c86e7926ca91ce78ce170"


firstTime = True
counter = 0
doLoop = True
while doLoop:
    counter += 1
    request_url = end_point_url + "?q=" + ort + "&units=metric&lang=de&appid=" + appId
    print("Request:\n", request_url, "\n\n") if firstTime else False
    response = requests.get(request_url)
    response_text = response.text
    response_json = json.loads(response_text)
    print("Response:\n", response_text, "\n\n") if firstTime else False
    print("Response:\n", response_text, "\n\n") if firstTime else False


    ortsname = response_json['name']
    land = response_json['sys']['country']
    temp = response_json['main']['temp']
    pressure = response_json['main']['pressure']
    humidity = response_json['main']['humidity']
    lon = response_json['coord']['lon']
    lat = response_json['coord']['lat']
    cloud = response_json['weather'][0]['description']
    windSpeed = response_json['wind']['speed']
    windDirection = response_json['wind']['deg']

    print(getTimestamp(), ": ", ortsname, "[", land, "]", "(", lon, "/", lat, ")      ", temp, "°C ", pressure, "mBar ", humidity, "% ", cloud, "  Wind:", windSpeed, "m/s ", windDirection, "° ", sep='')
    time.sleep(pollingTime)
    firstTime = False
    if counter >= max_counter:
        doLoop = False
