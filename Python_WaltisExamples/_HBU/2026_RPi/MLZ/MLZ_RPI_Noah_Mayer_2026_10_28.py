#!/usr/bin/python

import datetime
import requests
import json
import time
import os


# ---------------------------------------------------------
# LOGGER-KLASSE
# ---------------------------------------------------------

class Logger:

    def __init__(self, dateiname="weatherLog.csv", delimiter="|", strategie="Always"):
        self.__dateiname = dateiname
        self.__delimiter = delimiter
        self.__strategie = strategie
        self.__anzahl = 0
        self.__letzte_daten = None

        # Neue Datei mit zwei Kopfzeilen erstellen, falls sie noch nicht existiert
        if not os.path.exists(self.__dateiname):
            datei = open(self.__dateiname, "w")

            datum = datetime.datetime.now()
            datei.write("# Datei: " + self.__dateiname + " | Erstellt: " + str(datum) + "\n")
            datei.write("Timestamp" + self.__delimiter + "Level" + self.__delimiter + "Daten\n")

            datei.close()


    # Setter und Getter
    # -----------------

    def set_strategie(self, strategie):
        self.__strategie = strategie

    def get_strategie(self):
        return self.__strategie

    def get_dateiname(self):
        return self.__dateiname

    def set_delimiter(self, delimiter):
        self.__delimiter = delimiter

    def get_delimiter(self):
        return self.__delimiter

    def get_anzahl(self):
        return self.__anzahl


    # Business-Methods
    # ----------------

    def add_to_log(self, daten, level="INFO"):

        # Bei OnlyChanges werden gleiche Daten nicht erneut gespeichert
        if self.__strategie == "OnlyChanges":
            if daten == self.__letzte_daten:
                print(daten, "-> Nicht gespeichert")
                return False

        datum = datetime.datetime.now()
        zeit = datetime.datetime.strftime(datum, "%Y-%m-%d %H:%M:%S")

        eintrag = zeit + self.__delimiter + level + self.__delimiter + str(daten)

        datei = open(self.__dateiname, "a")                # Neue Einträge anhängen
        datei.write(eintrag + "\n")
        datei.close()

        self.__anzahl += 1
        self.__letzte_daten = daten

        return True


    # Operator Overloading
    # --------------------

    def __str__(self):
        text = "Datei: " + self.__dateiname + "\n"
        text += "Strategie: " + self.__strategie + "\n"
        text += "Trennzeichen: " + self.__delimiter + "\n"
        text += "Neue Eintraege: " + str(self.__anzahl)
        return text


# =========================================================
# HAUPTPROGRAMM / TEST DER KLASSE
# =========================================================

if __name__ == '__main__':

    print("----------------------------------------")
    print("             WEATHER LOGGER")
    print("----------------------------------------")

    logger = Logger("weatherLog.csv", "|", "OnlyChanges")

    print("\nLogger gestartet!")
    print("Datei:", logger.get_dateiname())
    print("Strategie:", logger.get_strategie())
    print("Trennzeichen:", logger.get_delimiter())

    print("\n----------------------------------------")
    print("TEST DER LOG-FUNKTION")
    print("----------------------------------------")

    # Test der verschiedenen Log-Level und der OnlyChanges-Strategie
    logger.add_to_log("Testmeldung", "DEBUG")
    logger.add_to_log("Testmeldung", "DEBUG")
    logger.add_to_log("Logger gestartet", "INFO")
    logger.add_to_log("Warnung", "WARNING")
    logger.add_to_log("Fehlermeldung", "ERROR")
    logger.add_to_log("Kritischer Fehler", "CRITICAL")


    # -----------------------------------------------------
    # WETTERDATEN
    # -----------------------------------------------------

    print("\n----------------------------------------")
    print("WETTERDATEN")
    print("----------------------------------------")

    ort = input("Ort: ")

    # Solange kein Standort eingegeben wird, erneut nachfragen
    while ort == "":
        print("Bitte zuerst einen Standort eingeben!")
        ort = input("Ort: ")


    url = input("URL [Enter = Standard-URL]: ")

    if url == "":
        url = "https://api.openweathermap.org/data/2.5/weather"
        print("Standard-URL wird verwendet!")
    else:
        print("Eigene URL wird verwendet!")


    api_key = "5bf22f4fcb0ed9bfe0c4f1ea777da948"     # Persönlicher OpenWeatherMap API-Key


    sample_time = float(input("Sample-Time [s]: "))
    anzahl_abfragen = int(input("Anzahl Abfragen: "))


    # Einstellungen für die Wetterabfrage
    parameter = {
        "q": ort,
        "appid": api_key,
        "units": "metric",
        "lang": "de"
    }


    # -----------------------------------------------------
    # WETTERABFRAGEN
    # -----------------------------------------------------

    for nummer in range(anzahl_abfragen):

        print("\nWetterabfrage", nummer + 1)

        try:
            antwort = requests.get(url, params=parameter, timeout=10)
            antwort.raise_for_status()                     # HTTP-Fehler erkennen

            wetter = json.loads(antwort.text)              # JSON-Antwort verarbeiten

            temperatur = round(wetter["main"]["temp"], 1)
            feuchtigkeit = wetter["main"]["humidity"]
            druck = wetter["main"]["pressure"]
            beschreibung = wetter["weather"][0]["description"]

            print("Ort:", ort)
            print("Temperatur:", temperatur, "Grad")
            print("Luftfeuchtigkeit:", feuchtigkeit, "%")
            print("Luftdruck:", druck, "mBar")
            print("Wetter:", beschreibung)

            # Wetterdaten für die CSV-Datei zusammenfügen
            daten = str(temperatur) + logger.get_delimiter()
            daten += str(feuchtigkeit) + logger.get_delimiter()
            daten += str(druck) + logger.get_delimiter()
            daten += beschreibung

            logger.add_to_log(daten, "INFO")

        except requests.exceptions.RequestException as fehler:
            print("Fehler beim Abrufen der Wetterdaten!")
            print("Grund:", fehler)
            logger.add_to_log("Wetterabfrage fehlgeschlagen", "ERROR")

        # Wartezeit nur zwischen den einzelnen Abfragen
        if nummer < anzahl_abfragen - 1:
            time.sleep(sample_time)


    # -----------------------------------------------------
    # ZUSAMMENFASSUNG
    # -----------------------------------------------------

    print("\n----------------------------------------")
    print("ZUSAMMENFASSUNG")
    print("----------------------------------------")

    print(logger)

    print("\nProgramm erfolgreich beendet!")
    print("----------------------------------------")