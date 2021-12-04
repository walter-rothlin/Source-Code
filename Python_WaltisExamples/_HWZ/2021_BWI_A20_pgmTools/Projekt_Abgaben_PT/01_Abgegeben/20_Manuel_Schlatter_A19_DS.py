from datetime import datetime
import distutils.util
import os
from enum import Enum

import requests
import time
import csv


class LogLevel(Enum):
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARN = "WARN"
    ERROR = "ERROR"
    CRITICAL = "CRITICAL"


# logger class
class GenericLogger:
    headers = ["no headers specified"]

    def __init__(self, file_name, headers, only_changes=True, max_entries=0, delimiter=",", time_format="%Y-%m-%d %H:%M:%S"):
        self.time_format = time_format
        self.delimiter = delimiter
        self.only_changes = only_changes
        self.max_entries = max_entries
        self.file_name = str(file_name).split(".", 1)[0]
        self.file_path = \
            ["# <Name>" + os.getcwd() + "/" + self.file_name + ".csv</Name><Start>" + str(datetime.now().strftime(self.time_format)) + "</Start>"]
        if len(headers) > 0:
            self.headers = ["Timestamp", "Log-Level"] + headers
        self.open_new_file()

    def open_new_file(self):
        try:
            with open(self.file_name+".csv", 'r'):
                self.overwrite_file()
        except:
            print("New log file " + self.file_name + ".csv is being created")
        self.write_headers()

    def overwrite_file(self):
        print("Looks like there is already a file with this name in use!")
        while True:
            try:
                overwrite = distutils.util.strtobool(
                    input("Would you like to overwrite it? Y/N (default=N): ") or "N")
                break
            except ValueError:
                print("Please only input Y or N!")
                continue
        if overwrite:
            print("File with name: " + self.file_name + ".csv will be overwritten")
        else:
            self.file_name = self.file_name+"_"+str(datetime.now().strftime(self.time_format))
            print("File will not be replaced, instead file with name " + self.file_name + ".csv is being created." )

    def write_headers(self):
        with open(self.file_name+".csv", 'w') as csvfile:
            writer = csv.writer(csvfile, delimiter=self.delimiter)
            writer.writerow(self.file_path)
            writer.writerow(self.headers)

    def write_entry(self, new_entry, log_lvl):
        try:
            with open(self.file_name+".csv", 'r'):
                pass
        except:
            print("Looks like the log file was moved or deleted!")
            print("New log file " + self.file_name + ".csv is being created")
            self.write_headers()
        with open(self.file_name+".csv", 'r') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=self.delimiter)
            row_list = list(spamreader)
            last_row = row_list[-1][1:]
            row_count = len(row_list)
            new_entry.insert(0, log_lvl.value)
            new_row = [str(i) for i in new_entry]
        if self.max_entries == 0 or self.max_entries+2 > row_count:
            if not self.only_changes or last_row != new_row:
                with open(self.file_name+".csv", 'a') as csvfile:
                    apend_writer = csv.writer(csvfile, delimiter=self.delimiter)
                    apend_writer.writerow([str(datetime.now().strftime(self.time_format))] + new_entry)
                    print("Appended new log entry.")
            else:
                print("Nothing changed since last log entry! Nothing to log.")
        else:
            if not self.only_changes or last_row != new_row:
                del row_list[2]
                row_list.append([str(datetime.now().strftime(self.time_format))] + new_entry)
                with open(self.file_name+".csv", 'w') as csvfile:
                    concat_writer = csv.writer(csvfile, delimiter=self.delimiter)
                    concat_writer.writerows(row_list)
                    print("Appended new log entry and deleted oldest entry in order to make some space :)")
            else:
                print("Nothing changed since last log entry! Nothing to log.")


# CLI application
class CLIWeather:
    header_list = ["Country", "City", "Temperature", "Feels Like", "MinTemp", "MaxTemp", "Pressure", "Humidity"]
    log_file_name = input("Name of Log File (default=log.csv): ") or "log.csv"
    logger = GenericLogger(log_file_name, header_list)

    while True:
        try:
            pollingTime = float(input("Define a polling frequency in seconds (default=5): ") or 5)
            break
        except ValueError:
            print("Please input numbers only...")
            continue
    location = input("Set Location (default=Zurich): ") or "Zurich"

    serviceURL = "https://api.openweathermap.org/data/2.5/weather"
    appId = "bcb67e1d71709f161d8b26c01f41d2a8"
    while True:
        responseStr = requests.get(serviceURL + "?q=" + location + "&units=metric&lang=de&appid=" + appId)
        jsonResp = responseStr.json()

        if "message" in jsonResp:
            print(jsonResp["cod"] + ": " + jsonResp["message"])
            logger.write_entry([jsonResp["cod"], jsonResp["message"]], LogLevel.ERROR)
            print("Application will end. Restart and try different input")
            break
        else:
            logger.write_entry([jsonResp["sys"]["country"], jsonResp["name"]]+list(jsonResp["main"].values()), LogLevel.INFO)
            time.sleep(pollingTime)
