# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und User Input ist möglich
#      - Unsinnige User-Eingaben können zum Absturz führen
#      - Runden nicht implementiert
#      - kein Timestamp im Header
#
# Class Design und Implementation:
#      - Funktionen ohne Declaration via Cut/Past übernommen
#
# Test:
#      - Keine Test implementiert
#
# Note: 4.0 (Ohne Declaration der Source Core Part des Codes kopiert!!)
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wo wird unterschieden zwischen changesOnly True/False?
# ------------------------------------------------------------------
# ---
# Diverse Imports
# ---
import requests
import json
import time
import datetime

# ---
# Zeitstempel ermitteln
# ---
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

# ---
# LogFile: Anzahl Zeilen ermitteln
# ---
def File_getCountOfLines(sourceFileFN):
    lines = []
    with open(sourceFileFN, "r") as f:
        lines = f.readlines()
    return len(lines)

# ---
# LogFile: Zeilen löschen
# ---
def File_deleteLines(sourceFileFN, destinationFileFN=None, deleteLineFrom=None, deleteLineTo=None, verbal=False):
    if destinationFileFN is None:
        destinationFileFN = sourceFileFN

    if (deleteLineFrom is None) and (deleteLineTo is None):
        deleteLineFrom = 0
        deleteLineTo = 0
    elif (deleteLineFrom is not None) and (deleteLineTo is None):
        deleteLineTo = 1000000
    elif (deleteLineFrom is None) and (deleteLineTo is not None):
        deleteLineFrom = 0
    else:
        pass

    if verbal:
        print("    Delete from", deleteLineFrom, "to", deleteLineTo, end="")
    with open(sourceFileFN, "r") as f:
        lines = f.readlines()

    with open(destinationFileFN, "w") as f:
        i = 1
        for line in lines:
            if (i < deleteLineFrom) or (i > deleteLineTo):
                f.write(line)
            i += 1

# -------------
# Logger-Klasse
# -------------
class TempLogger:
    def __init__(self, fName, delimiter="|", headerStr=None, titleStr=None, withTimeStamp=True, withLevel=True, doVerbal=True, timeFormatString="nice", onlyChanges=False, IntervallTime=-1, SpaltenBreiteZeitstempel = 22, SpaltenBreiteLevel = 8):
        self.File = fName
        self.__trennzeichen = delimiter
        self.__withTimeStamp = withTimeStamp
        self.__withLevel = withLevel
        self.__doVerbal = doVerbal
        self.__timeFormatString = timeFormatString
        self.__onlyChanges = onlyChanges
        self.__IntervallTime = IntervallTime
        self.__SpaltenBreiteZeitstempel = SpaltenBreiteZeitstempel
        self.__SpaltenBreiteLevel = SpaltenBreiteLevel
        self.countOfLines = 0
        self.lastValues = ""
        if headerStr is None:
            headerStr = "# <Name>" + fName + "</Name>"

        preTitleStr = ""
        if self.__withTimeStamp:
            preTitleStr = ("{le:" + str(self.__SpaltenBreiteZeitstempel) + "s}").format(le="Timestamp") + self.__trennzeichen
        if self.__withLevel:
            preTitleStr += ("{le:" + str(self.__SpaltenBreiteLevel) + "s}").format(le="Level") + self.__trennzeichen
        titleStr = preTitleStr + titleStr

        createNewFile = True
        if headerStr != "":
            self.addLogEntry(headerStr, doAppend=False, isHeader=True)
            createNewFile = True
        if titleStr != "":
            self.addLogEntry(titleStr, doAppend=createNewFile, isHeader=True)

    # ***********************
    # Logeintrag erstellen
    # ***********************
    def addLogEntry(self, aLogEntry, level="INFO", doAppend=True, isHeader=False):
        valueIsTheSame = False
        if self.lastValues == aLogEntry:
            valueIsTheSame = True
        self.lastValues = aLogEntry
        preEntry = ""
        if isHeader == False:
            if self.__withTimeStamp:
                preEntry = ("{le:" + str(self.__SpaltenBreiteZeitstempel) + "s}").format(le=getTimestamp(formatString=self.__timeFormatString)) + self.__trennzeichen
            if self.__withLevel:
                preEntry += ("{le:" + str(self.__SpaltenBreiteLevel) + "s}").format(le=level) + self.__trennzeichen
        aLogEntry = preEntry + aLogEntry
        if self.__doVerbal:
            print(aLogEntry, end="")
        if not (self.__onlyChanges and valueIsTheSame):
            if self.__doVerbal:
                if not isHeader:
                    if self.__onlyChanges:
                        print("  !!Geändert!! ", end="")
            if doAppend == False:
                f = open(self.File, "w")
            else:
                f = open(self.File, "a")
            self.countOfLines += 1
            f.write(aLogEntry + "\n")
            f.close()

        # ----------
        # Ringbuffer
        # ----------
        if self.__IntervallTime > 0:
            fileSize = File_getCountOfLines(self.File)
            if fileSize > self.__IntervallTime:
                File_deleteLines(self.File, deleteLineFrom=3, deleteLineTo=(fileSize-self.__IntervallTime), verbal=True)

        if self.__doVerbal:
            print()

