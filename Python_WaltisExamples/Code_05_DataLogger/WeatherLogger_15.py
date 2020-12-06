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
#
# Open points: Ringbuffer, log-file cleanup
# ------------------------------------------------------------------
import requests
import json
import time
import datetime

# Common functions
# ----------------
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

# Reusable Logger Class
# ---------------------
class WR_Logger:
    # Ctr (Konstruktor)
    # -----------------
    def __init__(self, fName, delimiter="|", headerStr=None, titleStr=None, withTimeStamp=True, withLevel=True, doVerbal=True, timeFormatString="nice", onlyChanges=False, cWidth_TimeStamp = 22, cWidth_Level = 8):
        self.__fName = fName
        self.__delimiter = delimiter
        self.__withTimeStamp = withTimeStamp
        self.__withLevel = withLevel
        self.__doVerbal = doVerbal
        self.__timeFormatString = timeFormatString
        self.__onlyChanges = onlyChanges
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
        retStr =  "fName         :" + self.__fName              + "\n"
        retStr += "delimiter     :" + self.__delimiter          + "\n"
        retStr += "withTimeStamp :" + str(self.__withTimeStamp) + "\n"
        retStr += "withLevel     :" + str(self.__withLevel)     + "\n"
        retStr += "doVerbal      :" + str(self.__doVerbal)      + "\n"
        retStr += "onlyChanges   :" + str(self.__onlyChanges)   + "\n"
        retStr += "Count of Lines:" + str(self.countOfLines)    + "\n"
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
    baseURL = "http://api.openweathermap.org/data/2.5/weather?"
    deafultPolllingTime = 9
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

    logOnlyChanges = input("Log only changes [*y/n]:")
    if (logOnlyChanges == "") or (logOnlyChanges == "y")  or (logOnlyChanges == "y"):
        logOnlyChanges = True
    else:
        logOnlyChanges = False


    print("restURL       :", restURL)
    print("pollingTime   :", pollingTime)
    print("logOnlyChanges:", logOnlyChanges)
    print()

    # add header and title
    # --------------------
    titleStr = ""
    formatStrValues = ""
    for aKey in weatherFields:
        titleStr += ("{pl:" + str(weatherFields[aKey]["cWidth"]) + "s}").format(pl=aKey) + delimiter
    restLogger = WR_Logger("weatherLog.txt", titleStr=titleStr, delimiter=delimiter, onlyChanges=logOnlyChanges)

    # Main polling loop
    # -----------------
    doLoop = True
    while doLoop:
        responseStr = requests.get(restURL)
        jsonResponse = json.loads(responseStr.text)

        logEntryStr = ""
        for aKey in weatherFields:
            formatStrValues = "{vl:" + str(weatherFields[aKey]["cWidth"]) + "." + str(nachkommaStellen) + "f}"
            aValue = jsonResponse['main'][weatherFields[aKey]["field"]]
            logEntryStr += formatStrValues.format(vl=aValue) + delimiter

        restLogger.addLogEntry(logEntryStr)
        time.sleep(pollingTime)
