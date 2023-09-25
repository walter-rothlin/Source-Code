#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 05_01_weather_logger.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/05_01_weather_logger.py
#
# Description: Wetterdaten Logger
#
# Autor: Walter Rothlin
#
# History:
# 18-Sep-2023   Walter Rothlin      Initial Version
#
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
pollingTime = float(input("Polling-Time [s]:"))
ort_wetterstation = input("Ort             :")
if ort_wetterstation == '':
    ort_wetterstation = 'Wangen+SZ'

url_request   = "http://api.openweathermap.org/data/2.5/weather?q=Munich&appid=144747fd356c86e7926ca91ce78ce170"
url_end_point = "http://api.openweathermap.org/data/2.5/weather"
params_end_point = {
    'q': ort_wetterstation,
    'appid': '144747fd356c86e7926ca91ce78ce170',
    'mode': '',         # xml, html
    'units': 'metric',  # standard, metric, imperial
}


fHandler = open(lofFilename, "w")
headerStr  = "# <Config><Ort>" + ort_wetterstation + "</Ort><FName>" + lofFilename + "</FName></Config>\n"
headerStr += "Timestamp" + delimiter + "Level" + delimiter + "Temp [°C] " + delimiter + "Druck [mBar]" + delimiter + "Feuchte [%]"
print(headerStr)
fHandler.write(headerStr + "\n")
fHandler.close()


doLoop = True
while doLoop:
    # responseStr = requests.get(url_request)
    responseStr = requests.get(url_end_point, params=params_end_point)
    jsonResponse = json.loads(responseStr.text)
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']

    logStr = getTimestamp() + delimiter +  "INFO" + delimiter + str(temp) + delimiter + str(pressure) + delimiter + str(humidity)
    print(logStr)

    fHandler = open(lofFilename, "a")
    fHandler.write(logStr + "\n")
    fHandler.close()

    time.sleep(pollingTime)