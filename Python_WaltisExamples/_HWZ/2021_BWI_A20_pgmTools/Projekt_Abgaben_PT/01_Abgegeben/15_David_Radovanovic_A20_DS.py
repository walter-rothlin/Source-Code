# ---------------------------------------------------------------------------------------------------------------------
#   Name: David Radovanovic
#
#   Description: Get informations from Weather Server via REST-Call
#
#   Author: David Radovanovic
#
#   History:
#   27.11.2021  Implementation of call and responde handling from the API Server
#   28.11.2021  Implementation of Logging Class and processing
#   29.11.2021  Filehandling and implementation of write strategy (Change only and Fixed Slices)
#   30.11.2021  Code improvement and clean up
#   31.11.2021  Unit Tests
#
# ---------------------------------------------------------------------------------------------------------------------

# IMPORTS
from datetime import datetime
import logging
import requests
import os.path
import json
import csv
import time

# WORKAREA FIELDS START------------------------------------------------------------------------------------------------

# Timestamp
timeNow = datetime.now()
timestampNowXML = timeNow.strftime("%Y-%m-%dT%H:%M:%S.%f")

# Filedirectory Function of OS library
directory = os.getcwd()


# WORKAREA FIELDS END--------------------------------------------------------------------------------------------------


class Logger:
    def __init__(self, fileName, timeStamp, level, row, delimiter="|"):
        self.__fileName = fileName
        self.__delimiter = delimiter
        self.__timeStamp = timeStamp
        self.__level = level
        self.__row = row
        self.__format = "%(asctime)s; %(levelname)s; %(message)s;"
        self.__datefmt = "'%d/%m/%Y     %H:%M:%S'"

    def loggersetup(self):
        logging.basicConfig(filename=self.__fileName, level=self.__level, datefmt=self.__datefmt, format=self.__format)

    def logInfo(self):
        logging.info(self.__row)

    #Getter
    @property
    def timestamp(self):
        return self.__timeStamp

    #Setter
    @timestamp.setter
    def time(self, value):
        self.__timeStamp = value




# Write Header function
def writeHeader(titel, file):
    with open(file, 'w', encoding='UTF-8', newline='') as csv_schreiben:
        writer = csv.DictWriter(csv_schreiben, delimiter=';', fieldnames=titel)
        writer.writeheader()


# Write additional Line after Header
def writeLine(ueberschrift, file):
    with open(file, 'a', encoding='UTF-8', newline='') as csv_schreiben:
        writer = csv.DictWriter(csv_schreiben, delimiter=';', fieldnames=ueberschrift)
        writer.writeheader()


