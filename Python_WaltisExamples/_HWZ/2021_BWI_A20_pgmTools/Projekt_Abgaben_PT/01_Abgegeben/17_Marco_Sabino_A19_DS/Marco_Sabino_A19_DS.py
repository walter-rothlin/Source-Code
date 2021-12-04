import csv
import json
from datetime import datetime                                                                                               # https://docs.python.org/3/library/datetime.html
import time
from enum import Enum                                                                                                       # https://docs.python.org/3/library/enum.html
from pathlib import Path
import requests


                                                                                                                            # https://stackoverflow.com/questions/58608361/string-based-enum-in-python/58608362 --> Attribute Error --> ENUM
class LogStatus(Enum): # API Status                                                                                         # --> Base class for creating enumerated constants. See section Functional API for an alternate construction syntax.

    debug = "DEBUG"
    info = "INFO"
    warnings = "WARNINGS"
    error = "ERROR"
    critical = "CRITICAL"

class DocPen: # CSV Initialkonfiguration

    def __init__(self, thisdoc: str, delimiter='|'):
                                                                                                                            # https://docs.python.org/3/library/csv.html
                                                                                                                            # https://stackoverflow.com/questions/20432912/writing-to-a-new-file-if-it-doesnt-exist-and-appending-to-a-file-if-it-does
        self.fileExist = Path(thisdoc).is_file()
        self.place_data = open(thisdoc, 'a', newline='')                                                                    # durch "a" wird bei keinem bestehend File ein neues erstellt, ansonsten wir File mit neuen Datensätzen ergänzt
        self.writer = csv.writer(self.place_data, delimiter=delimiter)

                                                                                                                            # https://www.geeksforgeeks.org/file-flush-method-in-python/#:~:text=The%20flush()%20method%20in,using%20the%20flush()%20method.
                                                                                                                            # https://www.pythontutorial.net/python-basics/python-write-csv-file/
    def writeLine(self, row):
        self.place_data.flush()
        self.writer.writerow(row)


class WetterLogger: # Setzen der Kopfzeilen (Überschriften) und CSV abfüllen

    def __init__(self, kopfzeile, thisdoc):
        self.kopfzeile = kopfzeile
        self.thisdoc = thisdoc
        self.starZeit = datetime.now()
        self.wobj = DocPen(thisdoc)
        self.kopfzeile.insert(0, "Timestamp")
        self.kopfzeile.insert(1, "Log-level")
                                                                                                                            # https://www.odoo.com/de_DE/forum/hilfe-1/fields-datetime-now-show-the-time-of-the-latest-restart-not-the-current-time-107582
        if not self.wobj.fileExist:
            self.wobj.writeLine(kopfzeile)

    def readlastline(self, docname): # lesen der letzten Zeile
        with open (docname, newline='') as csvdata:
            self.data = list(csv.reader(csvdata))
            if len(self.data) > 0:                                                                                          # https://www.edureka.co/blog/python-list-length/
                self.lastline = self.data[-1]
                self.splitlastline = self.lastline[0].split("|")                                                            # https://www.w3schools.com/python/ref_string_split.asp
                del self.splitlastline[0:2]
                return self.splitlastline


    def writedown(self, log_level: LogStatus, *elemente): # lesen, ob Zeile davor die selben Daten enthält. *elemente für eine einfacher Iteration
        elemente = list(elemente)

        zeitJetzt = datetime.now()
        print(Path(self.thisdoc).is_file())
        if Path(self.thisdoc).is_file():
            csvlastline = self.readlastline(self.thisdoc)                                                                   # https://stackoverflow.com/questions/37227909/print-last-line-of-file-read-in-with-python
            print(csvlastline)
            elementemap = list(map(str, elemente))
            print(elementemap)
        if csvlastline != elementemap:
            elemente.insert(0, zeitJetzt)
            elemente.insert(1, log_level.name)
            if len(elemente) != len(self.kopfzeile):
                raise RuntimeError(" Länge der Datensätze " + (len(elemente) + "Länge der Überschriften" + len(self.kopfzeile) + "stimmt nicht überein"))
            self.wobj.writeLine(elemente)
        else:
            print("Daten haben nicht geändert")


class API: #API Daten abrufen

    def __init__(self):
        self.filepath = input("Bitte Dateipfad eingeben: ")       # Eingabe wie folgt bspw.:-->    C:\\users\\marco\\OneDrive\\
        self.filename = "%s.csv" % input("Bitte File benennen: ") # Kombinierung von Filename mit der Endung ".csv"         # # https://www.kite.com/python/answers/how-to-create-a-filename-using-variables-in-python
        print(self.filename)
        self.fullfilename = self.filepath + self.filename          # Vereinigung von Dateipfad und Dateinamen +.csv
        print(self.fullfilename)
        self.pollingTime = float(input("Polling-Time [s]:"))
        self.base_URL = "https://api.openweathermap.org/data/2.5/weather"
        self.appId = "c0097ba17dabd82dd3fdecb64e14c3d4"
        self.country_code = input("Country Code: ")
        print("Ländercode {} wurde ausgewählt" .format(self.country_code))
        self.zip = input("ZIP: ")
        print("ZIP {} wurde ausgewählt".format(self.zip))
        self.logger = WetterLogger(["country", "name", "cloud", "temp", "lon", "lat", "humidity", "pressure", "windsped"], self.fullfilename)

# NEW JSON (Fields in API response) --> https://openweathermap.org/current#current_JSON
    def runthrough(self): # response-Abfrage
        while True:
            r = requests.get(self.base_URL + "?zip=" + self.zip + "," + self.country_code + "&appid=" + self.appId)
            input_json_data = json.loads(r.text)
            print(input_json_data)
            print(type(input_json_data))
            # print(json.dumps(input_json_data, indent=8))          # auskommentiert, da anonsten die Konsole mit JSON Daten zugespamt wird


            country = input_json_data["sys"]["country"]
            name = input_json_data["name"]
            cloud = input_json_data["weather"][0]["description"]
            temp = input_json_data["main"]["temp"]
            lon = input_json_data["coord"]["lon"]
            lat = input_json_data["coord"]["lat"]
            humidity = input_json_data["main"]["humidity"]
            pressure = input_json_data["main"]["pressure"]
            windspeed = input_json_data["wind"]["speed"]

            self.logger.writedown(LogStatus.info, country, name, cloud, temp, lon, lat, humidity, pressure, windspeed)
            time.sleep(self.pollingTime)


if __name__ == "__main__":
    API().runthrough()

else:
    raise ValueError