#!/usr/bin/python3
# ============================================================
# MLZ_RPI_Langhans_Kilian_2025_01_14.py
# MLZ Abschlussprüfung Python Programm
# Datum:        14.01.2026
# Autor:        Kilian Langhans
# Klasse:       24E
# ------------------------------------------------------------
# Beschreibung / Aufgabenstellung:
# Schreiben einer eigenen, wiederverwendbaren Logger-Klasse,
# welche strukturierte Log-Daten in ein CSV-File schreibt.
#
# - Konfigurierbarer Header (Kommentar + Titelzeile)
# - Log-Level, Timestamp
# - Log-Strategien (Always / OnlyChanges)
# - CLI-Testapplikation im gleichen File
# -------------------------------------------------------------
# Bemerkung:
# Hoffentlich ist es in Ordnung, dass ich in dieser Arbeit
# meine Benennung in Deutsch vorgenommen habe,
# ausgenommen einiger Fachbegriffe, die auf Englisch benannt wurden.
# ============================================================

#Imports
import os
import time
import datetime
import requests
# -------------------------------------------------------------

# Klasse 1: DatenLogger
class DatenLogger:
    def __init__(
        self,
        speicherpfad=os.path.dirname(os.path.abspath(__file__)),
        dateiname="Datenlogger-Daten.txt",
        trennzeichen="|",
        append=False,
        separator=".",
    ):
        self.__speicherpfad = speicherpfad
        self.__dateiname = dateiname
        self.__trennzeichen = trennzeichen
        self.__append = append
        self.__separator = separator
        
        #Methoden Klasse1
        self.__schreibe_header()

    def __str__(self):
        return (
            f"Speicher-Pfad: {self.__speicherpfad}\n"
            f"Dateiname    : {self.__dateiname}\n"
            f"Trennzeichen : '{self.__trennzeichen}'\n"
            f"Anhängen/Neu : {self.__append}\n"
            f"Separator    : '{self.__separator}'"
        )

    # --------------------------
    # interne Helfer
    # --------------------------
    def __vollpfad(self):
        return os.path.join(self.__speicherpfad, self.__dateiname)

    def __schreibe_header(self):
        vollpfad = self.__vollpfad()
        os.makedirs(self.__speicherpfad, exist_ok=True)

        modus = "a" if (self.__append and os.path.exists(vollpfad)) else "w"

        # Header nur schreiben, wenn Datei neu ist (oder append=False)
        if modus == "w":
            created = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            with open(vollpfad, "w", encoding="utf-8") as f:
                # 1. Zeile: Kommentar / Metadaten
                f.write(
                    f"# <Filename>{vollpfad}</Filename>"
                    f"<Created>{created}</Created>\n"
                )

                # 2. Zeile: Titelzeile (Spalten)
                f.write(
                    f"timestamp{self.__trennzeichen}"
                    f"level{self.__trennzeichen}"
                    f"ort{self.__trennzeichen}"
                    f"temp{self.__trennzeichen}"
                    f"pressure{self.__trennzeichen}"
                    f"humidity{self.__trennzeichen}"
                    f"main{self.__trennzeichen}"
                    f"description\n"
                )

    # --------------------------
    # öffentliche Methode
    # --------------------------
    def log(self, level, daten: dict):
        vollpfad = self.__vollpfad()
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        werte = [
            timestamp,
            str(level),
            str(daten.get("ort", "")),
            str(daten.get("temp", "")),
            str(daten.get("pressure", "")),
            str(daten.get("humidity", "")),
            str(daten.get("main", "")),
            str(daten.get("description", "")),
        ]

        zeile = self.__trennzeichen.join(werte) + "\n"

        with open(vollpfad, "a", encoding="utf-8") as f:
            f.write(zeile)


# -------------------------------------------------------------
# Klasse 2: Wetterabfrage (OpenWeather)
class Wetterabfrage:
    def __init__(
        self,
        ort="Zuerich",
        intervall=1.0,
        appid="e72daa3d7768cba72d0376e0b0d86d38",
        sprache="de",
    ):
        self.__ort = ort
        self.__intervall = float(intervall)
        self.__appid = appid
        self.__sprache = sprache

        # wichtig: muss existieren, sonst AttributeError
        self.__url = "http://api.openweathermap.org/data/2.5/weather"

    def get_intervall(self):
        return self.__intervall

    def hole_daten(self):
        params = {
            "q": self.__ort,
            "appid": self.__appid,
            "units": "metric",
            "lang": self.__sprache,
        }

        response = requests.get(self.__url, params=params, timeout=10)
        response.raise_for_status()
        j = response.json()

        return {
            "ort": self.__ort,
            "temp": j["main"]["temp"],
            "pressure": j["main"]["pressure"],
            "humidity": j["main"]["humidity"],
            "main": j["weather"][0]["main"],
            "description": j["weather"][0]["description"],
        }


# -------------------------------------------------------------
# Main
def main():
    
    print("""
*****************************************************
Willkommen in meinem Wetter-Programm.
In diesem Programm ist eine unabhängige
Datenloggerklasse einprogrammiert, die zum Austesten
hier mit Wetterdaten gefüllt werden kann.
Bitte nachfolgend die gewünschten Parameter eingeben.
*****************************************************
""")

    # --------------------------
    # Eingaben Wetter
    # --------------------------
    print("Ortschaft der Wetterdaten? (Default: Zuerich)")
    ort = input("Ort: ").strip()
    if ort == "":
        ort = "Zuerich"

    loop = True
    while loop:
        print("Wie oft abfragen? (Sekunden, >=1) (Default: 1)")
        eingabe = input("Sekunden: ").strip()

        if eingabe == "":
            intervall = 1.0
            loop = False
        else:
            try:
                intervall = float(eingabe)
                if intervall >= 1:
                    loop = False
                else:
                    print("Eingabe ungültig: Zahl muss >= 1 sein.")
            except ValueError:
                print("Eingabe ungültig: Bitte eine Zahl eingeben (z.B. 1 oder 2.5).")

    # Sprache Deutsch
    sprache = "de"


    # Eingaben für Logger
    print("Dateiname für das Log-File? (Default: Datenlogger-Daten.txt)")
    dateiname = input("Dateiname: ").strip()
    if dateiname == "":
        dateiname = "Datenlogger-Daten.txt"

    print('Trennzeichen für die Datei? (Default: "|")')
    trennzeichen = input("Trennzeichen: ").strip()
    if trennzeichen == "":
        trennzeichen = "|"

    print("An bestehende Log-Datei anhängen? (j/n) (Default: n)")
    append_in = input("Anhängen: ").strip().lower()
    if append_in in ("j", "ja"):
        append = True
    else:
        append = False

    print(f"\nGewünschte Parameter: Ort = {ort}, Abfrage-Intervall = {intervall} Sekunden")


    # Objekte erstellen
    wetter = Wetterabfrage(ort=ort, intervall=intervall, sprache=sprache)
    logger = DatenLogger(
        dateiname=dateiname,
        trennzeichen=trennzeichen,
        append=append,
    )

    print("\nLogger-Konfiguration:")
    print(logger)

    print("\nStarte Wetter-Logging... (CTRL+C zum Beenden)")

    try:
        while True:
            daten = wetter.hole_daten()

            # Rundung/Formatierung AUSSERHALB Logger (wie gefordert)
            daten["temp"] = round(float(daten["temp"]), 2)

            logger.log("INFO", daten)
            print(daten)

            time.sleep(intervall)

    except KeyboardInterrupt:
        print("\nProgramm beendet.")


if __name__ == "__main__":
    main()
