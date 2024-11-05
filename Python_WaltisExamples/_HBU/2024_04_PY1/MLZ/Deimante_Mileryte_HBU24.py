import requests
import os
from datetime import datetime
from enum import Enum
from abc import ABC, abstractmethod

'''
Bewertung
========
1. Lauffähiger Code abgegeben (2 Punkte)                                                2
2. CLI Applikation schreibt ein Log-File (2 Punkte)                                     2
3. Für den Weather REST Service wurde ein eigener Token verwendet                       1
4. Eine eigene, reusable Klasse mit einfachem Interface implementiert (4 Punkte)        4
5. Nur absolut Notwendiges ist public (2 Punkte)                                        2
6. Kommentare in Form von doc_strings sind enthalten                                    0
7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                                 1
8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)                            1
9. Log-Entries enthalten formatierten Time-Stamp und Level                              1
9a. Scrolling Strategie implementiert                                                   0
10. Anzahl Zeilen für Scrollbereich definierbar                                         1
11. ChangesOnly implementiert                                                           0
12. Append / New implementiert                                                          1
13. Delimiter via __init__ setzbar (mit Default-Wert)                                   1
14. Strategie via __init__ setzbar (mit Default-Wert)                                   1
15. Scrolling area via __init__ setzbar (mit Default-Wert)                              0
                                                                -------------------------
                                                                Max. Punkte:22         18
                                                                =========================

- initializer kreiert kein file
- kein heartbeat (Test ohne Loop)
- Strategie ist eine Enum (ist aber eine Checkbox! Beides gleichzeitig möglich)
- Beim Vergleich "OnlyChanges" wird timestamp mitverglichen
--> Wie funktioniert das dem clear und scrollarea

'''

class LogLevel(Enum):
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARNING = "WARNING"
    ERROR = "ERROR"
    CRITICAL = "CRITICAL"

class RecordingStrategy(Enum):
    FIXED_SLICES = "FixedSlices"
    ONLY_CHANGES = "OnlyChanges"

class ILogger(ABC):
    @abstractmethod
    def log(self, message: str, level: LogLevel):
        """Log a message with the specified log level."""
        pass

class Logger(ILogger):
    def __init__(self, file_path="logfile.txt", delimiter=";", strategy=RecordingStrategy.FIXED_SLICES, scroll_area=1, append=True):
        """Initialize the logger with options"""
        self._file_path = file_path
        self._delimiter = delimiter
        self._strategy = strategy
        self._scroll_area = scroll_area
        self._append_mode = append

        self._log_data = []  # To store logs in memory

        self._set_open_mode()
        self._initialize_log_file()

    def _set_open_mode(self):
        self._open_mode = 'a' if self._append_mode else 'w'

    def _initialize_log_file(self):
        if not self._append_mode or not os.path.exists(self._file_path):
            self._write_log_to_file(initial=True)

    def _write_log_to_file(self, initial=False):
        with open(self._file_path, self._open_mode, encoding="utf-8") as file:
            if initial:
                file.write("#<Name>{}</Name> <Date>{}</Date>\n".format(
                    self._file_path, datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
                file.write("Time-Stamp{}Log-Level{}Message\n".format(self._delimiter, self._delimiter))

            if self._log_data:
                file.write(self._log_data[-1] + "\n")

    def log(self, message: str, level: LogLevel = LogLevel.INFO):
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"{timestamp}{self._delimiter}{level.value}{self._delimiter}{message}"

        # Check for ChangesOnly strategy
        if self._strategy == RecordingStrategy.ONLY_CHANGES:
            if self._log_data and log_entry == self._log_data[-1]:
                # Skip logging if the entry is the same as the last logged entry
                return

        if len(self._log_data) >= self._scroll_area:
            self._log_data.clear()

        self._log_data.append(log_entry)

        self._write_log_to_file()

    @property
    def delimiter(self):
        return self._delimiter

    @delimiter.setter
    def delimiter(self, value):
        self._delimiter = value

    @property
    def file_path(self):
        return self._file_path

    @file_path.setter
    def file_path(self, value):
        self._file_path = value
        self._set_open_mode()

    @property
    def scroll_area(self):
        return self._scroll_area

    @scroll_area.setter
    def scroll_area(self, value):
        self._scroll_area = value

    @property
    def strategy(self):
        return self._strategy

    @strategy.setter
    def strategy(self, value):
        self._strategy = value

def get_weather_data(api_key, city):
    base_url = "http://api.openweathermap.org/data/2.5/weather"
    params = {"q": city, "appid": api_key, "units": "metric"}

    try:
        response = requests.get(base_url, params=params)
        if response.status_code == 200:
            return response.json()
        else:
            return None
    except requests.RequestException:
        return None

def format_weather_data(weather_data):
    if not weather_data:
        return "No data available"

    temp = weather_data['main']['temp']
    description = weather_data['weather'][0]['description']
    city = weather_data['name']
    country = weather_data['sys']['country']

    return f"Weather in {city}, {country}: {temp}°C, {description}"

def main():
    api_key = "d3e9572e0588d3ef3a44859fd311c45f"
    city = "Winterthur"
    log_file = "Deimante_Mileryte_log.txt"

    logger = Logger(file_path=log_file, delimiter=";", strategy=RecordingStrategy.FIXED_SLICES, scroll_area=5, append=True)

    weather_data = get_weather_data(api_key, city)
    log_message = format_weather_data(weather_data)
    logger.log(log_message, level=LogLevel.INFO)

if __name__ == "__main__":
    main()
