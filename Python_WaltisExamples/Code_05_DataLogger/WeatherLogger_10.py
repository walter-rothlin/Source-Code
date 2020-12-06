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
# ------------------------------------------------------------------

import requests
import json
import time
import datetime


def getTimestamp(preStr="", postStr="", formatString="nice"):
    formatStr = '{:%Y-%m-%d %H:%M:%S}'
    if (formatString == ""):
        formatStr = '{:%Y%m%d%H%M%S}'
    elif (formatString == "nice"):
        formatStr = '{:%Y-%m-%d %H:%M:%S}'
    else:
        formatStr = formatString
    retStr = formatStr.format(datetime.datetime.now())
    return preStr + retStr + postStr

class WR_Logger:
    # Ctr (Konstruktor)
    # -----------------
    def __init__(self, fName, delimiter="|", headerStr=None, titleStr=None, withTimeStamp=True, withLevel=True, doVerbal=True):
        self.fName = fName
        self.delimiter = delimiter
        self.withTimeStamp = withTimeStamp
        self.withLevel = withLevel
        self.doVerbal = doVerbal
        if headerStr is None:
            headerStr = "# <Name>" + fName + "</Name>"

        preTitleStr = ""
        if self.withTimeStamp:
            preTitleStr = "Timestamp" + self.delimiter
        if self.withLevel:
            preTitleStr += "Level" + self.delimiter
        titleStr = preTitleStr + titleStr

        createNewFile = True
        if headerStr != "":
            self.addLogEntry(headerStr, doAppend=False, isHeader=True)
            createNewFile = True
        if titleStr != "":
            self.addLogEntry(titleStr, doAppend=createNewFile, isHeader=True)


    def addLogEntry(self, aLogEntry, level="INFO", doAppend=True, isHeader=False):
        preEntry = ""
        if isHeader == False:
            if self.withTimeStamp:
                preEntry = getTimestamp() + self.delimiter
            if self.withLevel:
                preEntry += level + self.delimiter
        aLogEntry = preEntry + aLogEntry
        if self.doVerbal:
            print(aLogEntry)
        if doAppend == False:
            f = open(self.fName, "w")
        else:
            f = open(self.fName, "a")
        f.write(aLogEntry + "\n")
        f.close()



if __name__ == '__main__':
    pollingTime = float(input("Polling-Time [s]:"))
    delimiter = "|"
    restLogger = WR_Logger("weatherLog.txt", titleStr="Temp" + delimiter + "Druck" + delimiter + "Feuchte", delimiter=delimiter)

    doLoop = True
    while doLoop:
        responseStr = requests.get("http://api.openweathermap.org/data/2.5/weather?q=Munich&appid=144747fd356c86e7926ca91ce78ce170")
        jsonResponse = json.loads(responseStr.text)
        temp = jsonResponse['main']['temp']
        pressure = jsonResponse['main']['pressure']
        humidity = jsonResponse['main']['humidity']

        logStr = str(temp) + delimiter + str(pressure) + delimiter + str(humidity)
        restLogger.addLogEntry(logStr)
        time.sleep(pollingTime)
