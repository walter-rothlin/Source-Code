# ------------------------------------------------------------------
# Name  : Oliver_Keller_A21_DS.py
#
# Description: Design und Implementation einer eigenen, allgemeinen Logger Klasse Entwickeln einer CLI
# Test-Applikation, welche Daten via einen REST-Auf- ruf von einem Web-Service abfragt (JSON response) und nach
# verschiedenen Strategien in einem csv-File loggen kann. https://openweathermap.org/current
#
# Autor: Oliver Keller
#
# History:
# 15.11.22 - Aufgaben start 4h
# 16.11.22 - Setter, Getter, property von seperator, filename, get_timestamp 3h
# 17.11.22 - DocStrings ergänzen, append korrigieren 4h
# 19.11.22 - File strategie entwickeln - leider nicht funktioniert 4h
# 21.11.22 - Scroll-modus implementiert 4h
# 22.11.22 - Kontrolle und letzte Tests 2h

# Anleitungen
# Docstring anleitung: https://www.programiz.com/python-programming/docstrings
# Pfad anleitung: https://www.geeksforgeeks.org/os-path-module-python/
# zeilen zählen in file: https://www.delftstack.com/de/howto/python/python-get-number-of-lines-in-file/

# Aufpassen! Mein Default Path ist ein anderer wie deiner, da ich auf Mac bin, wir der Path anderste gebildet. Bitte
# bei korrektur beachten.

import datetime
import requests
import json
import time


class HWZ_Logger:
    """Create Loggerklasse"""

    def __init__(self, filename="LoggerTest.csv", seperator="|",
                 path="/Users/oliverkeller/Desktop/Python",
                 appendtofile="Nein", maxlinesinfile=10, titels=[], linesinfile=[], changesonly="Nein"):
        self.__filename = filename
        self.__seperator = seperator
        self.__path = path
        self.__appendtofile = appendtofile
        self.__maxlinesinfile = maxlinesinfile
        self.__titels = titels
        self.__linesinfile = linesinfile
        self.__changesonly = changesonly

    def get_timestamp(self):
        """Create Timestamp with Form"""
        return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())

    def get_seperator(self):
        """getter methode von seperator"""
        return self.__seperator

    def get_filename(self):
        """getter methode von filename"""
        return self.__filename

    def get_path(self):
        """getter methode von path"""
        return self.__path

    def get_appendtofile(self):
        """getter methode von appendtofile"""
        return self.__appendtofile

    def get_maxlinesinffile(self):
        """getter methode von maxlinesinfile"""
        return self.__maxlinesinfile

    def get_titels(self):
        """getter methode von titels"""
        return self.__titels

    def get_changesonly(self):
        """getter methode von changesonly"""
        return self.__changesonly

    def set_seperator(self, seperator):
        """setter methode von seperator"""
        if seperator == "":
            seperator = "|"
        self.__seperator = seperator

    def set_filename(self, filename):
        """setter methode von filename"""
        if filename == "":
            filename = "LoggerTest.csv"
        self.__filename = filename

    def set_path(self, path):
        """setter methode von path"""
        if path == "":
            path = "/Users/oliverkeller/Desktop/Python"
        self.__path = path

    def set_appendtofile(self, appendtofile):
        """setter methode von appendtofile"""
        if appendtofile == "":
            appendtofile = "Nein"
        self.__appendtofile = appendtofile

    def set_timestamp(self, gettimestamp):
        """setter methode von timestamp"""
        self.__gettimestamp = gettimestamp

    def set_maxlinesinfile(self, maxlinesinfile):
        """setter methode von maxlinesinfile"""
        if maxlinesinfile == "":
            maxlinesinfile = 20
        self.__maxlinesinfile = maxlinesinfile

    def set_titels(self, titels):
        """setter methode von titels"""
        self.__titels = titels

    def set_changesonly(self, changesonly):
        """setter netohde von changesonly"""
        self.__changesonly = changesonly

    """create properties"""
    seperator = property(get_seperator, set_seperator)
    filename = property(get_filename, set_filename)
    path = property(get_path, set_path)
    gettimestamp = property(get_timestamp, set_timestamp)
    appendtofile = property(get_appendtofile, set_appendtofile)
    maxlinesinffile = property(get_maxlinesinffile, set_maxlinesinfile)
    titels = property(get_titels, set_titels)
    changesonly = property(get_changesonly, set_changesonly)

    def createFile(self):
        """create file and checks if append is Ja or Nein if append is Nein it create a header and a titel"""
        if self.__appendtofile == "Nein":
            titel_str = ""
            for titel in self.__titels:
                if titel != self.__titels[-1]:
                    titel_str = titel_str + titel + self.__seperator
                else:
                    titel_str = titel_str + titel + "\n"
            f = open(self.__path + "/" + self.__filename, "w")
            f.write("#<Name>" + self.__filename + "</Name>" + "<Date>" + self.gettimestamp + "</Date>" + "\n")
            f.write("Timestamp" + self.__seperator + "loglevel" + self.__seperator + titel_str)
            f.close()

    def addToLog(self, logMsg, logLevel="INFO"):
        """add logg to loggfile and checks if maxlines ar bigger then the lines in file at the moment if so the first
        lines will be deleted to make space for the new lines """
        print(self.gettimestamp + self.seperator + logMsg)
        self.logLevel = logLevel
        if self.__maxlinesinfile >= self.countlinesinfile():
            f = open(self.__path + "/" + self.__filename, "a")
            f.write(self.gettimestamp + self.__seperator + logLevel + self.__seperator + logMsg + "\n")
            f.close()
        else:
            f = open(self.__path + "/" + self.__filename, "a")
            f.write(self.gettimestamp + self.__seperator + logLevel + self.__seperator + logMsg + "\n")
            f.close()
            all_lines = self.readlines()
            new = all_lines[:2] + all_lines[self.countlinesinfile() - self.__maxlinesinfile + 2:]
            with open(self.__path + "/" + self.__filename, "w") as f:
                for i in new:
                    f.write(i)

    def countlinesinfile(self):
        """count lines in file"""
        f = open(self.__path + "/" + self.__filename, "r")
        totallines = sum(1 for line in f)
        return totallines

    def readlines(self):
        """read and store all lines into list"""
        with open(self.__path + "/" + self.__filename, "r") as fp:
            all_lines = fp.readlines()
        self.__linesinfile = all_lines
        return all_lines


