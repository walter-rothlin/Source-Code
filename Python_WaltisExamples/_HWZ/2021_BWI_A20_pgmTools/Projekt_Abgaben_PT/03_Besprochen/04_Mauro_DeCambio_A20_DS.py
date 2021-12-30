# ------------------------------------------------------------------
# Name: Mauro_DeCambio_A20_DS.py
#
# Description: Loggt Wetterdaten via REST
#
# Creator: Mauro De Cambio
# ------------------------------------------------------------------
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und User Input ist möglich
#      + Startime im Header
#      - Unsinnige User-Eingaben können zum Absturz führen
#      - Runden nicht implementiert
#
# Class Design und Implementation:
#      + Eigene Klasse vorhanden
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
import requests
import json
import time
import csv
from enum import Enum
from pathlib import Path
from datetime import datetime

"""
Was Fehlt noch:
Ringbuffer
Fixed or Changes only
"""


class LogLevel(Enum):
    """
    Source:
    https://docs.python.org/3/library/enum.html
    """
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARNINGS = "WARNINGS"
    ERROR = "ERROR"
    CRITICAL = "CRITICAL"


class Logger:
    """
    Sources:
    Für CSV Bearbeitung
    https://docs.python.org/3/library/csv.html
    """
    def __init__(self, headers: list, filename: str, delimiter):
        headers = ["timestamp", "LogLevel"] + headers  # Fügt den Header timestamp und LogLevel hinzu
        self.headers = headers
        self.file_exists = True
        if delimiter == "":  # Falls Delimiter nicht von der App gesetzt wird
            delimiter = "|"  # Default Delimiter
        if filename == "":
            filename = "default.csv"  # Default Filename
        if Path(filename).is_file():  # Falls File bereits existiert
            self.csv_file = open(filename, 'a', newline='')
        else:
            self.csv_file = open(filename, 'x', newline='')
            self.file_exists = False
        self.writer = csv.writer(self.csv_file, delimiter=delimiter, quotechar='\'', quoting=csv.QUOTE_MINIMAL)
        if not self.file_exists:
            # Header und Info wird ins neue File geschrieben
            fileinfo = [f"# <Timestamp>{datetime.now()}</Timestamp><Name>{filename}</Name>"]
            self.writeline(fileinfo)
            self.writeline(headers)
        self.startTime = datetime.now()
        self.filename = filename

    def writelog(self, log_level: LogLevel, *data):  # Zeit und Loglevel werden hinzugefügt
        current_time = datetime.now()
        data = list(data)
        data = [current_time, log_level.name] + data
        self.writeline(data)

    def writeline(self, line):  # Schreibt die Zeile definitiv ins CSV
        self.writer.writerow(line)
        self.csv_file.flush()


class Request:

    def __init__(self):
        self.fileName = input("Filename:")
        self.place = str(input("Ortschaft:"))
        if self.place == "":
            self.place = "Zürich"
        self.pollingTime = float(input("Polling-Time [s]:"))
        self.delimitter = input("Delimiter:")
        self.serviceURL = "https://api.openweathermap.org/data/2.5/weather"
        self.appId = "f56c964906bf5d695dfb2e94d2baeb2e"
        self.CSVLogger = Logger(["temp", "pressure", "humidity", "place", "cloud"], filename=self.fileName,
                                delimiter=self.delimitter)

    def pullinterval(self):
        """
        Zusätzlich noch einbauen:
        Requeststatus überprüfen und Entsprechende Log Info ausgeben wenn nicht erreichbar.
        Checken ob die Keys noch existieren. z.b. main - temp oder obs neu temperature heisst.
        Checken ob die eingaben richtig sind. ob ortschaft auch wirklich eine Ortschaft ist, usw.

        API Dok
        https://openweathermap.org/current
        """
        while True:
            resstr = requests.get(self.serviceURL + f"?q={self.place}&units=metric&lang=de&appid=" + self.appId)
            jsonresponse = json.loads(resstr.text)
            temp = jsonresponse['main']['temp']
            pressure = jsonresponse['main']['pressure']
            humidity = jsonresponse['main']['humidity']
            cloud = jsonresponse['weather'][0]['description']
            place = jsonresponse['name']
            self.CSVLogger.writelog(LogLevel.INFO, temp, pressure, humidity, place, cloud)
            time.sleep(self.pollingTime)


if __name__ == '__main__':
    Request().pullinterval()
