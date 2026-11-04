#!/usr/bin/python3
# ------------------------------------------------------------------
# Name: MLZ_RPI_Egli_Christopher_2026_10_28_optimiert.py
# Original: WeatherLogger_05.py (Walter Rothlin)
# Quelle: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_05.py
# Beschreibung: Wetterdaten per REST-API abrufen und in CSV speichern.
# Autor: Christopher Egli
#
# History:
# 28-Oct-2026  Christopher Egli  Logger und Wetterabfrage angepasst
# 28-Oct-2026  Christopher Egli  Logger und Wetterabfrage getestet
# 28-Oct-2026  Christopher Egli  Append und Scrolling ergänzt
# 28-Oct-2026  Christopher Egli  Append und Scrolling getestet
# 28-Oct-2026  Christopher Egli  REST-API-URL über Benutzereingabe konfigurierbar gemacht
# 28-Oct-2026  Christopher Egli  Programm überprüft
#
# KI-Unterstützung: ChatGPT wurde für Erklärungen,Fehlersuche, Codevorschläge, Tests und Überarbeitung verwendet.
# Vorschläge wurden teilweise übernommen und angepasst.
# ------------------------------------------------------------------

import datetime
import time
from pathlib import Path

import requests


# ---------------------------------------------------------------
# Logger-Klasse
# ---------------------------------------------------------------
class Logger:
    """Schreibt Datensätze in eine CSV-formatierte Textdatei."""

    # ---------------------------------------------------------------
    # Initializer
    # ---------------------------------------------------------------
    def __init__(self, filename="Wetter_Logger.txt", delimiter=";", columns=None,
                 strategy="Always", max_entries=100, append=True):
        self._filename = filename
        self._delimiter = delimiter
        self._columns = columns if columns is not None else ["Temperatur", "Druck", "Feuchtigkeit"]
        self._start_time = datetime.datetime.now()
        self._last_data = None
        self._append = append
        self.strategy = strategy
        self.max_entries = max_entries
        self._create_header()

    # ---------------------------------------------------------------
    # Properties: Dateiname
    # ---------------------------------------------------------------
    @property
    def filename(self):
        return self._filename

    @filename.setter
    def filename(self, value):
        self._filename = value

    # ---------------------------------------------------------------
    # Properties: Trennzeichen
    # ---------------------------------------------------------------
    @property
    def delimiter(self):
        return self._delimiter

    @delimiter.setter
    def delimiter(self, value):
        self._delimiter = value

    # ---------------------------------------------------------------
    # Property: Aufzeichnungsstrategie
    # ---------------------------------------------------------------
    @property
    def strategy(self):
        return self._strategy

    @strategy.setter
    def strategy(self, value):
        if value not in ("Always", "OnlyChanges"):
            raise ValueError("Ungültige Logger-Strategie")
        self._strategy = value

    # ---------------------------------------------------------------
    # Property: Maximale Anzahl Log-Einträge
    # ---------------------------------------------------------------
    @property
    def max_entries(self):
        return self._max_entries

    @max_entries.setter
    def max_entries(self, value):
        if type(value) is not int or value <= 0:
            raise ValueError("max_entries muss eine positive Ganzzahl sein")
        self._max_entries = value

    # ---------------------------------------------------------------
    # Header erstellen
    # ---------------------------------------------------------------
    def _create_header(self):
        path = Path(self._filename)
        if self._append and path.exists() and path.stat().st_size > 0:
            # Beim Anhängen müssen die Spalten zur vorhandenen Datei passen.
            with path.open("r", encoding="utf-8") as file:
                file.readline()
                existing_columns = file.readline().rstrip("\r\n")
            expected = self._delimiter.join(["Timestamp", "Level"] + self._columns)
            if existing_columns != expected:
                raise ValueError("Spalten der bestehenden Logdatei stimmen nicht überein")
            return

        header = (
            f"# <Filename>{path.name}</Filename>"
            f"<Created>{self._start_time:%Y-%m-%d %H:%M:%S}</Created>"
        )
        columns = self._delimiter.join(["Timestamp", "Level"] + self._columns)
        with path.open("w", encoding="utf-8") as file:
            file.write(header + "\n" + columns + "\n")

    # ---------------------------------------------------------------
    # Scrolling: Alte Log-Einträge entfernen
    # ---------------------------------------------------------------
    def _scroll_log(self):
        path = Path(self._filename)
        with path.open("r", encoding="utf-8") as file:
            lines = file.readlines()
        if len(lines) - 2 > self._max_entries:
            with path.open("w", encoding="utf-8") as file:
                file.writelines(lines[:2] + lines[-self._max_entries:])

    # ---------------------------------------------------------------
    # Log-Eintrag hinzufügen
    # ---------------------------------------------------------------
    def add_to_log(self, data, level="INFO"):
        if level not in ("DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"):
            raise ValueError("Ungültiges Log-Level")
        if len(data) != len(self._columns):
            raise ValueError("Falsche Anzahl Datenwerte")

        current_data = [str(value) for value in data]
        if self._strategy == "OnlyChanges" and current_data == self._last_data:
            return False

        # Zeitstempel erstellen
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        entry = self._delimiter.join([timestamp, level] + current_data)
        with open(self._filename, "a", encoding="utf-8") as file:
            file.write(entry + "\n")
        self._last_data = current_data.copy()
        self._scroll_log()
        return True

    # ---------------------------------------------------------------
    # Logger-Informationen anzeigen
    # ---------------------------------------------------------------
    def __str__(self):
        with open(self._filename, "r", encoding="utf-8") as file:
            count = max(0, sum(1 for _ in file) - 2)
        return (
            f"Datei: {self._filename}\n"
            f"Trennzeichen: {self._delimiter}\n"
            f"Strategie: {self._strategy}\n"
            f"Maximale Einträge: {self._max_entries}\n"
            f"Aktive Einträge: {count}\n"
            f"Startzeit: {self._start_time:%Y-%m-%d %H:%M:%S}"
        )


