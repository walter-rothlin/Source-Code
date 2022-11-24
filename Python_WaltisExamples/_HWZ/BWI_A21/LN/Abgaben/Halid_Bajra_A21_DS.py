# ------------------------------------------------------------------
# Name  : Halid_Bajra_A21_DS.py
#
# Description: Polling REST Service and write values to console
# https://openweathermap.org/current
#
# Autor: Halid Bajra
#
# History:
# 22-Nov-2022   Halid Bajra      create Script ()
# ------------------------------------------------------------------
# Importieren von Packages
import json
import csv
import datetime
from pathlib import Path
import requests
import time


# Logger Klasse
class Logger:

    # Initializer der Klasse, wenn a mitgeben wird und file existiert wird es angehängt, ansonsten wird ein neues
    # File erstellt Argumente: Filepathname ist der Pfad sowie Name des Files, delimiter ist das Trennzeichen
    # NumberOfLines gib an wie viel Zeilen das file haben soll
    # https://docs.python.org/3/library/csv.html
    # https://www.pythontutorial.net/python-basics/python-check-if-file-exists/
    def __init__(self, filepathname, delimiter='|', NumberOfLines=100):
        self.filepathname = filepathname
        self.delimiter = delimiter
        self.NumberOfLines = NumberOfLines
        if file_kind == 'a' and Path(filepathname).is_file():
            self.CSV_File = open(filepathname, 'a', newline='')
            self.file_exist = True
        else:
            self.CSV_File = open(filepathname, 'x', newline='')
            self.file_exist = False
        self.writer = csv.writer(self.CSV_File, delimiter=delimiter)

    # Funktion um Zeitstempel zu definieren
    def getTimestamp(self):
        return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())

    # Funktion um zu überprüfen ob File existiert oder ein neues erstellt werden muss. Return öffnet das File,
    # mit entweder append to File oder write File.
    def chkFile(self):
        if Path(filepathname).is_file():
            return open(filepathname, 'a', newline='')
        else:
            return open(filepathname, 'w', newline='')

    # Funktion zum Löschen der zu viel erstellten Zeilen anhand von NumberOfLines. Filepathname wird beim Aufruf
    # mitgegeben. https://pynative.com/python-delete-lines-from-file/
    def deleteLines(self, filepathname):
        lines = []
        with open(filepathname, 'r') as f:
            lines = f.readlines()
        with open(filepathname, 'w') as f:
            for number, line in enumerate(lines):
                if number not in [2]:
                    f.write(line)

    # Funktion um herauszulesen, wie viel Zeilen erstellt wurden. Return liefert die Anzahl Zeilen. Filepathname wird
    # beim Aufruf mitgegeben.
    def getLine(self, filepathname):
        file = open(filepathname, "r")
        length = len(file.readlines())
        file.close()
        return length

    # Funktion für die Erstellung des Header. delimiter wird beim Aufruf  mitgegeben.
    def crHeader(self, delimiter):
        self.writelines("# <Name> " + filepathname + " </Name> " + "<Datum> " + MyLogger.getTimestamp() + " </Datum>")
        self.writelines("Zeitpunkt" + delimiter + "Log Level" + delimiter + "Ort" + delimiter + "Land" + delimiter + "Koordinaten" + delimiter + "Temperatur" + delimiter + "Druck" + delimiter + "Feuchtigkeit" + delimiter + "Wetterbedingungen" + delimiter + "Windstärke" + delimiter + "Windrichtung")

    # Funktion um festzuhalten, ob Wetterveränderungen berücksichtigt werden sollen oder nicht.
    def ChangesOnly(self, ChangesOnly):
        if ChangesOnly.upper() == "JA":
            self.ChangesOnlyOutput = True
        elif ChangesOnly.upper() == "NEIN":
            self.ChangesOnlyOutput = False

    # Funktion um die neuen Einträge ins File zu schreiben. chkFile ruft Funktion auf um zu überprüfen ob File
    # existiert oder erstellt werden muss. Danach wird Zeile ausgegeben und ins File geschrieben, danach File
    # geschlossen.
    def writelines(self, row):
        self.CSV_File = MyLogger.chkFile()
        print(row)
        self.CSV_File.write(row + "\n")
        self.CSV_File.close()

# Input Variablen, frag nach allen nötigen Informationen nach, wenn nichts angegeben wird ein default gesetzt.
file_kind_default = "n"
file_kind = input("Soll ein neues oder bestehendes File verwendet werden (n=neu, a=bestehend): ") or file_kind_default
while file_kind != "n" and file_kind != "a":
    file_kind = input("Bitte n oder a eingeben: ")
