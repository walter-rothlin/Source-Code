#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : WeatherLogger_05.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_05.py
#
# Description: Logs weather data received from a REST-Service (JSON)
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version (Polling REST Service and write values to console)
# 04-Dec-2020   Walter Rothlin      Writes JSON Values to a text-file
# 25-Sep-2023   Walter Rothlin      Changes for HBU / RPI
# ------------------------------------------------------------------

import requests
import json
import time
import datetime


def getTimestamp(preStr = "", postStr="", formatString="nice"):
    formatStr = '{:%Y-%m-%d %H:%M:%S}'
    if (formatString == ""):
        formatStr = '{:%Y%m%d%H%M%S}'
    elif (formatString == "nice"):
        formatStr = '{:%Y-%m-%d %H:%M:%S}'
    else:
        formatStr = formatString
    retStr = formatStr.format(datetime.datetime.now())
    return preStr + retStr + postStr

lofFilename = "weatherLog.txt"
delimiter = "|"
pollingTime = float(input("Polling-Time [s]           :"))
ort_wetterstation = input("Ort                        :")
language = input("Sprache [de,el,en,fr,hr,it]:")
if language == '':
    language = 'de'
if ort_wetterstation == '':
    ort_wetterstation = 'Wangen+SZ'

url_end_point = "http://api.openweathermap.org/data/2.5/weather"
params_end_point = {
    'q': ort_wetterstation,
    'appid': '144747fd356c86e7926ca91ce78ce170',
    'mode': '',          # xml, html
    'units': 'metric',   # standard, metric, imperial
    'lang': language,        # de, el (Greek), en (English), fr (French), hr (Croatian), it (Italien)
}


responseStr = requests.get(url_end_point, params=params_end_point)
jsonResponse = json.loads(responseStr.text)

coord = jsonResponse['coord']
print(jsonResponse)
print(coord)
print(jsonResponse['weather'][0])

fHandler = open(lofFilename, "w")
headerStr  = "# <Config><Ort>" + ort_wetterstation + "</Ort><Lon>" + str(coord['lon']) + "</Lon><Lat>" + str(coord['lat']) + "</Lat><FName>" + lofFilename + "</FName></Config>\n"
headerStr += "Timestamp" + delimiter + "Level" + delimiter + "Temp [°C] " + delimiter + "Druck [mBar]" + delimiter + "Feuchte [%]" + delimiter + "Bezeichnung [" + language + "]" + delimiter + "Beschreibung [" + language + "]"
print(headerStr)
fHandler.write(headerStr + "\n")
fHandler.close()


doLoop = True
while doLoop:
    responseStr = requests.get(url_end_point, params=params_end_point)
    jsonResponse = json.loads(responseStr.text)
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    bezeichnung = jsonResponse['weather'][0]['main']
    beschreibung = jsonResponse['weather'][0]['description']

    logStr = getTimestamp() + delimiter +  "INFO" + delimiter + str(temp) + delimiter + str(pressure) + delimiter + str(humidity) + delimiter + bezeichnung + delimiter + beschreibung
    print(logStr)

    fHandler = open(lofFilename, "a")
    fHandler.write(logStr + "\n")
    fHandler.close()

    time.sleep(pollingTime)
