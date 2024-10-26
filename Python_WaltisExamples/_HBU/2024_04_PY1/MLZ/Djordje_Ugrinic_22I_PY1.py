
'''
Bewertung
========
1. Lauffähiger Code abgegeben (2 Punkte)                                                2
2. CLI Applikation schreibt ein Log-File (2 Punkte)                                     2
3. Für den Weather REST Service wurde ein eigener Token verwendet                       1
4. Eine eigene, reusable Klasse mit einfachem Interface implementiert (4 Punkte)        4
5. Nur absolut Notwendiges ist public (2 Punkte)                                        1 (z.B. should_log() muss nicht public sein)
6. Kommentare in Form von doc_strings sind enthalten                                    1
7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                                 0 (Als HTML Kommentar markiert)
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

+ Einfacher und klarer Design der Klasse
+ initializer kreiert file

'''


# ------------------------------------------------------------------
# Name  : Djordje_Ugrinic_22I_PY1.py
# Source: -
#
# Description: Polling REST Service and log in .txt file
# https://openweathermap.org/current
#
# Autor: Djordje Ugrinic
#
# History:
# 21-Oct-2024   Djordje Ugrinic Created in Visual Studio
# ------------------------------------------------------------------

import json
import requests
import os
import time
import argparse
from datetime import datetime

class Logger:
    def __init__(self, file_name, file_path, delimiter, max_entries, strategy, timestamp_format, append):
        """
        Initializes the Logger class.
        :param file_name: Name of the log file
        :param file_path: Path to the log file
        :param delimiter: Delimiter for the log entries
        :param max_entries: Maximum number of entries before scrolling
        :param strategy: Logging strategy ('FixedSlices', 'OnlyChanges')
        :param timestamp_format: Format for the timestamp
        :param append: Whether to append to an existing file or overwrite it
        """
        self._file_name = file_name
        self._file_path = file_path
        self._delimiter = delimiter
        self._max_entries = max_entries
        self._strategy = strategy
        self._timestamp_format = timestamp_format
        self._append = append
        self._log_entries = []
        self._previous_temp = None  # For "OnlyChanges" strategy

        full_file_path = os.path.join(self._file_path, self._file_name)
        mode = 'a' if self._append else 'w'

        # Write the header only if we are NOT appending (i.e., when opening in 'w' mode)
        if not self._append:
            with open(full_file_path, 'w') as file:
                file.write(f'<!-- Log File: {self._file_name} Start-Time: {datetime.now().strftime(self._timestamp_format)} -->\n')
                file.write(f'Time-Stamp{self._delimiter}Log-Level{self._delimiter}Message\n')  # Title row

    # Setters for each property
    def set_delimiter(self, delimiter):
        self._delimiter = delimiter

    def set_file_path(self, file_path):
        self._file_path = file_path

    def set_file_name(self, file_name):
        self._file_name = file_name

    def set_max_entries(self, max_entries):
        self._max_entries = max_entries

    def set_strategy(self, strategy):
        if strategy in ['FixedSlices', 'OnlyChanges']:
            self._strategy = strategy
        else:
            raise ValueError("Invalid strategy. Choose 'FixedSlices' or 'OnlyChanges'.")

    def log(self, level, message):
        """
        Logs an entry in the log file.
        """
        timestamp = datetime.now().strftime(self._timestamp_format)
        entry = f'{timestamp}{self._delimiter}{level}{self._delimiter}{message}'

        if len(self._log_entries) >= self._max_entries:
            self._log_entries.pop(0)  # "Scroll" when too many entries

        self._log_entries.append(entry)
        full_file_path = os.path.join(self._file_path, self._file_name)

        # Overwrite the file with the last `max_entries` log entries
        with open(full_file_path, 'w') as file:
            file.write(f'<!-- Log File: {self._file_name} Start-Time: {datetime.now().strftime(self._timestamp_format)} -->\n')
            file.write(f'Time-Stamp{self._delimiter}Log-Level{self._delimiter}Message\n')  # Title row
            for log_entry in self._log_entries:
                file.write(log_entry + '\n')

    def should_log(self, temp):
        """
        Determines whether to log the current entry based on the strategy.
        """
        if self._strategy == 'OnlyChanges' and self._previous_temp == temp:
            return False
        self._previous_temp = temp
        return True


def get_weather_data(url, logger):
    """
    Function to fetch weather data and log the results.
    """
    try:
        response = requests.get(url)
        if response.status_code != 200:
            logger.log('CRITICAL', f'API request failed with status code: {response.status_code}')
            return

        logger.log('DEBUG', f'Raw API response: {response.text}')
        
        jsonResponse = json.loads(response.text)
        city_name = jsonResponse['name']
        country = jsonResponse['sys']['country']
        temp = round(jsonResponse['main']['temp'], 1)  # Round temperature to 1 decimal place
        description = jsonResponse['weather'][0]['description']

        print(f"   City name: {city_name}")
        print(f"   Country: {country}")
        print(f"   Temp: {temp} \u00B0C")
        print(f"   Weather description: {description}")

        if temp < 0 or temp > 35:
            logger.log('WARNING', f'Abnormal temperature detected: {temp}°C in {city_name}, {country}')
        
        if logger.should_log(temp):
            logger.log('INFO', f'City name: {city_name}, Country: {country}, Temp: {temp}°C, Description: {description}')
    
    except KeyError as e:
        logger.log('ERROR', f'Missing key in response: {e}')
    except requests.exceptions.RequestException as e:
        logger.log('CRITICAL', f'API request exception: {e}')


def main():
    '''
    parser = argparse.ArgumentParser(description="Weather Logger CLI")
    parser.add_argument('--url', type=str, required=True, help='URL for the REST API call')
    parser.add_argument('--sample_time', type=int, default=60, help='Time in seconds between API calls')
    parser.add_argument('--strategy', type=str, default='FixedSlices', choices=['FixedSlices', 'OnlyChanges'], help='Logging strategy')
    args = parser.parse_args()
    '''

    # Initialize the logger with the desired settings
    logger = Logger(
        file_name='Djordje_Ugrinic_log.txt',
        file_path='.',
        delimiter='|',
        max_entries=10,
        strategy='OnlyChanges', # args.strategy,
        timestamp_format='%Y-%m-%d %H:%M:%S',
        append=True
    )

    try:
        while True:
            get_weather_data('https://api.openweathermap.org/data/2.5/weather?q=Uster&units=metric&lang=de&appid=aef827df6d038c6c4e604cf10a15962c', logger)   #args.url, logger)
            time.sleep(1) # args.sample_time)
    
    except KeyboardInterrupt:
        print("\nProgram interrupted by user. Exiting gracefully.")
        exit(0)

if __name__ == "__main__":
    main()
