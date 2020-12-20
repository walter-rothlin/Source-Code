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
from waltisLibrary import *

# Reusable Logger Class
# ---------------------
class WR_Logger:
    # Ctr (Konstruktor)
    # -----------------
    def __init__(self, fName, delimiter="|", headerStr=None, titleStr=None, withTimeStamp=True, withLevel=True, doVerbal=True, timeFormatString="nice", onlyChanges=False, ringbufferSize=-1, cWidth_TimeStamp = 22, cWidth_Level = 8):
        self.__fName = fName
        self.__delimiter = delimiter
        self.__withTimeStamp = withTimeStamp
        self.__withLevel = withLevel
        self.__doVerbal = doVerbal
        self.__timeFormatString = timeFormatString
        self.__onlyChanges = onlyChanges
        self.__ringbufferSize = ringbufferSize
        self.__cWidth_TimeStamp = cWidth_TimeStamp
        self.__cWidth_Level = cWidth_Level
        self.countOfLines = 0
        self.lastValues = ""
        if headerStr is None:
            headerStr = "# <Name>" + fName + "</Name>"

        preTitleStr = ""
        if self.__withTimeStamp:
            preTitleStr = ("{le:" + str(self.__cWidth_TimeStamp) + "s}").format(le="Timestamp") + self.__delimiter
        if self.__withLevel:
            preTitleStr += ("{le:" + str(self.__cWidth_Level) + "s}").format(le="Level") + self.__delimiter
        titleStr = preTitleStr + titleStr

        createNewFile = True
        if headerStr != "":
            self.addLogEntry(headerStr, doAppend=False, isHeader=True)
            createNewFile = True
        if titleStr != "":
            self.addLogEntry(titleStr, doAppend=createNewFile, isHeader=True)

    # toString()
    # ----------
    def __str__(self):
        retStr =  "fName             :" + self.__fName                  + "\n"
        retStr += "delimiter         :" + self.__delimiter              + "\n"
        retStr += "withTimeStamp     :" + str(self.__withTimeStamp)     + "\n"
        retStr += "withLevel         :" + str(self.__withLevel)         + "\n"
        retStr += "doVerbal          :" + str(self.__doVerbal)          + "\n"
        retStr += "onlyChanges       :" + str(self.__onlyChanges)       + "\n"
        retStr += "useRingbufferSize :" + str(self.__ringbufferSize)    + "\n"
        retStr += "Count of Lines    :" + str(self.countOfLines)        + "\n"
        return retStr

    # overload == (equal to) operator
    # -------------------------------
    def __eq__(self, anOtherLogger):
        return self.__fName == anOtherLogger.__fName

    # main business methods()
    # -----------------------
    def addLogEntry(self, aLogEntry, level="INFO", doAppend=True, isHeader=False):
        valueIsTheSame = False
        if self.lastValues == aLogEntry:
            valueIsTheSame = True
        self.lastValues = aLogEntry
        preEntry = ""
        if isHeader == False:
            if self.__withTimeStamp:
                preEntry = ("{le:" + str(self.__cWidth_TimeStamp) + "s}").format(le=getTimestamp(formatString=self.__timeFormatString)) + self.__delimiter
            if self.__withLevel:
                preEntry += ("{le:" + str(self.__cWidth_Level) + "s}").format(le=level) + self.__delimiter
        aLogEntry = preEntry + aLogEntry
        if self.__doVerbal:
            print(aLogEntry, end="")
        if not (self.__onlyChanges and valueIsTheSame):
            if self.__doVerbal:
                if not isHeader:
                    if self.__onlyChanges:
                        print("     Changed!", end="")
            if doAppend == False:
                f = open(self.__fName, "w")
            else:
                f = open(self.__fName, "a")
            self.countOfLines += 1
            f.write(aLogEntry + "\n")
            f.close()

        # Ringbuffer
        # ----------
        if self.__ringbufferSize > 0:
            fileSize = File_getCountOfLines(self.__fName)
            if fileSize > self.__ringbufferSize:
                File_deleteLines(self.__fName, deleteLineFrom=3, deleteLineTo=(fileSize-self.__ringbufferSize), verbal=True)

        if self.__doVerbal:
            print()

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
    if (len(sys.argv) >= 2):
        if (sys.argv[1] == "--cleanup"):
            cleanUp(file_path, city, max_logs_per_city)
            exit()

    doLoop = True

    while doLoop:
        logOneRequestResponse()
        time.sleep(pollingTime)

    # doStop = input("\nDrücke Enter um das Logging zu beenden: \n\n")
    # doLoop = False

    # t.join()
    print("\nLogging beendet")