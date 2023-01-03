# ------------------------------------------------------------------
# Name  : WeatherLogger.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_01.py
#
# Description: Polling REST Service and write values to console
# https://openweathermap.org/current
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version ()
# 10-Oct-2021   Walter Rothlin      Adapted for BWI-A20
# 28-Nov-2021   Walter Rothlin      Changed URL-encoding und request URL Parameter Uebergabe
# 25-Oct-2022   Walter Rothlin      Abbruch der Polling-Schleife
# ------------------------------------------------------------------
import csv
import datetime
import json
import os
import time

import requests


#This code includes parts initially written by Walter Rothlin and are not explicitly marked as such

def getTimestamp():
    return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())


class Logger:
    def __init__(self, delimiter='|', strategy='normal', scrolling_area='20', file='.//logfile.csv', append_or_new='a', log_lvl='info'):
        """ This class contains multiple options to amend the logger which can be accessed through the setters below.
        Every parameter is set to a default value in case no parameter is given by the user"""
        if append_or_new == 'x':
            if not os.path.isfile(file):
                open(file, 'x')
            open(file, 'w').close()
        self.__delimiter = delimiter
        self.__strategy = strategy
        self.__scrolling_area = scrolling_area
        self.__file = file
        self.__append_or_new = append_or_new
        self.__log_lvl = log_lvl

    def set_delimiter(self, delimiter):
        self.__delimiter = delimiter

    def get_delimiter(self):
        return self.__delimiter

    def set_file_path(self, path):
        self.__file = path

    def set_scrolling_area(self, scrolling_area):
        self.__scrolling_area = scrolling_area

    def set_strategy(self, strategy):
        self.__strategy = strategy

    def get_log_lvl(self):
        return self.__log_lvl

    def write_to_file(self, string_to_log):
        file = open(self.__file, 'a')
        file.write(string_to_log)


if __name__ == '__main__':
    """This is a simple and reusable interface"""
    serviceURL = "https://api.openweathermap.org/data/2.5/weather"
    pollingTime = float(input("Polling-Time [s]:"))
    ort = input("Ort  [*Uster]   :")
    log_lvl = input("Log Level (debug, info, error, critical):")
    append_or_new = input("a for append, x for new:")
    only_changes = input("Only Changes (True, False):")
    delimiter = input("Delimiter:")
    if ort == "":
       ort = 'Uster'

    max_counter = int(input("Anzahl requests :"))

    appId = "18585ffa10013a2a35fc7462e16c4b70"

    logger = Logger(append_or_new=append_or_new, log_lvl=log_lvl)
    if not delimiter == '':
        """If the user chooses a delimiter, it will be chosen through the respective setter. Otherwise the default 
        delimiter will be applied """
        logger.set_delimiter(delimiter)

    if not append_or_new == 'a':
        """If the user chooses to write a new file, a new file with title and header gets created. Otherwise it 
        defaults to amend the file """
        title = '# <Name>.//logfile.csv</Name<Date>' + str(getTimestamp()) + '</Date>\n'
        header = 'timestamp' + logger.get_delimiter() + 'log_lvl' + logger.get_delimiter() + 'ortsname' + logger.get_delimiter() + 'land' + logger.get_delimiter() + 'temp' + logger.get_delimiter() + 'lon' + logger.get_delimiter() + 'lat' + logger.get_delimiter() + 'temp' + logger.get_delimiter() + 'pressure' + logger.get_delimiter() + 'humidity' + logger.get_delimiter() + 'cloud' + logger.get_delimiter() + 'windSpeed' + logger.get_delimiter() + 'windDirection\n'
        logger.write_to_file(title)
        logger.write_to_file(header)

    firstTime = True
    counter = 0
    doLoop = True
    last_log = ''
    while doLoop:
        counter += 1
        requestStr = serviceURL + "?q=" + ort + "&units=metric&lang=de&appid=" + appId
        print("Request:\n", requestStr, "\n\n") if firstTime else False
        responseStr = requests.get(requestStr)
        print("Response:\n", responseStr.text, "\n\n") if firstTime else False

        jsonResponse = json.loads(responseStr.text)

        ortsname = str(jsonResponse['name'])
        land = str(jsonResponse['sys']['country'])
        temp = str(jsonResponse['main']['temp'])
        pressure = str(jsonResponse['main']['pressure'])
        humidity = str(jsonResponse['main']['humidity'])
        lon = str(jsonResponse['coord']['lon'])
        lat = str(jsonResponse['coord']['lat'])
        cloud = str(jsonResponse['weather'][0]['description'])
        windSpeed = str(jsonResponse['wind']['speed'])
        windDirection = str(jsonResponse['wind']['deg'])

        new_log = logger.get_log_lvl() + logger.get_delimiter() + ortsname + logger.get_delimiter() + land + logger.get_delimiter() + temp + logger.get_delimiter() + lon + logger.get_delimiter() + lat + logger.get_delimiter() + temp + logger.get_delimiter() + pressure + logger.get_delimiter() + humidity + logger.get_delimiter() + cloud + logger.get_delimiter() + windSpeed + logger.get_delimiter() + windDirection + '\n'

        if only_changes == 'True' and last_log == new_log:
            """If the user chooses 'True' for 'Only Changes' it will check the last log and if it's the same show 'No 
            Changes' on the console. Otherwise it will proceed according to the given parameters """
            print('No Changes')
        else:
            string_for_logger = str(getTimestamp()) + logger.get_delimiter() + new_log
            logger.write_to_file(string_for_logger)

        last_log = new_log
        time.sleep(pollingTime)
        firstTime = False
        if counter >= max_counter:
            doLoop = False

# ---------------------------------------------------------
# Review / Beurteilung
# ---------------------------------------------------------
# 1. Lauffähiger Code abgegeben (2 Punkte)                                  2
#    Alles in einem File (ausnahmsweise für diese Aufgabenstellung)
#    Filename: Vorname_Nachname_A19_DS.py (z.B. Rea_Vogel_A19_DS.py)
# 2. CLI Applikation schreibt ein Log-File (2 Punkte)                       2
# 3. Für den Weather REST Service wurde ein eigener Token verwendet         2
# 4. Eine eigene, reusable Klasse mit
#    einfachem Interface implementiert (4 Punkte)                           2 (Essenz nicht in Klasse gelöst)
# 5. Nur absolut Notwendiges ist public (2 Punkte)                          1 (alle Setter sind public)
# 6. Kommentare in Form von doc_strings sind enthalten                      1
# 7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                   1
# 8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)              1
#    Log-Entries enthalten formatierten Time-Stamp und Level                1
# 9. Scrolling Strategie implementiert                                      0
# 10. Anzahl Zeilen für Scrollbereich definierbar                           1
# 11. ChangesOnly implementiert                                             1
# 12. Append / New implementiert                                            1
# 13. Delimiter via __init__ setzbar (mit Default-Wert)                     1
# 14. Strategie via __init__ setzbar (mit Default-Wert)                     1
# 15. Scrolling area via __init__ setzbar (mit Default-Wert)                1
#                                                                       ---------
#                                                                          19
#                                                                       =========