# Tests verwenden ausschliesslich separate Testdateien.
# ---------------------------------------------------------------
# Test der Logger-Klasse
# ---------------------------------------------------------------
def test_logger():
    logger = Logger("MLZ_Test.txt", columns=["Temperatur", "Druck", "Feuchtigkeit"], append=False)
    assert logger.filename == "MLZ_Test.txt"
    assert logger.delimiter == ";"
    logger.add_to_log([12.5, 1015, 78])
    with open(logger.filename, encoding="utf-8") as file:
        lines = file.readlines()
    assert len(lines) == 3
    assert lines[1].strip() == "Timestamp;Level;Temperatur;Druck;Feuchtigkeit"
    assert lines[2].strip().endswith(";INFO;12.5;1015;78")
    print("Logger-Test erfolgreich!")


# ---------------------------------------------------------------
# Test der Scrolling-Funktion
# ---------------------------------------------------------------
def test_scrolling():
    logger = Logger("MLZ_Scrolling_Test.txt", columns=["Temperatur"],
                    max_entries=3, append=False)
    for value in range(1, 6):
        logger.add_to_log([value])
    with open(logger.filename, encoding="utf-8") as file:
        lines = file.readlines()
    assert len(lines) == 5
    assert [line.strip().split(";")[-1] for line in lines[2:]] == ["3", "4", "5"]
    print("Scrolling-Test erfolgreich!")


# ---------------------------------------------------------------
# Test der Append-Funktion
# ---------------------------------------------------------------
def test_append():
    filename = "MLZ_Append_Test.txt"
    logger = Logger(filename, columns=["Temperatur"], append=False)
    logger.add_to_log([20])
    logger = Logger(filename, columns=["Temperatur"], append=True)
    logger.add_to_log([25])
    with open(filename, encoding="utf-8") as file:
        lines = file.readlines()
    assert len(lines) == 4
    assert lines[2].strip().endswith(";20")
    assert lines[3].strip().endswith(";25")
    print("Append-Test erfolgreich!")