# MAIN PROGRAMM START-------------------------------------------------------------------------------------------------
def main():
    # Select the place for which you want to receive the informations
    correctPlaceEntry = False
    while not correctPlaceEntry:
        try:
            print("Bitte Nummer des gewählten Ortes eingeben:\n"
                  "1.)  London\n"
                  "2.)  Uster\n"
                  "3.)  Bern\n")
            ort = int(input("Eingabe: "))
        except ValueError:
            print("Ungültige Eingabe bei Eingabefeld\n")
            continue
        if ort == 1:
            ort = "London"
            correctPlaceEntry = True
        elif ort == 2:
            ort = "Uster"
            correctPlaceEntry = True
        elif ort == 3:
            ort = "Bern"
            correctPlaceEntry = True
        else:
            print("Auswahl nicht vorhanden\n")
            continue

    # Filehandling parameters for a correct processing
    correctFilehandling = False
    while not correctFilehandling:
        try:
            print("Wollen sie ein neues File, oder bestehendes File? Bitte Nummer wählen.\n"
                  "1.)  Neues File\n"
                  "2.)  Bestehendes File\n")
            filehandling = int(input("Eingabe: "))
        except ValueError:
            print("Ungültige Eingabe bei Eingabefeld\n")
            continue
        # A new file is created
        if filehandling == 1:
            fileName = str(input("Bitte geben sie den Namen des neuen Files an\n"
                                 "(ohne Endung)(Bsp: Testfile)\n"
                                 "Eingabe: "))
            fileName = fileName + ".csv"
            if os.path.isfile(fileName):
                print("File existiert bereits\n")
            else:
                correctFilehandling = True

        # An old file will be enhanced
        elif filehandling == 2:
            fileName = str(input("Bitte geben sie den Namen des bestehenden Files im Ordner an \n"
                                 "(ohne Endung)(Bsp: Testfile)(Muss CSV Format sein)\n"
                                 "Eingabe: "))
            fileName = fileName + ".csv"
            if os.path.isfile(fileName):
                correctFilehandling = True
            else:
                print("File existiert nicht\n")
                continue
        else:
            print("Auswahl nicht existent\n")
            continue

    # Entry of polling time
    correctPollingTime = False
    while not correctPollingTime:
        try:
            print("In welchem Zeitintervall soll der Service aufgerufen werden? Angabe in Sekunden")
            pollingTime = float(input("Eingabe: "))
        except ValueError:
            print("Ungültige Eingabe bei Eingabefeld\n")
            continue
        if pollingTime <= 0:
           print("Keine negativen Sekunden möglich\n")
           continue
        correctPollingTime = True

    # Entry of ringbuffer.....Still in implementation -DOES NOT WORK
    correctEntryRingbufferSize = False
    while not correctEntryRingbufferSize:
        try:
            print("Wie gross soll der Ringbuffer sein?")
            ringbufferSize = -1 * int(input("Eingabe: "))
        except ValueError:  # ValueError prüft den Inhalt einer Variabel ob dieser korrekt ist vom Typ.
            print("Ungültige Eingabe bei Eingabefeld\n")
            continue
        correctEntryRingbufferSize = True

    # Entry of write strategy (change only or fixed slices)
    strategyEntry = False
    while not strategyEntry:
        try:
            print("Welche Write Strategie soll verwendet werden?\n"
                  "1. Fixed slices\n"
                  "2. Only changes\n")
            strategy = int(input("Eingabe: "))
        except ValueError:  # ValueError prüft den Inhalt einer Variabel ob dieser korrekt ist vom Typ.
            print("Ungültige Eingabe bei Eingabefeld\n")
            continue
        if strategy == 1:
            strategyEntry = True
        elif strategy == 2:
            strategyEntry = True
        else:
            print("Auwahl nich verfügbar")
            continue

        # create URL
        apiUrl = "https://api.openweathermap.org/data/2.5/weather?"
        apiKey = "be8415d11e518eb244e4f10476e4b957"
        apiCallURL = (apiUrl + "q=" + ort + "&appid=" + apiKey)

    # The header should only be created for a new file
    if filehandling == 1:
        # You can create your header as you please with the needed informations
        kopfzeile1 = ["#" + directory, fileName, timestampNowXML]
        writeHeader(kopfzeile1, fileName)
        kopfzeile2 = ["Timestamp", "Level", "Ort", "Temperatur", "Pressure", "Humidity", "lon", "lat", "description"]
        writeLine(kopfzeile2, fileName)

    firstLoop = True
    while firstLoop:
        response = requests.get(apiCallURL)
        if response.status_code == 200:
            level = "INFO"
            print("Aufruf OK")
        else:
            print("Something went wrong during the call of the API")
            print(response.status_code)
            break
        # Most important return code meanings
        # 200: Everything went okay, and the result has been returned (if any).
        # 301: The server is redirecting you to a different endpoint. This can happen when a company switches domain names, or an endpoint name is changed.
        # 400: The server thinks you made a bad request. This can happen when you don’t send along the right data, among other things.
        # 401: The server thinks you’re not authenticated. Many APIs require login ccredentials, so this happens when you don’t send the right credentials to access an API.
        # 403: The resource you’re trying to access is forbidden: you don’t have the right permissions to see it.
        # 404: The resource you tried to access wasn’t found on the server.
        # 503: The server is not ready to handle the request.

        # Processing of the JSON
        jsonObject = json.loads(response.text)
        temperatur = jsonObject['main']['temp']
        pressure = jsonObject['main']['pressure']
        humidity = jsonObject['main']['humidity']
        lon = jsonObject['coord']['lon']
        lat = jsonObject['coord']['lat']
        description = jsonObject['weather'][0]['description']

        rowLogging = str(ort) + ";" + str(temperatur) + ";" + str(pressure) + ";" + str(humidity) + ";" + \
                     str(lon) + ";" + str(lat) + ";" + str(description)

        # Changes only writting
        if strategy == 2:
            # Check of the last record
            with open(fileName, "r") as logFile:
                lastLine = logFile.readlines()[-1]
                listLastEntry = lastLine.split(";")
                if listLastEntry[3] != str(temperatur):
                   logger1 = Logger(fileName=fileName, row=rowLogging, level="INFO", timeStamp=timestampNowXML)
                   logger1.loggersetup()
                   logger1.logInfo()
        # Fixed Slices processing
        if strategy == 1:
           logger1 = Logger(fileName=fileName, row=rowLogging, level="INFO", timeStamp=timestampNowXML)
           logger1.loggersetup()
           logger1.logInfo()

        time.sleep(pollingTime)


if __name__ == "__main__":
    main()