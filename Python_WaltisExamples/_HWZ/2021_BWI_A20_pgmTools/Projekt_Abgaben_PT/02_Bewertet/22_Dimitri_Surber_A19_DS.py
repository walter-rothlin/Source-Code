# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Reference-Applikation mit User-Input
#      - Schreibt nur ERROR
#      - Kein Titel mit creation timestamp im Header und XML Syntax
#
# Class Design und Implementation:
#      + Eigene Klassen vorhanden
#      - Notwendige (__eq__) Methoden nicht implementiert
#      + __init__ wichtige Parameter vorhanden
#      + Default-Werte
#      - Einige Instance Variablen sind public
#      + OnlyChanges implementiert
#      + Ringbuffer implementiert (Eine Zeile zuviel)
#      - Einigen Methoden könnten private (startlog) oder private static sein (bessere encapsulation)
#      + Exceptionhandling in der Klasse oder in der Applikation
#
# Test:
#      - keine Reusable Tests implementiert
#
# Note: 5.0
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wo haben Sie den Ringbuffer implementiert
#    Wo haben Sie den ChangeOnly Mode implementiert
# ------------------------------------------------------------------
import json
import requests
import time
import datetime

# timestmapy
def getTimestamp(preString="", postString="", formatStringing="nice"):
    formatString = '{:%Y-%m-%d %H:%M:%S}'
    if (formatStringing == ""):
        formatString = '{:%Y%m%d%H%M%S}'
    elif (formatStringing == "nice"):
        formatString = '{:%Y-%m-%d %H:%M:%S}'
    else:
        formatString = formatStringing
    retString = formatString.format(datetime.datetime.now())
    return preString + retString + postString


class GLogger24:
    # constructor
    def __init__(self, fileName, delimiter="|", timeFormatStringing="nice", newFile=True, hasTimeStamp=True, headerString=None, titleString=None,  onlyChanges=False, columnWidth_TimeStamp = 22):
        self.__fileName = fileName
        self.__delimiter = delimiter
        self.__hasTimeStamp = hasTimeStamp
        self.__timeFormatStringing = timeFormatStringing
        self.__onlyChanges = onlyChanges
        self.__newFile = newFile
        self.countOfLines = 0
        self.lastValues = ""
        if headerString is None:
            headerString = "#" + fileName

        preTitleString = ""
        if self.__hasTimeStamp:
            preTitleString = ("{le:20s}").format(le="Timestamp") + self.__delimiter

        preTitleString += ("{le:7s}").format(le="Level") + self.__delimiter

        titleString = preTitleString + titleString


        if headerString != "":
            self.addLog(headerString, append=False, isHeader=True)
            self.__newFile = True
        if titleString != "":
            self.addLog(titleString, append=self.__newFile, isHeader=True)

    def __str__(self):
        retString =  "FileName         :" + self.__fileName              + "\n"
        retString += "delimiter     :" + self.__delimiter          + "\n"
        retString += "hasTimeStamp :" + str(self.__hasTimeStamp) + "\n"
        retString += "onlyChanges   :" + str(self.__onlyChanges)   + "\n"
        retString += "Count of Lines:" + str(self.countOfLines)    + "\n"
        return retString



    # add loggy entry
    def addLog(self, logEntry, level="INFO", append=True, isHeader=False):
        valueIsTheSame = False
        if self.lastValues == logEntry:
            valueIsTheSame = True
        self.lastValues = logEntry
        preEntry = ""
        if isHeader == False:
            preEntry = ("{le:20s}").format(le=getTimestamp(formatStringing=self.__timeFormatStringing)) + self.__delimiter
            preEntry += ("{le:7s}").format(le=level) + self.__delimiter

        logEntry = preEntry + logEntry
        print(logEntry, end="")
        if not (self.__onlyChanges and valueIsTheSame):
            if not isHeader:
                if self.__onlyChanges:
                    print(" ––– Update –––", end="")
            if append == False:
                file = open(self.__fileName, "w")
            else:
                file = open(self.__fileName, "a")
            self.countOfLines += 1
            file.write(logEntry + "\n")
            file.close()

        print()


if __name__ == '__main__':
    apiKey = "0f66fd90e1e27bbd3669bf5f856ff5ab"
    URL = "http://api.openweathermap.org/data/2.5/weather"
    delimiter = "|"
    decimals = 2
    deafultInterval = 5
    weatherAttributes = {
        "Humidity": {"field": "humidity", "columnWidth": max(len("Humidity"), 0)},
        "Temperature":    {"field": "temp",     "columnWidth": max(len("Temperature"), 7)},
        "Pressure":   {"field": "pressure", "columnWidth": max(len("Pressure"),   7)}
    }

    customAPIKey = input("api Key (apiKey):")
    if customAPIKey == "":
        customAPIKey = apiKey

    location = input("Location (Zurich):")
    if location == "":
        location = "Zurich"
    #define the get parameters for the api
    payload = {'q': location, 'appid': customAPIKey}

    interval = input("Interval in seconds (" + str(deafultInterval) + "):")
    if interval == "":
        interval = deafultInterval
    interval = float(interval)

    logOnlyChanges = input("Log changes only [y]:")
    if (logOnlyChanges == "") or (logOnlyChanges == "y")  or (logOnlyChanges == "y") or (logOnlyChanges == "yes"):
        logOnlyChanges = True
    else:
        logOnlyChanges = False


    print("API:", URL)
    print("Interval:", interval)
    print("logOnlyChanges:", logOnlyChanges)

    #add header
    title = ""
    formatStringValues = ""
    for attribute in weatherAttributes:
        title += ("{pl:" + str(weatherAttributes[attribute]["columnWidth"]) + "s}").format(pl=attribute) + delimiter
    loggy = GLogger24("log.txt", titleString=title, delimiter=delimiter, onlyChanges=logOnlyChanges)

    #make it log forever & ever & ever until computer goes boom because infinite loops are fun shoutout to cupertino
    infiniteLoop = True
    while infiniteLoop:
        response = requests.get(URL, params=payload)

        jsonResponse = json.loads(response.text)

        if(jsonResponse['cod']):
            loggy.addLog("", "ERROR")
        else:
            logEntry = ""
            for attribute in weatherAttributes:
                formatValues = "{value:" + str(weatherAttributes[attribute]["columnWidth"]) + "." + str(decimals) + "f}"
                attributeValue = jsonResponse['main'][weatherAttributes[attribute]["field"]]
                logEntry += formatValues.format(value=attributeValue) + delimiter

                loggy.addLog(logEntry)
        time.sleep(interval)
