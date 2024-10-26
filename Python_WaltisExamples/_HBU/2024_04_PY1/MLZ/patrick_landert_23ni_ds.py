#!/usr/bin/python3

'''
Bewertung
========
1. Lauffähiger Code abgegeben (2 Punkte)                                                2
2. CLI Applikation schreibt ein Log-File (2 Punkte)                                     2
3. Für den Weather REST Service wurde ein eigener Token verwendet                       1
4. Eine eigene, reusable Klasse mit einfachem Interface implementiert (4 Punkte)        2 (Logger Klasse kann nur für Weather genutzt werden)
5. Nur absolut Notwendiges ist public (2 Punkte)                                        2
6. Kommentare in Form von doc_strings sind enthalten                                    1
7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                                 1
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
                                                                Max. Punkte:22         20
                                                                =========================

- initializer kreiert kein file


'''

#Autor: Landert Patrick
#2024-10-21
#

import requests
import time
from datetime import datetime


class WeatherLogger:
    """
    A reusable weather logger that logs weather data from an API.
    """

    def __init__(self, file_path='weather_log.txt', delimiter=';', scroll_entries=100, strategy='Fixed Slices', is_append=False):
        """
        Initializes the WeatherLogger class.
        
        :param file_path: Path to the log file
        :param delimiter: Delimiter used in the log file (default: ;)
        :param scroll_entries: Number of log entries before scrolling/deleting old entries
        :param strategy: Logging strategy - 'Fixed Slices' or 'ChangesOnly' (default: 'Fixed Slices')
        :param is_append: Whether to append to an existing file or start a new one
        """
        self.__delimiter = delimiter
        self.__file_path = file_path
        self.__scroll_entries = scroll_entries
        self.__strategy = strategy
        self.__is_append = is_append
        self.__entries = []
        self.__start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.__last_log_entry = None
        self.__header_written = False  # Flag to track if header has been written

    #to String - Methode
    def __str__(self): 
        return f'Ein Objekt der Klasse WeatherLogger: {self.__file_path}, {self.__start_time}, Delimiter {self.__delimiter}, is_append {self.__is_append}, {self.__strategy}'

    def set_delimiter(self, delimiter):
        """Set the delimiter for the log file."""
        self.__delimiter = delimiter

    def set_file_path(self, file_path):
        """Set the file path for the log file."""
        self.__file_path = file_path

    def set_scroll_entries(self, scroll_entries):
        """Set the number of entries before old entries are deleted."""
        self.__scroll_entries = scroll_entries

    def set_strategy(self, strategy):
        """Set the logging strategy."""
        if strategy not in ['Fixed Slices', 'ChangesOnly']:
            raise ValueError("Strategy must be 'Fixed Slices' or 'ChangesOnly'")
        self.__strategy = strategy

    def set_is_append(self, is_append):
        """Set whether to append to the log file or overwrite it."""
        self.__is_append = is_append

    def __write_header(self):
        """Writes the XML comment and header (column names) to the log file."""
        with open(self.__file_path, mode='a' if self.__is_append else 'w', encoding='utf-8') as file:
            # XML-Tag filename and start time
            file.write(f"#<Name>{self.__file_path}</Name> <Date>{self.__start_time}</Date>\n")
            # Header line for columns
            file.write(f"Timestamp{self.__delimiter}Level{self.__delimiter}Weather{self.__delimiter}Temperature (°C)"
                       f"{self.__delimiter}Pressure (hPa){self.__delimiter}Humidity (%)\n")
        self.__header_written = True  # Mark the header as written

    def __log_weather_data(self, data, level="INFO"):
        """
        Logs weather data, either as new entries or only if changed, based on the strategy.
        
        :param data: The weather data to log
        :param level: Log level, default is "INFO"
        """
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        weather_description = data["weather"][0]["description"]
        temperature = data["main"]["temp"]
        pressure = data["main"]["pressure"]
        humidity = data["main"]["humidity"]

        # Create a dictionary for the weather data to compare (excluding the timestamp)
        current_weather_data = {
            "description": weather_description,
            "temperature": temperature,
            "pressure": pressure,
            "humidity": humidity
        }

        # Create formatted log entry
        log_entry = f"{timestamp}{self.__delimiter}{level}{self.__delimiter}{weather_description}{self.__delimiter}" \
                    f"{temperature:.2f}°C{self.__delimiter}{pressure} hPa{self.__delimiter}{humidity}%\n"

        # Apply 'ChangesOnly' strategy: Only log if the weather data (excluding timestamp) differs
        if self.__strategy == 'ChangesOnly' and current_weather_data == self.__last_log_entry:
            return  # Do not log if the weather data is the same as the previous entry

        # Append the log entry
        self.__entries.append(log_entry)
        self.__last_log_entry = current_weather_data  # Store only the weather data for comparison

        # Scroll entries if the limit is reached (older entries are removed from the start)
        if len(self.__entries) > self.__scroll_entries:
            # Keep only the last `self.__scroll_entries` entries
            self.__entries = self.__entries[-self.__scroll_entries:]

        # Write the log entry to the file
        self.__write_entries_to_file()

    def __write_entries_to_file(self):
        """Writes all stored log entries to the log file, ensuring the header is written once."""
        if not self.__header_written:
            self.__write_header()

        with open(self.__file_path, mode='a', encoding='utf-8') as file:
            for entry in self.__entries:
                file.write(entry)
        self.__entries.clear()  # Clear the in-memory entries after writing

    def fetch_weather_data(self, api_url, params):
        """
        Fetches weather data from the given API and logs it according to the selected strategy.
        
        :param api_url: The URL for the REST API call
        :param params: The parameters for the API call
        """
        response = requests.get(api_url, params=params)
        if response.status_code == 200:
            weather_data = response.json()
            self.__log_weather_data(weather_data)
        else:
            print(f"API request failed with status code: {response.status_code}")

    def start_polling(self, api_url, params, polling_time):
        """
        Starts the polling loop, fetching and logging weather data at regular intervals.
        
        :param api_url: The URL for the REST API call
        :param params: The parameters for the API call
        :param polling_time: The interval time in seconds between each data fetch
        """
        # We don't need to write the header here anymore; it's handled in __write_entries_to_file
        try:
            while True:
                self.fetch_weather_data(api_url, params)
                time.sleep(polling_time)
        except KeyboardInterrupt:
            print("Polling stopped.")


# Example usage in the main application
if __name__ == "__main__":
    # Sample configuration
    sample_time = 1  # Sample time in seconds
    api_url = "http://api.openweathermap.org/data/2.5/weather"
    api_params = {
        'q': 'Zurich', 
        'units': 'metric',
        'lang': 'de',
        'appid': 'aac80a016cf3e3fa84690444200ea6e2'
    }

    # Initialize the WeatherLogger
    logger = WeatherLogger(file_path='patrick_landert_log.txt', delimiter='--', scroll_entries=5, strategy='Fixed Slices', is_append=False)
    print(logger)
    
    # Start polling
    logger.start_polling(api_url, api_params, polling_time=sample_time)


