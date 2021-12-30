# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Reference-Applikation mit User-Input
#      + Schreibt logfile
#      - Kein Titel mit creation timestamp im Header und XML Syntax
#      + Unsinnige User-Eingaben werden abgefangen
#      - Ringbuffer size  kann nicht gewählt werden
#
# Class Design und Implementation:
#      - Keine eigene Klassen vorhanden
#      - Notwendige (__eq__) Methoden nicht implementiert
#      _ __init__ wichtige Parameter fehlen
#      + Default-Werte vorhanden
#      - All Instance Variablen sind public
#      - OnlyChanges nicht implementiert
#      - Ringbuffer nicht implementiert
#      - Exceptionhandling in der Klasse oder in der Applikation
#
# Test:
#      - keine Reusable Tests implementiert
#
# Note: 4.0
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wo haben Sie den Ringbuffer implementiert
#    Wo haben Sie den ChangeOnly Mode implementiert
# ------------------------------------------------------------------
# ------------------------------------------------------------------
# Name: Marco_Yfantis_A19_DS.py
#
# Leistungsnachweis 3. Semester
#
# Autor: Marco Yfantis
#
# ------------------------------------------------------------------

# Imports
import requests
import json
import time
from datetime import datetime
import csv
import logging
import os.path

# Grundlagen *****

# Für Datenabfrage
serviceURL = "https://api.openweathermap.org/data/2.5/weather"
appId = "15de2e174e3caeab75c27dd029ed4fbe"

# Für spätere Ausgabe des Pfadnamens
# https://www.delftstack.com/de/howto/python/how-to-get-the-current-script-file-directory/
path = os.getcwd()


# Für spätere Ausgabe des Filenamens
filename = "Marco_Yfantis_A19_DS"

# Für spätere Ausgabe des Erstellungsdatum
timenow = datetime.now()
current_time = timenow.strftime("%H:%M:%S")

# Ob neue Datei oder bestehende
csvfilename = input("Bitte Name einer bestehenden CSV-Datei oder Name der gewünschten neuen CSV-Datei angeben (nur Dateiname ohne '.csv'): ")


# Grundlagen Ende *****

# CSV-File öffnen/erstellen und Header schreiben
kopfzeile_pfad = ["#" + path, filename, current_time]
kopfzeile_beschriftung = ["Timestamp", "Level", "Ort", "Temperatur", "Wetter"]
with open(csvfilename+".csv", "a", encoding="UTF-8", newline="") as csv_schreiben:
    if os.stat(csvfilename+".csv").st_size > 0:
        pass
    else:
        writer = csv.DictWriter(csv_schreiben, delimiter=';', fieldnames=kopfzeile_pfad)
        writer.writeheader()
        writer = csv.DictWriter(csv_schreiben, delimiter=';', fieldnames=kopfzeile_beschriftung)
        writer.writeheader()


"""
class Logger:
    def __init__(self, logschreiben="a", delimeter="|", maxlogs=1000):
        self.filename = csvfilename+".csv"
        self.logschreiben = logschreiben
        self.delimeter = delimeter
        self.maxlogs = maxlogs
"""

# Logger definieren
# https://www.youtube.com/watch?v=jxmzY9soFXg&ab_channel=CoreySchafer

Logger = logging.getLogger()
Logger.setLevel(logging.INFO)
formatter = logging.Formatter("%(asctime)s; %(levelname)s; %(message)s",
                              "%Y-%m-%d %H:%M:%S")

file_handler = logging.FileHandler(csvfilename+".csv")
file_handler.setFormatter(formatter)
Logger.addHandler(file_handler)

# Schleife Abfrage im Sekundentakt
while True:
    try:
        pollingTime = float(input("In welchem Sekundentakt möchtest du die Daten abfragen: "))
    except ValueError:
        print("Bitte erneut versuchen")
    else:
        break

# Schleife für Ort
while True:
    try:
        ort = input("Wähle Wetterdaten von 'Zürich', 'Basel' oder 'Luzern': ")
        if ort == "Zürich":
            break
        elif ort == "Basel":
            break
        elif ort == "Luzern":
            break
        else:
            print("ungültige Eingabe, bitte erneut versuchen")
    except ValueError:
        print("ungültige Eingabe, bitte erneut versuchen")

# Schleife für Einheit der Temperatur; nur metric oder imperial möglich
while True:
    try:
        einheit = input("Möchtest du die Temperatur in 'metric' oder 'imperial': ")
        if einheit == "metric":
            break
        elif einheit == "imperial":
            break
        else:
            print("ungültige Eingabe, bitte erneut versuchen")
    except ValueError:
        print("ungültige Eingabe, bitte erneut versuchen")

# Schleifen für Methodik Fixed oder Change
while True:
    try:
        Loggingart = input("Sollen alle Einträge (FixedSlices, tippe [1]) oder nur Einträge mit Änderungen (OnlyChanges, tippe [2]) geloggt werden: ")
        if Loggingart == "1":
            while True:
                response = requests.get(serviceURL + "?q=" + ort + "&units=" + einheit + "&lang=de&appid=" + appId)
                jsonResponse = json.loads(response.content)

                temp = jsonResponse['main']['temp']
                cloud = jsonResponse['weather'][0]['description']

                logging.info(str(ort) + ";" + str(temp) + ";" + str(cloud))
                time.sleep(pollingTime)

        elif Loggingart == "2":
            while True:
                response = requests.get(serviceURL + "?q=" + ort + "&units=" + einheit + "&lang=de&appid=" + appId)
                jsonResponse = json.loads(response.content)

                temp = jsonResponse['main']['temp']
                cloud = jsonResponse['weather'][0]['description']

                # Hier wird geprüft, ob der 2. Letzte Eintrag im dictionary des letzten logs dem neuen entspricht
                with open(csvfilename+".csv", "r") as logFile:
                    letztezeile = logFile.readlines()[-1]
                    listeletztezeile = letztezeile.split(";")
                    if listeletztezeile[-2] != str(temp):
                        logging.info(str(ort) + ";" + str(temp) + ";" + str(cloud))
                time.sleep(pollingTime)

        else:
            print("ungültige Eingabe, bitte erneut versuchen")
    except ValueError:
        print("ungültige Eingabe, bitte erneut versuchen")
