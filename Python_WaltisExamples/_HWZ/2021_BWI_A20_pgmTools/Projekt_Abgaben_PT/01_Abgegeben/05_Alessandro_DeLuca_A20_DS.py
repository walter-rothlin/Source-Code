# ------------------------------------------------------------------
# Name: Alessandro_DeLuca_A20_DS.py
#
# Description: Test-driven implementation of general class Logger
#
# Author: Alessandro De Luca
#
# History:
# 27-Nov-2021   Alessandro De Luca  created logging class
# 30-Nov-2021   Alessandro De Luca  created changeOnly/logEverything method
# 02-Dec-2021   Alessandro De Luca  created user input
# ------------------------------------------------------------------
import logging
import requests
import json
import time

class Log:

#initalisieren

    def __init__(self, name, data):
        LOG_FORMAT = ("%(asctime)s|%(levelname)s|%(message)s|")
        logging.basicConfig(filename=name, format=str(LOG_FORMAT))
        self.logger = logging.getLogger()
        self.logger.setLevel(logging.INFO)
        self.name = name
        self.data = data

#loggt nur wenn der letzte wert anders ist als der zu loggende wert

    def changeOnly(self):
        with open(str(self.name)) as f:
            file = f.readlines()
            if len(file) > 1:
                if file[-1].split("|")[2] != str(temp):
                    self.logger.info(self.data)
            else:
                self.logger.info(self.data)

#loggt abhängig von ausgewählter polling time

    def logEverything(self):
        with open(str(self.name)):
            self.logger.info(self.data)

#my API ID and URL

serviceURL = "https://api.openweathermap.org/data/2.5/weather"
appId = "28c2fc5758686aba185a9cbe8c4190f2"

#choose recording strategy

while True:
    strategy = str(input("[C]hange only or [L]og everything?: ").lower())

    if strategy == "l":

        pollingTime = float(input("Polling-Time for Log everything [s]:"))

    #logs everything

        while True:
            responseStr = requests.get(serviceURL + "?q=Basel&units=metric&lang=de&appid=" + appId)
            jsonResponse = json.loads(responseStr.text)
            temp = jsonResponse['main']['temp']
            pressure = jsonResponse['main']['pressure']
            humidity = jsonResponse['main']['humidity']
            cloud = jsonResponse['weather'][0]['description']
            data = (str(temp) + "|" + str(pressure) + "|" + str(humidity) + "|" + str(cloud))
            l = Log("logeverything.csv", data)
            l.logEverything()
            time.sleep(pollingTime)

    elif strategy == "c":

        pollingTime = float(input("Polling-Time for Change Only [s]:"))

    #logs only changes

        while True:
            responseStr = requests.get(serviceURL + "?q=Basel&units=metric&lang=de&appid=" + appId)
            jsonResponse = json.loads(responseStr.text)
            temp = jsonResponse['main']['temp']
            pressure = jsonResponse['main']['pressure']
            humidity = jsonResponse['main']['humidity']
            cloud = jsonResponse['weather'][0]['description']
            data = (str(temp) + "|" + str(pressure) + "|" + str(humidity) + "|" + str(cloud))
            l = Log("onlychanges.csv", data)
            l.changeOnly()
            time.sleep(pollingTime)
    else:
        print("Try Again - only letters in the brackets are allowed")









