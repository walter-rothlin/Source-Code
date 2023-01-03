import datetime
import requests
import json
import time
import csv
import os.path
from enum import Enum

# Edgar Golub
# Weatherlogger mit JSON aus Waltis WeatherLogger_01.py siehe Unterricht
# Quellen : https://www.youtube.com/@TheMorpheusTutorials ; https://www.youtube.com/@ProgrammierenStarten ; https://www.youtube.com/watch?v=spXdDP7J0TA&list=PLIrsP8dft12CSv-KEbiXq21JmR3LUr854
#https://www.tutorialsteacher.com/python/ \ Quellen werden auch mitten im Code erwähnt


# Time-Stamp Format
timestamp_format = "{ts:%Y-%m-%d %H:%M:%S}"
# Delimiter ersatz für die Kommas
delimiter_csv = "|"
#True/False für die OnlyChanges  https://www.datacamp.com/tutorial/case-conversion-python
onlychanges = input("Soll nur die Änderung geschrieben werden? JA oder NEIN")
if (onlychanges.lower() == "ja") or (onlychanges.lower() == "j") or (onlychanges.lower() == "y"):
    only_changes = True
else:
    only_changes = False

# Save changes Only /  Aus Lektion Nenner / Brüche kopiert + adaptiert
def __init__(self,changes_only=True):
    self.only_changes = changes_only

# class Enum import enum https://docs.python.org/3/library/enum.html
class Loglevel(Enum):
    CRITICAL = 1
    ERROR = 2
    WARNING = 3
    INFO = 4
    DEBUG = 5

