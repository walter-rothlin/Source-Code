# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und User Input ist möglich
#      + User-Eingaben mit Vorschlägen/Auswahlmöglichkeiten
#      - Unsinnige User-Eingaben können zum Absturz führen
#
# Class Design und Implementation:
#      + Eigene Klasse
#      - Notwendige (__eq__ __str__ ) Methoden nicht vorhanden
#      - __init__ wichtige Parameter fehlen (OnlyChanges, FixedSlices, Ringbuffersize, New/Append,....)
#      - __init__ Parameter haben nur wenige Defaultwerte
#      - Alle Instance Variablen sind public
#      + OnlyChanges funktioniert (ohne Toleranz)
#      + Ein Ringbuffer implementiert (fixed Slices)
#      - Einigen Methoden könnten private
#      - Einigen Methoden könnten private oder private static sein (bessere encapsulation)
#      - Kein Exceptionhandling in der Klasse
#
# Test:
#      - Keine Test implementiert
#
# Note: 5.0
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wo wird unterschieden zwischen changesOnly True/False?
# ------------------------------------------------------------------
import datetime
import json
import os
import sys
import time
import pathlib
from enum import Enum

import requests


class LoggingObj:
    loggingtime = ''
    loglvl = ''

    def __init__(self, loglvl):
        self.loggingtime = datetime.datetime.now(tz=None).__str__()
        self.loglvl = LogLevel(loglvl).name


class LogLevel(Enum):
    INFO = 'INFO'
    DEBUG = 'DEBUG'
    WARNING = 'WARNING'
    ERROR = 'ERROR'
    CRITICAL = 'CRITICAL'


class LogStrategy(Enum):
    INCREMENTAL = 1
    ONCHANGE = 2


class Logger:
    filePath = ''
    fileName = ''
    entryLimit = 0
    logLvl = LogLevel
    recordingStrategy = ''
    contentHeader = ''
    delimiter = ''
    header = ''
    FILE_FULLPATH = ''
    content = ''

    def __init__(self, filePath, fileName, entryLimit, recordingStrategy, contentHeader, content, delimiter='|',
                 logLvl='INFO'):
        self.filePath = filePath
        self.fileName = fileName
        self.entryLimit = entryLimit
        self.recordingStrategy = recordingStrategy
        self.contentHeader = contentHeader
        self.content = content
        self.delimiter = delimiter
        self.header = '<Name>' + self.filePath + self.fileName + '</Name>' + '\n' + 'Timestamp' + self.delimiter + 'LogLevel' + self.delimiter + contentHeader
        self.FILE_FULLPATH = self.filePath + fileName
        self.logLvl = LogLevel(logLvl)

    def writeIntoFile(FILE_PATH, text, method):
        with open(FILE_PATH, method)  as logfile:
            logfile.write(text + "\n")

    def checkLastLineOfFile(filenamee, content):
        with open(filenamee, 'r') as f:
            lines = f.readlines()
            contentString = str(content)
            if contentString in lines[-1]:
                return True

    def logging(self):
        obj = LoggingObj(self.logLvl)
        if (self.recordingStrategy == LogStrategy.ONCHANGE.value):
            if (os.path.exists(self.FILE_FULLPATH) and Logger.checkLastLineOfFile(self.FILE_FULLPATH, self.content)):
                return
            Logger.updateOrCreateNewFile(self, self.FILE_FULLPATH,
                                         obj.loggingtime + self.delimiter + obj.loglvl + self.delimiter + self.content.__str__())
        else:
            Logger.updateOrCreateNewFile(self, self.FILE_FULLPATH,
                                         obj.loggingtime + self.delimiter + obj.loglvl + self.delimiter + self.content.__str__())

    def updateOrCreateNewFile(self, filename, text):
        if (os.path.exists(filename)):
            if Logger.checkFileLength(self, filename) == self.entryLimit:
                Logger.writeIntoFile(filename, text, "a")
                with open(filename, 'r') as f:
                    lines = f.readlines()
                with open(filename, "w") as f:
                    #Ringbuffer when file exceeds limit set in object init
                    f.writelines(lines[:2] + lines[3:])
            elif Logger.checkFileLength(self, filename) > self.entryLimit:
                with open(filename, "r") as f:
                    lines = f.readlines()
                with open(filename, "w") as f:
                    a = 1 - self.entryLimit
                    f.writelines(lines[:2] + lines[a:])

            else:
                Logger.writeIntoFile(filename, text, "a")
        else:
            Logger.writeIntoFile(filename, self.header, "a")
            Logger.writeIntoFile(filename, text, "a")

    def checkFileLength(self, filename):
        file = open(filename, "r")
        line_count = -2
        for line in file:
            if line != "\n":
                line_count += 1
        file.close()

        return line_count


