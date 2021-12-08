# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert ohne User Input ist möglich
#      - Kein Titel nur Header im file
#      - Runden nicht implementiert
#
# Class Design und Implementation:
#      + Eigene Klasse vorhanden
#      + Ueberzeugt mit Einfach- und Klarheit
#      - Notwendige (__eq__ __str__ ) Methoden nicht implementiert
#      - __init__ wichtige Parameter fehlen und haben keine sinnvolle Default-Werte
#      - Alle Instance Variablen sind public
#      - OnlyChanges nicht implementiert
#      - Ringbuffer nicht implementiert
#      - Einigen Methoden könnten private oder private static sein (bessere encapsulation)
#      - Kein Exceptionhandling in der Klasse oder in der Applikation
#
# Test:
#      - Keine Test implementiert
#
# Note: 4.5
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wo wird unterschieden zwischen changesOnly True/False?
# ------------------------------------------------------------------
import csv
from datetime import datetime
import json
import time
from enum import Enum
from pathlib import Path

import requests


class FileWriter:

    def __init__(self, filename: str, delimiter='|'):
        # https://docs.python.org/3/library/csv.html
        if Path(filename).is_file():
            self.csv_file = open(filename, 'a', newline='')
            self.file_exists = True
        else:
            self.csv_file = open(filename, 'x', newline='')
            self.file_exists = False
        self.writer = csv.writer(self.csv_file, delimiter=delimiter,
                                 quotechar='\'', quoting=csv.QUOTE_MINIMAL)

    def writeLine(self, rows):
        self.writer.writerow(rows)
        self.csv_file.flush()


class LogLevel(Enum):
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARNINGS = "WARNINGS"
    ERROR = "ERROR"
    CRITICAL = "CRITICAL"


class Logger:

    def __init__(self, headers, filename):
        self.writerInstance = FileWriter(filename)
        self.headers = headers
        headers.insert(0, "time")
        headers.insert(1, "log level")
        if not self.writerInstance.file_exists:
            self.writerInstance.writeLine(headers)
        self.startTime = datetime.now()
        self.filename = filename

    def log(self, log_level: LogLevel, *data):
        current_time = datetime.now()
        data = list(data)
        data.insert(0, current_time)
        data.insert(1, log_level.name)
        if len(data) != len(self.headers):
            raise RuntimeError("Length of headers " + str(len(self.headers)) + " and length of data " + str(
                len(data)) + " does not match")
        self.writerInstance.writeLine(data)


class Parser:

    def __init__(self):
        self.pollingTime = float(input("Polling-Time [s]:"))
        self.serviceURL = "https://api.openweathermap.org/data/2.5/weather"
        self.appId = "144747fd356c86e7926ca91ce78ce170"
        self.loggerClass = Logger(["temp", "pressure", "humidity", "lon", "lat", "cloud"], "helloworld.csv")

    def startInterval(self):
        while True:
            responseStr = requests.get(self.serviceURL + "?q=Kloten&units=metric&lang=de&appid=" + self.appId)
            jsonResponse = json.loads(responseStr.text)
            temp = jsonResponse['main']['temp']
            pressure = jsonResponse['main']['pressure']
            humidity = jsonResponse['main']['humidity']
            lon = jsonResponse['coord']['lon']
            lat = jsonResponse['coord']['lat']
            cloud = jsonResponse['weather'][0]['description']
            self.loggerClass.log(LogLevel.INFO, temp, pressure, humidity, lon, lat, cloud)
            time.sleep(self.pollingTime)


if __name__ == '__main__':
    Parser().startInterval()
