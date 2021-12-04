# ------------------------------------------------------------------
# Name: Logger.py
#
# Description: Class to log into csv file
#
# Autor: Florian Läderach
#
# History:
# 27-Nov-2021, Florian Läderach: 1.0 Version
# 29-Nov-2021, Florian Läderach: 1.1 Added check if file already exists
# 30-Nov-2021, Florian Läderach: 1.2 Added function addlog, timestamps corrected
# 01-Dec-2021, Florian Läderach: 1.3 Added properties for delimiter, filename and path
# 02-Dec-2021, Florian Läderach: 1.4 Added two logging strategies, corrected the title row with field names
# ------------------------------------------------------------------
# ------------------------Imports-----------------------------------

import requests
import json
import time
from datetime import datetime
import csv
import os

# ------------------------Logger stars here-------------------------


class Logger:  # Initialize, "os.path.abspath(os.getcwd()" gets the current path
    def __init__(self, delimiter="|", filename="Log", path=os.path.abspath(os.getcwd()) + "\\", strategy=1):
        self._delimiter = delimiter
        self._filename = filename
        self._path = path
        self._strategy = strategy  # 1 = Fixed Slices, 2 = Only Changes
        self.fileexist = False
        self.full_path = ""
        self.wroteheader = False
        self.oldvalue1 = ""
        self.oldvalue2 = ""
        self.oldvalue3 = ""

    @property
    def delimiter(self):
        return self._delimiter

    @delimiter.setter
    def delimiter(self, newdelimiter):
        self._delimiter = newdelimiter

    @property
    def filename(self):
        return self._filename

    @filename.setter
    def filename(self, filename):
        self._filename = filename

    @property
    def path(self):
        return self._path

    @path.setter
    def path(self, path):
        self._path = path

    @property
    def strategy(self):
        return self._strategy

    @strategy.setter
    def strategy(self, strategy):
        if strategy == 1 or strategy == 2:
            self._strategy = strategy
        else:
            raise ValueError("Invalid input for Strategy: Choose 1 for 'Fixed Slices' or 2 for 'Only Changes'")

# startlog function checks if the file exists and creates/opens it, and writes the two header rows

    def startlog(self, value1, value2, value3):
        self.full_path = self.path + self._filename + ".csv"  # Create the full path name
        if os.path.isfile(self.full_path):  # Check if a log file already exists in the current path
            self.fileexist = True
        else:
            self.fileexist = False
        if self.wroteheader:  # Only write the header once, after that skip this whole function
            pass
        else:
            timestamp = datetime.now().strftime("%d-%b-%Y %H:%M:%S")
            header1 = ["# <NAME>" + self.full_path + "</NAME >" + "<STARTTIME>" + timestamp + "</STARTTIME"]
            header2 = [
                "Timestamp" + self.delimiter + "LogLevel" + self.delimiter + value1 + self.delimiter +
                value2 + self.delimiter + value3
            ]
            print("Logging started! Writing to:", self.full_path)
            if self.fileexist:
                f = open(self.full_path, 'a', newline='')  # If the log file already exists, append the data
            else:
                f = open(self.full_path, 'w', newline='')  # Create file if it does not exist
            writer = csv.writer(f)
            writer.writerow("")
            writer.writerow(header1)
            writer.writerow(header2)
            writer.writerow("")
            f.close()
            self.wroteheader = True

# addlog functions adds a log to the file, depending on which logging strategy was chosen

    def addlog(self, value1, value2, value3):
        if self._strategy == 1 or value1 != self.oldvalue1 or value2 != self.oldvalue2 or value3 != self.oldvalue3:
            # If the Logging Strategy is set to 'Fixed Slices' or if any changes happened, do this part
            timestamp = datetime.now().strftime("%d-%b-%Y %H:%M:%S")
            loglevel = "INFO"
            logdata = [
                timestamp + self.delimiter + loglevel + self.delimiter + str(value1) +
                self.delimiter + str(value2) + self.delimiter + str(value3)
            ]
            f = open(self.full_path, 'a', newline='')
            writer = csv.writer(f)
            writer.writerow(logdata)
            f.close()
            print("Log added!")
            self.oldvalue1 = value1
            self.oldvalue2 = value2
            self.oldvalue3 = value3
        else:
            # If the Logging Strategy is set to 'Only Changes' and no changes happened, do this part
            print("No changes --> No Log added")


# ------------------------Testing Application-----------------------

pollingTime = float(input("Polling-Time [s]:"))
serviceURL = "https://api.openweathermap.org/data/2.5/weather"
appId = "144747fd356c86e7926ca91ce78ce170"
x = Logger()
x.delimiter = "¦"
x.filename = "Test"
x.path = "C:\\Users\\FLA\\PycharmProjects\\Programming Introduction\\Semester2\\"
x.strategy = 1

while True:
    responseStr = requests.get(serviceURL + "?q=Uster&units=metric&lang=de&appid=" + appId)
    jsonResponse = json.loads(responseStr.text)
    key_list = list(jsonResponse['main'])
    name1 = key_list[0]
    temp = jsonResponse['main']['temp']
    name2 = key_list[4]
    pressure = jsonResponse['main']['pressure']
    name3 = key_list[5]
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']

    x.startlog(name1, name2, name3)
    x.addlog(temp, pressure, humidity)
    time.sleep(pollingTime)



