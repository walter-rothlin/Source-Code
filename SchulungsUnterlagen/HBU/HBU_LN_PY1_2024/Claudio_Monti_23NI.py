#!/usr/bin/python3

import json
import requests
import time
import os


class Logger:
    def __init__(self, file_path, delimiter=';', max_entries=10, overwrite=False):
        self.file_path = file_path
        self.delimiter = delimiter
        self.max_entries = max_entries

        # Create a new file or append based on the overwrite parameter
        if overwrite or not os.path.exists(self.file_path):
            self._create_header()

    def _create_header(self):
        start_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        header = f'<!-- Filename: {self.file_path}, Start-Time: {start_time} -->\n'
        title_line = "Log-Level" + self.delimiter + "Ortsname" + self.delimiter + "Land" + self.delimiter + "Temp (°C)" + self.delimiter + "Feuchtigkeit (%)" + self.delimiter + "Zeitstempel"

        with open(self.file_path, 'w') as file:
            file.write(header)
            file.write(title_line + "\n")

    def log(self, level, city, country, temp, humidity):
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        log_entry = f"{level}{self.delimiter}{city}{self.delimiter}{country}{self.delimiter}{temp}{self.delimiter}{humidity}{self.delimiter}{timestamp}\n"
        
        # Read existing logs to manage entries
        if os.path.exists(self.file_path):
            with open(self.file_path, 'r') as file:
                lines = file.readlines()
                header_lines = 2  # Number of lines for header
                log_lines = lines[header_lines:]  
            log_lines.append(log_entry)

            if len(log_lines) > self.max_entries:
                log_lines = log_lines[-self.max_entries:]  

            # Rewrite file with updated log
            with open(self.file_path, 'w') as file:
                file.write(''.join(lines[:header_lines]))  
                file.writelines(log_lines)  
        else:
            # In case the file doesn't exist, this should not happen. Log directly.
            with open(self.file_path, 'w') as file:
                file.write(log_entry)

    def read_logs(self):
        with open(self.file_path, 'r') as file:
            return file.readlines()  # Return complete logs


class WeatherFetcher:
    def __init__(self, appid, city='Zürich', filename='weather_data.txt', delimiter=';', 
                 max_entries=10, sample_time=3, log_all=False, overwrite=False):
        self.appid = appid
        self.city = city
        self.url = f"http://api.openweathermap.org/data/2.5/weather?q={self.city}&units=metric&lang=de&appid={self.appid}"
        self.logger = Logger(filename, delimiter, max_entries, overwrite)
        self.sample_time = sample_time
        self.log_all = log_all
        
        self._last_temp = None
        self._last_humidity = None

    def fetch_weather(self):
        try:
            response = requests.get(self.url)
            if response.status_code == 200:
                json_response = response.json()
                self._log_weather(json_response)
            else:
                self.logger.log("ERROR", self.city, "Unknown", None, None)  # Log errors
        except Exception as e:
            self.logger.log("ERROR", self.city, "Unknown", None, None)  # Log exceptions

    def _log_weather(self, data):
        level = "INFO"
        city = data['name']
        country = data['sys']['country']
        temp = round(data['main']['temp'], 2)  # Temperature rounding
        humidity = int(data['main']['humidity'])  # Humidity formatting

        # Log only if conditions are met
        if self.log_all or (self._last_temp is None or self._last_humidity is None or 
           temp != self._last_temp or humidity != self._last_humidity):
            self.logger.log(level, city, country, self.format_float(temp), self.format_integer(humidity))
        
        self._last_temp = temp
        self._last_humidity = humidity

    @staticmethod
    def format_float(value):
        """Format float values to two decimal places."""
        return f"{value:.2f}"

    @staticmethod
    def format_integer(value):
        """Format integer values."""
        return str(value)

    def display_logs(self):
        logs = self.logger.read_logs()
        for log in logs:
            print(log.strip())


# ===========================================================
# MAIN
# ===========================================================
if __name__ == '__main__':
    appid = '796d9ad3c28d1e0d58cdb1b05451582c'  # API Key (Hinweis: Diese sollten nicht öffentlich sein)
    ort = 'Zürich'

    # Here, 'overwrite' can be set to True to create a new log file, or False to append to an existing one.
    overwrite = False  # Set to True to create a new log file
    log_all = True
    weather_fetcher = WeatherFetcher(appid, ort, filename='weather_data.txt', delimiter=';', max_entries=10, sample_time=3, log_all=log_all, overwrite=overwrite)

    try:
        while True:
            weather_fetcher.fetch_weather()
            time.sleep(weather_fetcher.sample_time)
    except KeyboardInterrupt:
        weather_fetcher.display_logs()  # Display all logs upon exit
