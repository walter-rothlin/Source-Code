
'''
Bewertung
========
1. Lauffähiger Code abgegeben (2 Punkte)                                                2
2. CLI Applikation schreibt ein Log-File (2 Punkte)                                     2
3. Für den Weather REST Service wurde ein eigener Token verwendet                       1
4. Eine eigene, reusable Klasse mit einfachem Interface implementiert (4 Punkte)        2  (kennt Weather)
5. Nur absolut Notwendiges ist public (2 Punkte)                                        0
6. Kommentare in Form von doc_strings sind enthalten                                    0
7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                                 0
8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)                            1
9. Log-Entries enthalten formatierten Time-Stamp und Level                              1
9a. Scrolling Strategie implementiert                                                   1
10. Anzahl Zeilen für Scrollbereich definierbar                                         1
11. ChangesOnly implementiert                                                           1
12. Append / New implementiert                                                          1
13. Delimiter via __init__ setzbar (mit Default-Wert)                                   1
14. Strategie via __init__ setzbar (mit Default-Wert)                                   1
15. Scrolling area via __init__ setzbar (mit Default-Wert)                              1
                                                                -------------------------
                                                                Max. Punkte:22         17
                                                                =========================

- initializer kreiert kein file
--> Wie wird log aufgerufen (wird über eine static-methode aufgerufen)
'''



import logging
import os
from datetime import datetime
import requests
import time
import argparse

#Erstellung der Klasse, __init__: erstellt das Logfile und setzt Standardwerte für verschiedene Properties
class WeatherLogger:
    def __init__(self, filepath="weather_log.txt", delimiter="|", max_entries=100, strategy="OnlyChanges",
                 timestamp_format="%Y-%m-%d %H:%M:%S", append=False):
        self.filepath = filepath
        self.delimiter = delimiter
        self.max_entries = max_entries
        self.strategy = strategy
        self.timestamp_format = timestamp_format
        self.log_entries = []
        self.append_mode = append
        self._setup_file()

    def _setup_file(self):
        mode = 'a' if self.append_mode and os.path.exists(self.filepath) else 'w'
        with open(self.filepath, mode) as f:
            if mode == 'w':
                f.write(f"<!-- Log file: {self.filepath}, Start Time: {datetime.now()} -->\n")
                f.write(f"Time{self.delimiter}Log-Level{self.delimiter}Message\n")

    def log(self, level, message):
        timestamp = datetime.now().strftime(self.timestamp_format)
        log_entry = f"{timestamp}{self.delimiter}{level}{self.delimiter}{message}\n"
        # Apply logging strategy
        if self.strategy == "OnlyChanges":
            if self.log_entries and self.log_entries[-1].split(self.delimiter)[2] == message:
                return
        self.log_entries.append(log_entry)

        # Remove old entries if max_entries is exceeded
        if len(self.log_entries) > self.max_entries:
            self.log_entries.pop(0)

        with open(self.filepath, 'a') as f:
            f.write(log_entry)

    def set_delimiter(self, delimiter):
        self.delimiter = delimiter

    def set_max_entries(self, max_entries):
        self.max_entries = max_entries

    def set_strategy(self, strategy):
        self.strategy = strategy

    def set_filepath(self, filepath):
        self.filepath = filepath
        self._setup_file()

    def set_timestamp_format(self, timestamp_format):
        self.timestamp_format = timestamp_format



    def get_weather_data(url):
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            return None


def format_weather_data(weather_data):
    try:
        main_data = weather_data["main"]
        temp = main_data["temp"]
        humidity = main_data["humidity"]
        pressure = main_data["pressure"]
        weather_desc = weather_data["weather"][0]["description"]
        return f"Temp: {round(temp, 2)}°C, Humidity: {humidity}%, Pressure: {pressure}hPa, Description: {weather_desc}"
    except KeyError:
        return "Invalid data"


def get_weather_data(url):
    pass


def main():
    ## parser = argparse.ArgumentParser(description="Weather Logger CLI")
    ## parser.add_argument("--sample-time", type=int, default=60, help="Time between samples in seconds")
    ## parser.add_argument("--url", type=str, required=True, help="Weather API URL")

    ## args = parser.parse_args()

    # Logger setup
    logger = WeatherLogger(filepath="Kamal_Baayou_log.txt", delimiter="|", max_entries=100, strategy="OnlyChanges",
                           append=False)

    while True:
        weather_data = WeatherLogger.get_weather_data("https://api.openweathermap.org/data/2.5/weather?q=Uster&units=metric&lang=de&APPID=f6c545d8fd2e92577c73ab77b6438c10")   ## args.url)
        # weather_data = get_weather_data(args.url)

        if weather_data:
            formatted_data = format_weather_data(weather_data)
            logger.log("INFO", formatted_data)
            print(f"Logged: {formatted_data}")
        else:
            logger.log("ERROR", "Failed to fetch weather data")
            print("Error fetching weather data")

        time.sleep(1)## args.sample_time)


if __name__ == "__main__":
    main()

#python weather_logger.py --sample-time 60 --url "https://api.openweathermap.org/data/2.5/weather?q=Wangen+SZ&units=metric&lang=de&appid=144747fd356c86e7926ca91ce78ce170"
