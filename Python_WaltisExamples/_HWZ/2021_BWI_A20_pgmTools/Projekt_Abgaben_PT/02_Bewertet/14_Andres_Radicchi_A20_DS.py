# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und User Input ist möglich
#      - Startime nicht im Header
#      - Unsinnige User-Eingaben können zum Absturz führen
#      - Runden nicht implementiert
#
# Class Design und Implementation:
#      + Eigene Klasse vorhanden
#      - unnötige module instanziert (tkinter?)
#      - Notwendige (__eq__ __str__ ) Methoden nicht implementiert
#      - __init__ wichtige Parameter fehlen und haben keine sinnvolle Default-Werte
#      - Alle Instance Variablen sind public
#      + OnlyChanges implementiert
#      - Ringbuffer mit fixer Grösse implementiert
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
import datetime
import json
import os
import time
import tkinter


import requests as requests

# Klasse LoggerNachricht erstellen
class LoggerNachricht:
    zeitstempel = ''
    logLevel = ''
    nachricht = ''
    delimiter = ''

    def __init__(self, nachricht, delimiter="|"):
        self.zeitstempel = datetime.datetime.now(tz=None).__str__()
        self.logLevel = "INFO"
        self.nachricht = str(nachricht)
        self.delimiter = delimiter

    def __str__(self):
        return self.zeitstempel + self.delimiter + self.logLevel + self.delimiter + self.nachricht

# Klasse Logger erstellen
class Logger:
    pfad = ''
    dateiname = ''
    scrollLimit = 0
    aufzeichnungsStrategie = ''
    logObjekt = LoggerNachricht

    def __init__(self, pfad, dateiname, scrollLimit, aufzeichnungsStrategie, logObjekt, delimiter='|'):
        self.pfad = pfad
        self.dateiname = dateiname
        self.scrollLimit = scrollLimit
        self.aufzeichnungsStrategie = aufzeichnungsStrategie
        self.delimiter = delimiter
        self.logObjekt = LoggerNachricht(logObjekt, delimiter)

    # Logging Funktion erstellen
    def logging(self):
        filePfad = self.pfad + self.dateiname
        kopfZeile = '<Name>' + filePfad + '</Name>' + '\n' + 'Timestamp' + self.delimiter \
        + ' LogLevel' + self.delimiter + ' Temperature' \
        + self.delimiter + ' Pressure' + self.delimiter + ' Humidity' + self.delimiter \
        + ' Lon' + self.delimiter + ' Lat' + self.delimiter + ' Cloud'

        if os.path.exists(filePfad) == False:
            Logger.schreibeFile(filePfad, "w", kopfZeile)
        # Aufzeichnungsstrategie abfragen ob nur bei einer Änderung geloggt werden soll, sonst interval
        if self.aufzeichnungsStrategie == "bei änderung" or self.aufzeichnungsStrategie == "änderung" or self.aufzeichnungsStrategie == "aenderung":
            lines = Logger.leseFile(filePfad)
            if str(self.logObjekt.nachricht) in lines[-1]:
                return
            else:
                Logger.ringBuffer(filePfad)
                Logger.schreibeFile(filePfad, "a", self.logObjekt)
        else:
            Logger.ringBuffer(filePfad)
            Logger.schreibeFile(filePfad, "a", self.logObjekt)
    # Datei schreiben
    def schreibeFile(filePfad, schreibMethode, inhalt):
        with open(filePfad, schreibMethode) as logfile:
            logfile.write(str(inhalt) + "\n")
    # Bestehendes File ergönzen
    def ueberschreibeLinien(filePfad, inhalt):
        with open(filePfad, "w") as logfile:
            logfile.writelines(inhalt)
    # Datei lesen
    def leseFile(filePfad):
        with open(filePfad, "r") as logfile:
            return logfile.readlines()
    # Ringbuffer zur Überprüfung dass nach 10 Log-Zeilen ab der 3.ten Zeile überschrieben werden soll.
    def ringBuffer(filePfad):
        lines = Logger.leseFile(filePfad)
        if len(lines) == 12:
            Logger.ueberschreibeLinien(filePfad, lines[:2] + lines[3:])

# Klasse WetterApplikation erstellen
class WetterApplikation:
    file = "Wetter_Zuerich.csv"
    # Inputfragen definieren bezüglich Auffzeichnungsstrategie

    abfrage = 1

    aufzeichnungsStrategie = str(input('Bei Änderung oder als Interval? ')).lower()
    if aufzeichnungsStrategie == "interval" or aufzeichnungsStrategie == "als interval":
        abfrage = float(input('Abfrage in Sekunden: '))

    appId = '18571f91cda2396fb8c116af225c8c29'
    root = tkinter.Tk()
    root.withdraw()

    ordnerPfad = os.getcwd()

    print(ordnerPfad + "\\" + file)

    while True:
        responseStr = requests.get('http://api.openweathermap.org/data/2.5/weather?q=zuerich&appid=' + appId)
        jsonResponse = json.loads(responseStr.text)
        temperature = jsonResponse['main']['temp'].__str__()
        pressure = jsonResponse['main']['pressure'].__str__()
        humidity = jsonResponse['main']['humidity'].__str__()
        lon = jsonResponse['coord']['lon'].__str__()
        lat = jsonResponse['coord']['lat'].__str__()
        cloud = jsonResponse['weather'][0]['description']
        logger = Logger(ordnerPfad + '\\', file, 10, aufzeichnungsStrategie, temperature + ', ' + pressure + ', ' + humidity + ', ' + lon + ', ' + lat + ', ' + cloud, ",")
        logger.logging()

        print(temperature, pressure, humidity, lon, lat, cloud)
        time.sleep(abfrage)