myLogger = HWZ_Logger()

print("Logger Settings:")
print("---------------------------")
pollingTime = float(input("Polling-Time [s]: "))
max_counter = int(input("Anzahl request: "))
myLogger.path = str(input("Pfad: "))
myLogger.filename = str(input("Filename: "))
myLogger.seperator = str(input("Seperator [|]: "))
myLogger.appendtofile = str(input("Append [Ja, Nein]: "))
"""changesonly no function, was not able to do it"""
myLogger.changesonly = str(input("Changesonly [Ja, Nein]: "))
ort = str(input("Ort  [*Uster]   :"))
if ort == "":
    ort = 'Uster'

myLogger.logLevel = str(input("Loglevel [DEBUG, INFO, WARNINGS, ERROR, CRITICAL]"))
spaltentitel = ["Ort", "Temperatur in C", "Pressure in mBar", "humidity in %", "Cloud", "WindSpeed in m/s",
                "WindDirections in °"]

myLogger.titels = spaltentitel

myLogger.createFile()

serviceURL = "https://api.openweathermap.org/data/2.5/weather"

appId = "20a8e723cbf202340b03cdd033ed530b"

firstTime = True
counter = 0

doLoop = True

while doLoop:
    counter += 1
    requestStr = serviceURL + "?q=" + ort + "&units=metric&lang=de&appid=" + appId
    print("Request:\n", requestStr, "\n\n") if firstTime else False
    responseStr = requests.get(requestStr)
    print("Response:\n", responseStr.text, "\n\n") if firstTime else False

    jsonResponse = json.loads(responseStr.text)

    ortsname = jsonResponse['name']
    land = jsonResponse['sys']['country']
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']
    windSpeed = jsonResponse['wind']['speed']
    windDirection = jsonResponse['wind']['deg']

    logStr = str(ortsname) + myLogger.seperator + str(temp) + myLogger.seperator \
             + str(pressure) + myLogger.seperator + str(humidity) + myLogger.seperator \
             + str(cloud) + myLogger.seperator + str(windSpeed) + myLogger.seperator \
             + str(windDirection)

    myLogger.addToLog(logStr)
    time.sleep(pollingTime)
    firstTime = False
    if counter >= max_counter:
        doLoop = False