file_path = input("Pfad eingeben [Default: jetziger Pfad]: ")
file_name_default = "Log"
file_name = input("Datei-Name eingeben ohne Endung: ") or file_name_default
filepathname = file_path + file_name + ".csv"
delimiter_default = "|"
delimiter = input("Welches Trennzeichen soll verwendet werden [Default: | ]: ") or delimiter_default
setLogLevel_default = "INFO"
setLogLevel = input("Log Level eingeben (Debug, Info, Warning, Error, Critical): ") or setLogLevel_default
while setLogLevel.upper() != "DEBUG" and setLogLevel.upper() != "INFO" and setLogLevel.upper() != "WARNING" and \
        setLogLevel.upper() != "ERROR" and setLogLevel.upper() != "CRITICAL":
    setLogLevel = input("Bitte schreibe einen der Log-Level (Debug, Info, Warning, Error, Critical)!: ")
ort_default = "Uster"
ort = input("Ort [Default: Uster]: ") or ort_default
max_counter = int(input("Anzahl Anfragen: ") or 5)
pollingTime = float(input("Warten zwischen Abfragen in Sekunden: ") or 1)
NumberOfLines = int(input("Wie viel Zeilen soll das File haben: ") or 100)
ChangesOnlyInputDefault = "NEIN"
ChangesOnlyInput = input("Nur Wetterveränderungen (Ja oder Nein): ") or ChangesOnlyInputDefault
while ChangesOnlyInput.upper() != "JA" and ChangesOnlyInput.upper() != "NEIN":
    ChangesOnlyInput = input("Bitte schreibe Ja oder Nein!: ")

# setzten der Variablen, um Veränderungen festzustellen
recentTemp = ""
recentPressure = ""
recentHumidity = ""
recentCloud = ""
recentWindSpeed = ""
recentWindDirection = ""

# Variablen für Webseite und Token
serviceURL = "https://api.openweathermap.org/data/2.5/weather"
appId = "b0378a9d3f509467c05aa6a43563a4e9"

# Aufruf der Logger. Überprüft ob file existiert, wenn nein wird Header erstellt. Setzt true oder false,
# ob Veränderungen berücksichtigt werden sollen
MyLogger = Logger(filepathname, delimiter=delimiter, NumberOfLines=NumberOfLines)
MyLogger.ChangesOnly(ChangesOnlyInput)
if not MyLogger.file_exist:
    MyLogger.crHeader(delimiter)

# Loop der Antwort Werten der Webseite und werden im vorgegebenen Format erstellt.
counter = 0
doLoop = True
while doLoop:
    counter += 1
    responseStr = requests.get(serviceURL + "?q=" + ort + "&units=metric&lang=de&appid=" + appId)
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
    try:
        if (MyLogger.ChangesOnlyOutput == True) and (
                recentTemp != temp or recentPressure != pressure or recentHumidity != humidity or recentCloud != cloud or recentWindSpeed != windSpeed or recentWindDirection != windDirection):
            MyLogger.writelines(
                MyLogger.getTimestamp() + delimiter + setLogLevel.upper() + delimiter + str(
                    ortsname) + delimiter + str(
                    land) + delimiter + str(lon) + '/' + str(lat) + delimiter + str(temp) + delimiter + str(
                    pressure) + delimiter + str(humidity) + delimiter + str(cloud) + delimiter + str(
                    windSpeed) + delimiter + str(windDirection))
        elif not MyLogger.ChangesOnlyOutput:
            MyLogger.writelines(
                MyLogger.getTimestamp() + delimiter + setLogLevel.upper() + delimiter + str(
                    ortsname) + delimiter + str(
                    land) + delimiter + str(lon) + "/" + str(lat) + delimiter + str(temp) + delimiter + str(
                    pressure) + delimiter + str(humidity) + delimiter + str(cloud) + delimiter + str(
                    windSpeed) + delimiter + str(windDirection))
    except FileNotFoundError:
        print("ERROR: Die Datei konnte nicht gefunden werden")
    finally:
        recentTemp = temp
        recentPressure = pressure
        recentHumidity = humidity
        recentCloud = cloud
        recentWindSpeed = windSpeed
        recentWindDirection = windDirection

    # Wartet, falls Wetterveränderungen wichtig sind 2 Minuten und geht weiter, falls Wetterveränderungen nicht
    # wichtig sind wartet nur anzahl angegebene Sekunden
    if MyLogger.ChangesOnlyOutput:
        time.sleep(120)
        print("Keine Wetterveränderungen innerhalb der letzten 2 Minuten, Programm endet...")
        break
    else:
        time.sleep(pollingTime)

    # Überprüft die ausgegebene Anzahl Zeilen, wenn Max erreicht wird, wird Loop beendet.
    if counter >= max_counter:
        doLoop = False

# While Loop, löscht alte Einträge die NumberOfFiles überschreiten
while NumberOfLines < MyLogger.getLine(filepathname) - 2:
    MyLogger.deleteLines(filepathname)