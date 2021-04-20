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
# 05-Dec-2020   Walter Rothlin      first Version of Logger class
# 06-Dec-2020   Walter Rothlin      Spaltebreite und Felder dynamisch / with option onlyChanges
# 07-Dec-2020   Walter Rothlin      Added Ringbuffer
# 17-Dec-20202  Walter Rothlin      Extended weather request parameter (lat=%s&lon=%s&units=metric)
# Open points:
#      log-file cleanup
#      XPath mässiges Parsen einer JSON Struktur
#      csv module: https://docs.python.org/3/library/csv.html
# ------------------------------------------------------------------
import requests
import json
import time
import datetime
from Class_WR_Logger import *
from waltisLibrary import *


# =============
# HAUPTPROGRAMM
# =============
if __name__ == '__main__':

    # config items
    # ------------
    delimiter = "|"
    nachkommaStellen = 2
    appId = "appid=144747fd356c86e7926ca91ce78ce170"
    baseURL = "http://api.openweathermap.org/data/2.5/weather?units=metric&"
    deafultPolllingTime = 1
    defaultRingbufferSize = -1
    weatherFields = {
        "Feuchte": {"field": "humidity", "cWidth": max(len("Feuchte") + 1, 0)},
        "Temp":    {"field": "temp",     "cWidth": max(len("Temp") + 2,    7)},
        "Druck":   {"field": "pressure", "cWidth": max(len("Druck") + 1,   7)}
    }

    # User settings
    # -------------
    place = input("Place (*Munich):")
    if place == "":
        place = "Munich"
    restURL = baseURL + "q=" + place + "&" + appId

    pollingTime = input("Polling-Time (*" + str(deafultPolllingTime) + ") [s]:")
    if pollingTime == "":
        pollingTime = deafultPolllingTime
    pollingTime = float(pollingTime)

    ringbufferSize = input("RingbufferSize (*" + str(defaultRingbufferSize) + "):")
    if ringbufferSize == "":
        ringbufferSize = defaultRingbufferSize
    else:
        ringbufferSize = int(ringbufferSize)

    logOnlyChanges = input("Log only changes [*y/n]:")
    if (logOnlyChanges == "") or (logOnlyChanges == "y")  or (logOnlyChanges == "y"):
        logOnlyChanges = True
    else:
        logOnlyChanges = False


    print("restURL       :", restURL)
    print("pollingTime   :", pollingTime)
    print("logOnlyChanges:", logOnlyChanges)
    print("ringbufferSize:", ringbufferSize)
    print()

    # add header and title
    # --------------------
    titleStr = ""
    formatStrValues = ""
    for aKey in weatherFields:
        titleStr += ("{pl:" + str(weatherFields[aKey]["cWidth"]) + "s}").format(pl=aKey) + delimiter
    restLogger = WR_Logger("weatherLog.txt", titleStr=titleStr, delimiter=delimiter, onlyChanges=logOnlyChanges, ringbufferSize=ringbufferSize)
    print(restLogger)

    def logOneRequestResponse():
        level = ""
        response = requests.get(restURL)
        if response.status_code >= 100 and response.status_code <= 199:
            level = "INFO"
        elif response.status_code >= 200 and response.status_code <= 299:
            level = "DEBUG"
        elif response.status_code >= 300 and response.status_code <= 399:
            level = "WARNING"
        elif response.status_code >= 400 and response.status_code <= 499:
            level = "ERROR"
        elif response.status_code >= 500 and response.status_code <= 599:
            level = "CRITICAL"
        jsonResponse = json.loads(response.text)
        logEntryStr = ""
        for aKey in weatherFields:
            formatStrValues = "{vl:" + str(weatherFields[aKey]["cWidth"]) + "." + str(nachkommaStellen) + "f}"
            aValue = jsonResponse['main'][weatherFields[aKey]["field"]]
            logEntryStr += formatStrValues.format(vl=aValue) + delimiter
        restLogger.addLogEntry(logEntryStr, level=level)


    # Main polling loop
    # -----------------
    doLoop = True
    while doLoop:
        logOneRequestResponse()
        time.sleep(pollingTime)

    # doStop = input("\nDrücke Enter um das Logging zu beenden: \n\n")
    # doLoop = False

    # t.join()
    print("\nLogging beendet")