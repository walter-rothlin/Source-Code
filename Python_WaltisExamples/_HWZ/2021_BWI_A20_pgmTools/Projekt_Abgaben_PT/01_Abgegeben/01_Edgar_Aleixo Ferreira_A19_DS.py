# ------------------------------------------------------------------
# Name: Edgar_Aleixo Ferreira_A19_DS.py
#
# Description: Class and Application for logging Data from Rest Call
#
# Autor: Edgar Aleixo Ferreira
# ------------------------------------------------------------------

import logging
import json
import datetime
import time
import csv
import pathlib
import requests


class Logger:
    onlychanges = False

    # https://docs.python.org/3/library/csv.html
    def __init__(self, filename: str, delimiter='|'):
        if pathlib.Path(filename).is_file():
            self.csv_file = open(filename, 'a', newline='')
            self.file_exists = True
        else:
            self.csv_file = open(filename, 'x', newline='')
            self.file_exists = False
        self.writer = csv.writer(self.csv_file, delimiter=delimiter)


    def writeLine(self, rows):
        self.writer.writerow([rows])
        self.csv_file.flush()

    def LogingLevel(self, setLogger):

        logger = logging.getLogger(__name__)
        setLogger= ""
        if setLogger == "DEBUG":
            logger.setLevel(logging.DEBUG)
        elif setLogger == "INFO":
            logger.setLevel(logging.INFO)
        elif setLogger == "WARNING":
            logger.setLevel(logging.WARNING)
        elif setLogger == "ERROR":
            logger.setLevel(logging.ERROR)
        else:
            logger.setLevel(logging.CRITICAL)

    def createHeader(self, delimiter: str, Columns):
        Column_Headers = ""
        for column in Columns:
            Column_Headers += column + delimiter
        Xml_Header_Format = "# <Name>{}</Name>"
        Column_Header_Format = "Timestamp" + delimiter + "Level" + delimiter + Column_Headers
        self.writeLine(Xml_Header_Format.format(filename))
        self.writeLine(Column_Header_Format)

    def OnlyChanges(self, onlyChanges):
        if onlyChanges.lower() == "yes":
            self.onlychanges = True
        elif onlyChanges.lower() == "no":
            self.onlychanges = False
        else:
            askagain = input("Please write Yes or No")
            self.OnlyChanges(askagain)

filename = input("bitte ein Pfad und Filename .csv eing eben ")
setLogger=input("Log Level eingeben ?")
pollingTime = float(input("Polling-Time [s]:"))
serviceURL = "https://api.openweathermap.org/data/2.5/weather"
appId = "b58d020feb2e10060b6770fe7e7dd781"
delimiter = ";"
Log_Format = "{}" + delimiter + "{}" + delimiter
Columns = ["temp", "pressure", "humidity", "lon"]


myFileWriter = Logger(filename)
if not myFileWriter.file_exists:
    myFileWriter.createHeader(delimiter, Columns)
onlychangesStr = input("onlychanges (Yes or No)")
myFileWriter.OnlyChanges(onlychangesStr)
recentTemp = ""
recentPressure = ""
recenthumidity = ""
recentlon = ""
while True:
    responseStr = requests.get(serviceURL + "?q=Uster&units=metric&lang=de&appid=" + appId)
    jsonResponse = json.loads(responseStr.text)
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']
    try:

        if (myFileWriter.onlychanges == True) and (
                recentTemp != temp or recentPressure != pressure or recenthumidity != humidity or recentlon != lon):
            myFileWriter.writeLine(Log_Format.format(datetime.datetime.now(), setLogger) + str(temp) + delimiter +
                                   str(pressure) + delimiter + str(humidity) + delimiter + str(lon))
        elif myFileWriter.onlychanges == False:
            myFileWriter.writeLine(Log_Format.format(datetime.datetime.now(), setLogger) + str(temp) + delimiter +
                                   str(pressure) + delimiter + str(humidity) + delimiter + str(lon))
    except FileNotFoundError:
        print("Die Datei konnte nicht gefunden werden")
    finally:
        recentTemp = temp
        recentPressure = pressure
        recenthumidity = humidity
        recentlon = lon
    time.sleep(pollingTime)