# ---------------------------------------------------------------
# Test der Aufzeichnungsstrategien
# ---------------------------------------------------------------
def test_strategies():
    logger = Logger("MLZ_Strategy_Test.txt", columns=["Temperatur"],
                    strategy="OnlyChanges", append=False)
    assert logger.add_to_log([20]) is True
    assert logger.add_to_log([20]) is False
    assert logger.add_to_log([21]) is True
    logger.strategy = "Always"
    assert logger.add_to_log([21]) is True
    with open(logger.filename, encoding="utf-8") as file:
        assert len(file.readlines()) == 5
    print("Strategie-Test erfolgreich!")


# ---------------------------------------------------------------
# Alle Testfunktionen ausführen
# ---------------------------------------------------------------
def run_tests():
    test_logger()
    test_scrolling()
    test_append()
    test_strategies()


# ---------------------------------------------------------------
# Wetterdaten abrufen
# ---------------------------------------------------------------
def get_weather_data(url, params):
    response = requests.get(url, params=params, timeout=10)
    response.raise_for_status()
    return response.json()


# ---------------------------------------------------------------
# Grundeinstellungen und Wetteraufzeichnung
# ---------------------------------------------------------------
def main():
    # OpenWeatherMap API-Schlüssel
    api_key = "0c1b6e24a256522a8d05dade87d61c6c"

    try:
        polling_time = float(input("Polling-Time [s] [60]: ") or "60")
        if polling_time <= 0:
            raise ValueError("Polling-Time muss grösser als 0 sein")
    except ValueError as error:
        print("Ungültige Polling-Time:", error)
        return

    ort = input("Ort [Esslingen,CH]: ") or "Esslingen,CH"
    sprache = input("Sprache [de,el,en,fr,it] [de]: ") or "de"
    default_url = "https://api.openweathermap.org/data/2.5/weather"
    url = input("REST-API-URL [Standard]: ") or default_url
    params = {"q": ort, "appid": api_key, "units": "metric", "lang": sprache}

    try:
        weather = get_weather_data(url, params)
        print("Verbindung zur Wetter-API erfolgreich!")
        print("Ort:", ort)
        print("Koordinaten:", weather["coord"])
    except (requests.exceptions.RequestException, KeyError, ValueError) as error:
        print("Fehler bei der ersten Wetterabfrage:", error)
        return

    logger = Logger(
        filename="Wetter_Logger.txt",
        columns=["Temp [°C]", "Druck [mBar]", "Feuchte [%]", "Bezeichnung", "Beschreibung"],
        strategy="OnlyChanges", max_entries=100, append=True
    )
    print("Logger initialisiert:\n", logger, sep="")

    try:
        while True:
            try:
                weather = get_weather_data(url, params)
                main_data = weather["main"]
                condition = weather["weather"][0]
                values = [main_data["temp"], main_data["pressure"], main_data["humidity"],
                          condition["main"], condition["description"]]
                logger.add_to_log(values, "INFO")
                print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                      "Temperatur:", values[0], "°C",
                      "Druck:", values[1], "mBar",
                      "Feuchtigkeit:", values[2], "%")
            except (requests.exceptions.RequestException, KeyError, ValueError, IndexError) as error:
                print("Fehler beim Abrufen der Wetterdaten:", error)
            time.sleep(polling_time)
    except KeyboardInterrupt:
        print("\nWetteraufzeichnung beendet.")


# ---------------------------------------------------------------
# Programmstart und Testauswahl
# ---------------------------------------------------------------
if __name__ == "__main__":
    # Für die Tests: python3 dateiname.py --test
    import sys
    if "--test" in sys.argv:
        run_tests()
    else:
        main()