## Erstellung Class und Writer CSV (https://docs.python.org/3/library/csv.html)
class Logger2:

    # 1st Try
    #LEVEL_TXT = ["CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG"]
    #LEVEL = [0,1,2,3,4]

    def get_timestamp(self):
        return self.timestamp_format.format(ts=datetime.datetime.now())

    # __init__ Aus Lektion Nenner / Brüche kopiert + adaptiert
    def __init__(self, file="weather_logs.csv", path=".", delimiter="|", overwrite_file=False, timestamp="{ts:%Y-%m-%d %H:%M:%S}", log_lev=Loglevel.DEBUG):
        self.overwrite = overwrite_file
        self.filename = file
        self.filepath = path
        self.delimiter_csv = delimiter
        self.timestamp_format = timestamp
        self.log_level = log_lev

    # Getter / Setter Methode aus Lektion 1 kopiert + adaptiert

    def set_delimiter(self, delimiter):
        self.delimiter_csv = delimiter

    def set_filename(self, file):
        self.filename = file

    def set_filepath(self, path):
        self.filepath = path

    def get_file(self):
        return self.filepath + "/" + self.filename
    #Header erstellt für XML View CSV
    def creator_header(self):
        try:
            existing_file = os.path.exists(self.get_file())
            if self.overwrite or False is existing_file:
                mode = 'w'
                with open(self.get_file(), mode, newline='') as csvfile:
                    spamwriter = csv.writer(csvfile, delimiter=self.delimiter_csv,
                                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
                    # XML Format aus Beispiel eines Log-Files
                    comment = ["#<Name>" + self.filename + "</Name> <Date>" + self.get_timestamp() + "</Date>", ""]
                    spamwriter.writerow(comment)

                    row = ["timestamp", "level", "kommentar"]
                    spamwriter.writerow(row)
        except FileNotFoundError:
            print("Die Datei " + self.get_file() + " konnte nicht gefunden werden!")
            quit()
    #Eintrag  im Log
    def write_line(self, level, timestamp, text):

        if level.value <= self.log_level.value:
            with open(self.get_file(), 'a', newline='') as csvfile:
                spamwriter = csv.writer(csvfile, delimiter=self.delimiter_csv,
                                        quotechar='\'', quoting=csv.QUOTE_MINIMAL)
                # Arrays erstellen für row https://www.w3schools.com/python/python_arrays.asp
                row = [timestamp, level.name, text]
                #   spamwriter.writerow(timestamp + delimiter_csv + level + delimiter_csv + text) in array abgefuellt
                spamwriter.writerow(row)


def get_timestamp():
    return timestamp_format.format(ts=datetime.datetime.now())

serviceURL = "https://api.openweathermap.org/data/2.5/weather"
pollingTime = float(input("Polling-Time [s]:"))
ort = input("Ort  [*Dietlikon]   :")
if ort == "":
    ort = 'Dietlikon'

max_counter = int(input("Anzahl requests :"))
#Eigene AppID von Weather API
appId = "f03b0b8408c3522d6e96f8c0e3c0e36d"

logger2: Logger2 = Logger2("weather_logs.csv",".", "|", False, timestamp_format, Loglevel.INFO)

firstTime = True
counter = 0
doLoop = True

logger2.creator_header()

logger2.write_line(Loglevel.DEBUG, get_timestamp(), "Starting ...")

vor_wetter = ()

while doLoop:
    counter += 1
    requestStr = serviceURL + "?q=" + ort + "&units=metric&lang=de&appid=" + appId
    print("Request:\n", requestStr, "\n\n") if firstTime else False

    # text = "Calling web-service " + requestStr + " ..."
    # logger2.write_line(Loglevel.DEBUG, get_timestamp(), text)


    # Aufruf Daten von Server Weather
    responseStr = requests.get(requestStr)

    # Debug Response level 200
    print("Response:\n", responseStr.text, "\n\n") if firstTime else False

    jsonResponse = json.loads(responseStr.text)

    code = responseStr.status_code
    reason = responseStr.reason

    ortsname = jsonResponse['name']
    land = jsonResponse['sys']['country']

    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    cloud = jsonResponse['weather'][0]['description']

    # lat = jsonResponse['coord']['lat']
    # lon = jsonResponse['coord']['lon']
    # cloud = jsonResponse['weather'][0]['description']
    # windSpeed = jsonResponse['wind']['speed']
    # windDirection = jsonResponse['wind']['deg']

    # Array für Wetterwerte
    wetter = [ortsname, land, cloud, temp, pressure, humidity]

    # Schleife für log-level

    if 200 <= code <= 299:
        if vor_wetter != wetter or only_changes == False:
            vor_wetter = wetter
            # text in variable gepackt +  anpassung von ausgabe logger2.write_line

            #Runden siehe Aufgabe
            temperature = round(temp, 1)

            text = land + str(delimiter_csv) + ortsname + str(delimiter_csv) + str(cloud) + str(delimiter_csv) + str(
                temperature) + str(delimiter_csv) + str(pressure) + str(delimiter_csv) + str(humidity)
            # Anpassung Logger mit str() Ausgabe in das .CSV + Anpassung INFO hardcoded
            logger2.write_line(Loglevel.INFO, get_timestamp(), text)
        else:
            text = "Wetter hat sich nicht geaendert"
            logger2.write_line(Loglevel.DEBUG, get_timestamp(), text)
    elif 300 <= code <= 399:
        logger2.write_line(Loglevel.WARNING,  get_timestamp(),
                           "Calling web-service " + requestStr + ": " + str(code) + " " + reason)
    elif 500 <= code:
        logger2.write_line(Loglevel.CRITICAL,  get_timestamp(),
                           "Calling web-service " + requestStr + ": " + str(code) + " " + reason)
    else:
        vor_wetter = wetter
        text = "Calling web-service " + requestStr + ": " + str(code) + " " + reason
        logger2.write_line(Loglevel.ERROR,  get_timestamp(), text)

    time.sleep(pollingTime)
    firstTime = False
    if counter >= max_counter:
        doLoop = False

# ---------------------------------------------------------
# Review / Beurteilung
# ---------------------------------------------------------
# 1. Lauffähiger Code abgegeben (2 Punkte)                                  1
#    Alles in einem File (ausnahmsweise für diese Aufgabenstellung)
#    Filename: Vorname_Nachname_A19_DS.py (z.B. Rea_Vogel_A19_DS.py)
# 2. CLI Applikation schreibt ein Log-File (2 Punkte)                       2
# 3. Für den Weather REST Service wurde ein eigener Token verwendet         2
# 4. Eine eigene, reusable Klasse mit
#    einfachem Interface implementiert (4 Punkte)                           4
# 5. Nur absolut Notwendiges ist public (2 Punkte)                          1 (redundanzen getTimestamp() time-format)
# 6. Kommentare in Form von doc_strings sind enthalten                      0
# 7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                   1
# 8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)              1
#    Log-Entries enthalten formatierten Time-Stamp und Level                1
# 9. Scrolling Strategie implementiert                                      0
# 10. Anzahl Zeilen für Scrollbereich definierbar                           0
# 11. ChangesOnly implementiert                                             0
# 12. Append / New implementiert                                            0
# 13. Delimiter via __init__ setzbar (mit Default-Wert)                     1
# 14. Strategie via __init__ setzbar (mit Default-Wert)                     1
# 15. Scrolling area via __init__ setzbar (mit Default-Wert)                1
#                                                                       ---------
#                                                                          16
#                                                                       =========
