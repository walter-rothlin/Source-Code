# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Reference-Applikation mit User-Input
#      - Ort kann nicht ausgewählt werden
#      - Kein Titel mit creation timestamp im Header
#
# Class Design und Implementation:
#      + Eigene Klassen vorhanden
#      - Notwendige (__eq__ __str__ ) Methoden nicht implementiert
#      + __init__ wichtige Parameter vorhanden
#      + Default-Werte
#      - Alle Instance Variablen sind public
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
##

# File-Titel: Djellor_Simnica_BWIA20_DS
# Name: Wetter_Logger_Klasse
# Author: Djellor Simnica

## Importieren der Packages
import datetime
import json
import time
import csv
import pathlib
import requests

## Infos aus der Datei erhalten
def LinienVonDateiErhalten(filename):
    file = open(filename, "r")
    length = len(file.readlines())
    file.close()
    return length

## Alte Linien von der Datei entfernen
def AlteLinienLoeschen(filename):
    lines = []
    with open(filename, 'r') as fp:
        lines = fp.readlines()

    with open(filename, 'w') as fp:
        for number, line in enumerate(lines):
            if number not in [2]:
                fp.write(line)

## Datei kontrollieren
def DateiTesten():
    if pathlib.Path(filename).is_file():
        return open(filename, 'a', newline='')
    else:
        return open(filename, 'w', newline='')

##
class Logger_Klasse:

    ## Konstruieren der Logger Klasse
    def __init__(self, filename: str, onlyChanges=False, delimiter='|', headerColumns="", ringBuffer=100):
        self.csv_file = DateiTesten()
        self.ringBuffer = ringBuffer
        self.onlyChanges = onlyChanges
        self.lastRowLogged = ""


        Xml_Header_Format = "# <Name>{}</Name>"
        Column_Header_Format = "Timestamp" + delimiter + "Level" + delimiter + Column_Headers
        self.writeLine(Xml_Header_Format.format(filename), isHeader=True)
        self.writeLine(Column_Header_Format.format(headerColumns), isHeader=True)

    def writeLine(self, row, isHeader=False):
        self.csv_file = DateiTesten()
        if isHeader:
            self.csv_file.write(row + "\n")
        else:
            isRowAlreadyLogged = False
            rowToBeLoggedWithoutPrefix = row.split(";", 2)[2]
            if self.lastRowLogged == rowToBeLoggedWithoutPrefix:
                isRowAlreadyLogged = True
            self.lastRowLogged = rowToBeLoggedWithoutPrefix
            if isRowAlreadyLogged:
                if self.onlyChanges:
                    return
                else:
                    print(row)
                    self.csv_file.write(row + "\n")
            else:
                print(row)
                self.csv_file.write(row + "\n")
            if self.ringBuffer < LinienVonDateiErhalten(filename) - 2:
                AlteLinienLoeschen(filename)
        self.csv_file.close()

##
serviceURL = "https://api.openweathermap.org/data/2.5/weather"
appId = "74439ad15128c9e674906ab9256cf326"
delimiter = ";"

##
filename = input("Bitte Dateinamen mit .csv eingeben: ")
pollingTime = float(input("Bitte Polling-Time in [s] eintragen: "))
onlyChanges = input("Wollen Sie onlyChanges? Bitte mit [j|n] beantworten: ")
ringBuffer = int(input("Bitte Ringbuffer eintragen: "))
logLevel = input("Bitte Log-Level eingeben: ")

##
if onlyChanges == "j" or not onlyChanges:
    onlyChanges = True
else:
    onlyChanges = False

Columns = ["temp", "pressure", "humidity", "lon", "lat"]
Column_Headers = ""
for column in Columns:
    Column_Headers += column + delimiter

Log_Format = "{}" + delimiter + "{}"

logger = Logger_Klasse(filename, onlyChanges=onlyChanges, headerColumns=Column_Headers, delimiter=delimiter,
                ringBuffer=ringBuffer)

## Solange onlyChanges "True" ist, fortfahren mit den Daten
while True:
    responseStr = requests.get(serviceURL + "?q=Zurich&units=metric&lang=de&appid=" + appId)
    jsonResponse = json.loads(responseStr.text)
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']

    ## Umgang mit Ausnahmen
    try:
        logger.writeLine(Log_Format.format(datetime.datetime.now(), logLevel) + delimiter + str(temp) + delimiter +
                         str(pressure) + delimiter + str(humidity) + delimiter + str(lon) + delimiter + str(lat))
    except FileNotFoundError:
        print("Dieses File konnte nicht gefunden werden!")

    time.sleep(pollingTime)
