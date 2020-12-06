# ------------------------------------------------------------------
# Name: WeatherLogger.py
#
# Description: Logges weather data received from a REST-Service (JSON)
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version (Polling REST Service and write values to console)
# 04-Dec-2020   Walter Rothlin      Writes JSON Values to a text-file
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


fHandler = open(lofFilename, "w")
headerStr  = "# <Name>" + lofFilename + "</Name>\n"
headerStr += "Timestamp" + delimiter + "Level" + delimiter + "Temp" + delimiter + "Druck" + delimiter + "Feuchte"
print(headerStr)
fHandler.write(headerStr + "\n")
fHandler.close()


doLoop = True
while doLoop:
    responseStr = requests.get("http://api.openweathermap.org/data/2.5/weather?q=Munich&appid=144747fd356c86e7926ca91ce78ce170")
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
