#!/usr/bin/python
# ------------------------------------------------------------------
# Name        : MLZ_RPI_Bachofen_Adrian_2026_10_28.py
# Beschreibung: Wiederverwendbare CSV-Logger-Klasse und Weather Logger
#               mit REST-Abfrage von OpenWeather.
# Autor       : Adrian Bachofen
# Datum       : 28.10.2026
# ------------------------------------------------------------------
from datetime import datetime
import os
import requests
import time

class Logger:
    """
    Logger für strukturierte CSV-Dateien mit Zeitstempel und Log-Level.
    
    Unterstützt die Strategien Always und OnlyChanges sowie eine
    optionale Begrenzung der gespeicherten Logeinträge.
    """
    def __init__(self, filename, append=False,
             timestamp_format="%Y-%m-%d %H:%M:%S",
             delimiter="|", strategy="Always",
             max_entries=0,
             columns=("Temp", "Druck", "Feuchte")):
        """
        Initialisiert den Logger und erstellt oder öffnet die Logdatei.
        
        append=False erstellt die Datei neu, append=True behält sie bei.
        max_entries=0 deaktiviert das automatische Scrollen.
        """
        self.__filename = filename
        self.__append = append
        self.__timestamp_format = timestamp_format
        self.__delimiter = delimiter
        self.__strategy = strategy
        self.__last_data = None
        self.__max_entries = max_entries
        self.__columns = list(columns)
        
        folder = os.path.dirname(self.__filename)
        
        if folder:
            os.makedirs(folder, exist_ok=True)
        
        if not append or not os.path.exists(self.__filename):
            self.__write_header()
        elif self.__strategy == "OnlyChanges":
            with open(self.__filename, "r") as file:
                lines = file.readlines()

            if len(lines) > 2:
                last_line = lines[-1].rstrip("\r\n")
                parts = last_line.split(self.__delimiter, 2)

                if len(parts) == 3:
                    self.__last_data = parts[2]
        
    #Business-Methode
    def add_to_log(self, data, level="INFO"):
        """
        Fügt einen neuen Eintrag mit Zeitstempel und Log-Level hinzu.
        Bei OnlyChanges werden nur veränderte Daten gespeichert.
        Bei Überschreitung der maximalen Anzahl werden alte Einträge gelöscht.
        
        data: Liste mit formatierten Messwerten.
        level: Log-Level (Standard: INFO).
    """
        allowed_levels = ["DEBUG", "INFO", "WARNINGS", "ERROR", "CRITICAL"]
        
        if level not in allowed_levels:
            raise ValueError(f"Ungültiges Log-Level: {level}")
        
        timestamp = datetime.now().strftime(self.__timestamp_format)
        
        log_data = self.__delimiter.join(data)
        
        if self.__strategy == "OnlyChanges":
            if log_data == self.__last_data:
                return
        
        with open(self.__filename, "a") as file:
            file.write(
                f"{timestamp}{self.__delimiter}{level}"
                f"{self.__delimiter}{log_data}\n"
            )
        
        self.__last_data = log_data
        
        if self.__max_entries > 0:

            with open(self.__filename, "r") as file:
                lines = file.readlines()

            if len(lines) - 2 > self.__max_entries:

                with open(self.__filename, "w") as file:
                    file.writelines(
                        lines[:2] + lines[-self.__max_entries:]
                    )
                    
    def __write_header(self):
        with open(self.__filename, "w") as file:
            file.write(
                f"# <Filename>{self.__filename}</Filename>"
                f"<Created>{datetime.now()}</Created>\n"
            )
            
            header = self.__delimiter.join(["Timestamp", "Level"] + self.__columns)
            file.write(header + "\n")
    
    def __str__(self):
        with open(self.__filename, "r") as file:
            lines = file.readlines()

        anzahl = len(lines) - 2

        return (
            f"Logger: {self.__filename}\n"
            f"Logeinträge: {anzahl}\n"
            f"Strategie: {self.__strategy}\n"
            f"Delimiter: {self.__delimiter}\n"
            f"Max. Einträge: {self.__max_entries}"
        )
    
    def get_strategy(self):
        return self.__strategy

    def set_strategy(self, new_strategy):
        self.__strategy = new_strategy
    
    def get_delimiter(self):
        return self.__delimiter

    def set_delimiter(self, new_delimiter):
        self.__delimiter = new_delimiter
    
    def get_timestamp_format(self):
        return self.__timestamp_format
            
    
    def set_timestamp_format(self, new_format):
        self.__timestamp_format = new_format
    
    def get_max_entries(self):
        return self.__max_entries

    def set_max_entries(self, new_max):
        self.__max_entries = new_max
    
    def get_filename(self):
        return self.__filename
    
    def set_filename(self, new_filename):
        self.__filename = new_filename
        folder = os.path.dirname(self.__filename)
        
        if folder:
            os.makedirs(folder, exist_ok=True)
        
        if not os.path.exists(self.__filename):
            self.__write_header()
        self.__last_data = None

if __name__ == "__main__":
#Hauptprogramm
    url = input("REST URL (Enter = Standard): ") or "https://api.openweathermap.org/data/2.5/weather"

    api_key = "d2b25fbcd5fd360c38bf6ffc2b636fa3"
    city = input("Ort: ") or "Uster"
    sample_time = float(input("Sample-Time [s]: ")) or 5

    params = {
        "q": city,
        "appid": api_key,
        "units": "metric",
        "lang": "de"
    }

    logger = Logger(
        "logs/wetter.csv",
        append=False,
        strategy="Always",
        columns=["Temp [°C]", "Druck [hPa]", "Feuchtigkeit [%]"]
    )


    while True:

        response = requests.get(url, params=params, timeout=10)

        if response.status_code == 200:

            weather_data = response.json()

            temperature = weather_data["main"]["temp"]
            pressure = weather_data["main"]["pressure"]
            humidity = weather_data["main"]["humidity"]

            logger.add_to_log([
                f"{temperature:.1f}",
                f"{pressure:.0f}",
                f"{humidity:.0f}"
            ])

            print(f"Temperatur: {temperature:.1f} °C")

        else:
            print(f"HTTP-Fehler: {response.status_code}")

        time.sleep(sample_time)