# ---
# Programmstart (Main)
# ---
if __name__ == '__main__':
    # ---
    # Default-Parameter
    # ---
    delimiter = "|"
    nachkommaStellen = 2
    appId = "59bae50ff236898589edffa75046e810"
    baseURL = "http://api.openweathermap.org/data/2.5/weather?"
    deafultPolllingTime = 1
    defaultRingbufferSize = -1
    weatherFields = {
        "Feuchte": {"field": "humidity", "cWidth": max(len("Feuchte") + 10, 0)},
        "Temp":    {"field": "temp",     "cWidth": max(len("Temp") + 10,    7)},
        "Druck":   {"field": "pressure", "cWidth": max(len("Druck") + 10,   7)}
    }

    # ---
    # Default-Einstellungen definieren
    # ---
    ortschaft = input("Ortschaft (Default: Zürich):")
    if ortschaft == "":
        ortschaft = "Zürich"

    payload = {"q": ortschaft, "appid": appId}

    pollingZeit = input("Polling-Zeit (Default: " + str(deafultPolllingTime) + ") [s]:")
    if pollingZeit == "":
        pollingZeit = deafultPolllingTime
    pollingZeit = float(pollingZeit)

    IntervallTime = input("Intervall (Default: " + str(defaultRingbufferSize) + "):")
    if IntervallTime == "":
        IntervallTime = defaultRingbufferSize
    else:
        IntervallTime = int(IntervallTime)

    logOnlyChanges = input("Nur Änderungen loggen [j/n]:")
    if (logOnlyChanges == "") or (logOnlyChanges == "j")  or (logOnlyChanges == "j"):
        logOnlyChanges = True
    else:
        logOnlyChanges = False

    # ---
    # File erstellen/vorbereiten
    # ---
    titleStr = ""
    formatStrValues = ""
    for aKey in weatherFields:
        titleStr += ("{pl:" + str(weatherFields[aKey]["cWidth"]) + "s}").format(pl=aKey) + delimiter
    Logger01 = TempLogger("LogFile.txt", titleStr=titleStr, delimiter=delimiter, onlyChanges=logOnlyChanges, IntervallTime=IntervallTime)

    # ---
    # Polling-Schlaufe
    # ---
    doLoop = True
    while doLoop:
        responseStr = requests.get(baseURL, params=payload)
        jsonResponse = json.loads(responseStr.text)

        logEntryStr = ""
        for aKey in weatherFields:
            formatStrValues = "{vl:" + str(weatherFields[aKey]["cWidth"]) + "." + str(nachkommaStellen) + "f}"
            aValue = jsonResponse['main'][weatherFields[aKey]["field"]]
            logEntryStr += formatStrValues.format(vl=aValue) + delimiter

        Logger01.addLogEntry(logEntryStr)
        time.sleep(pollingZeit)