def checkDirectory(path):
    pathlib.Path(path).mkdir(parents=True, exist_ok=True)


class WeatherTool:
    # CONSTANTS
    ERROR = 'ERROR'
    FILE_TYPE = '.csv'
    FOLDER_PATH = "files/"
    checkDirectory(FOLDER_PATH)
    COUNTRY = 'CH'
    API_KEY = 'c3861372c2b3668000d0c51d164c4e36'

    # VARIABLES
    filename = ''

    # INPUTS
    status = input('Log into: 1 = new file or 2 = Existing one? enter number: ')
    if status == '2':
        print(os.listdir(FOLDER_PATH))
        filename = input(
            'Please enter FILENAME of existing files in directory (without extension eg. ".csv") ' + FOLDER_PATH + ': ')
    else:
        filename = input('Please enter FILENAME (without extension eg. ".csv"): ')
    filename += FILE_TYPE
    FILEPATH = FOLDER_PATH + filename
    delimiter = str(input('Enter delimiter: '))
    strategy = int(input('Strategies: 1 = INCREMENTAL, 2 = ONCHANGE, enter number: '))
    ZIP = input('Please enter the ZIPCODE of your desired city: ')
    sampleTime = float(input('Duration between requests: '))
    print('APPLICATION WILL NOT STOP PLS EXIT TO SEE THE CREATED LOGFILES')

    URL = 'http://api.openweathermap.org/data/2.5/weather?zip=' + ZIP + ',' + COUNTRY + '&appid=' + API_KEY
    message = ''

    while True:
        # HTTP CALL
        try:
            response = requests.get(URL)
        except ConnectionError:
            sys.exit()

        if response.status_code == 400:
            message = 'City not found!'
            Logger(FOLDER_PATH, "error.csv", 10, 1, "errormessage", message, ",", ERROR).logging()
            raise ValueError(message)

        elif response.status_code == 401:
            message = 'API Key not recognized. Try a new one or contact openweathermap!'
            Logger(FOLDER_PATH, "error.csv", 10, 1, "errormessage", message, ",", ERROR).logging()
            raise ValueError(message)

        elif response.status_code == 200:
            # JSON Object
            jsonResponse = json.loads(response.text)
            temperature = jsonResponse['main']['temp']
            temperature = str(round(temperature - 273.15, 2))
            humidity = (jsonResponse['main']['humidity']).__str__()
            # Prepare message
            messageToBeLogged = temperature + delimiter + humidity
            header = 'Temperature' + delimiter + 'Humidity'
            print(
                'Logging temperature: ' + temperature + " and humidity " + humidity + ' into (after exititing): ' + FILEPATH)
            # Log meesage
            Logger(FOLDER_PATH, filename, 10, strategy, header, messageToBeLogged, delimiter,
                   LogLevel.INFO).logging()
            try:
                time.sleep(sampleTime)
            except KeyboardInterrupt:
                sys.exit('done! please check: ' + FILEPATH)

        else:
            message = 'Something went wrong! Internal Error'
            Logger(FOLDER_PATH, "error.csv", 10, 1, "errormessage", message, ",", ERROR).logging()
            raise ValueError(message)
