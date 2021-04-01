
########################################################################################################################
# REST LOGGER
# by Simon Schmider
# v. 1.0.0
# 10.12.2020
########################################################################################################################
#
#   - Import modules
#   - Classes and Functions
#   - - Application (Class)
#   - - - __init__
#   - - - load_settings
#   - - - show_settings
#   - - - set
#   - - - newfile
#   - - - cleanup
#   - - - help
#   - - Logger (Class)
#   - - - __init__
#   - - - log_record
#   - Program starts here
#   - - __main__
#

# Import modules
########################################################################################################################

import json                     # Reading JSON File
import datetime                 # creating Timestamp
import csv                      # Read and write csv file
import requests                 # call the API URL
import pandas as pd             # handle the JSON response
from itertools import chain     # Use for manual correction
import configparser             # Creating and reading config.ini file
import os                       # move and handle files in directory
import threading                # create a seperate thread while Logger is running
import time                     # define sleep time
import shutil                   # delete diretory

# Classes and Functions
########################################################################################################################

class Application:
    def __init__(self):

        # Check if config.ini File exist
        if os.path.isfile('config.ini'):
            print("... config.ini wird geladen")
        else:
            # if file does not exist
            print("... Es existiert keine config.ini")

            # Create a standard config file
            config_object = configparser.ConfigParser(interpolation=None)

            config_object["APPLICATION"] = {
                "rest_call_url": "http://api.openweathermap.org/data/2.5/weather?q=Wangen%20SZ&appid=3836093dde650898eb014e6f27304646",
                "loopWaitTime" : "5",
                "logfile_name" : "log.csv",
                "logfile_path" : "",
                "delimiter" : "|",
                "record_only_changes" : "False",
                "datapoints": "",
                "max_rows" : "1000",
            }

            # Write the above sections to config.ini file
            with open('config.ini', 'w') as conf:
                config_object.write(conf)

            print("... config.ini Datei wurde mit Standardeinstellung angelegt")

        config_object = configparser.ConfigParser(interpolation=None)
        config_object.read("config.ini")

        self.load_settings()


    def load_settings(self):
        # load config.ini file
        config_object = configparser.ConfigParser(interpolation=None)
        config_object.read("config.ini")

        app_config = config_object["APPLICATION"]
        self.rest_call_url = app_config["rest_call_url"]
        self.logfile_name = app_config["logfile_name"]
        self.logfile_path = app_config["logfile_path"]
        self.loopWaitTime = app_config["loopWaitTime"]
        self.delimiter = app_config["delimiter"]
        self.record_only_changes = app_config["record_only_changes"]
        self.datapoints = app_config["datapoints"]
        self.max_rows = app_config["max_rows"]


    def show_settings(self):
        print("config.ini")
        print("********************************************************")
        print('rest_call_url:'.ljust(25) + App.rest_call_url)
        print('logfile_name:'.ljust(25) + App.logfile_name)
        print('logfile_path:'.ljust(25) + App.logfile_path)
        print('loopwaittime:'.ljust(25) + App.loopWaitTime)
        print('delimiter:'.ljust(25) + App.delimiter)
        print('record_only_changes:'.ljust(25) + App.record_only_changes)
        if App.datapoints == "":
            print('datapoints:'.ljust(25) + "All")
        else:
            print('datapoints:'.ljust(25) + App.datapoints)
        print('max_rows:'.ljust(25) + App.max_rows)
        print("********************************************************", end='\n \n')

    def set(self, edit_key, edit_value):
        # load config.ini
        config = configparser.ConfigParser(interpolation=None)
        config.read("config.ini")

        # Check if option in config.ini exist
        if config.has_option("APPLICATION", edit_key) == True:

            # set input values in config.ini file
            config.set("APPLICATION", edit_key, edit_value)
            config.write(open("config.ini", "w"))

            # if logfile name changes, change config.ini and logfile name
            if edit_key == "logfile_name":
                os.rename(r'' + self.logfile_path + self.logfile_name, r'' + self.logfile_path + edit_value)

            # if logfile path changes, change config.ini and logfile location
            if edit_key == "logfile_path":
                os.rename(r'' + self.logfile_path + self.logfile_name, r'' + edit_value + self.logfile_name)

            print("... Lade neue Einstellungen", end='\n \n')

            # load new settings from config.ini and print it
            self.load_settings()
            self.show_settings()

        else:
            print("... Einstellung konnte nicht gesetzt werden")
            print("... Die folgende Option existiert nicht: " + edit_key)


    def newfile(self, rest_call_url, logfile_path, logfile_name, delimiter, datapoints):
        # Check if archiv directory exist, create one if don't exist
        if os.path.isdir('./archiv') == False:
            os.mkdir('archiv')

        # Get current date and time
        timestamp = datetime.datetime.now()
        timestamp = timestamp.strftime(format="%Y-%m-%d")

        # Check if logfile already exist in archiv and move file
        if os.path.isfile('archiv/log_' + timestamp + '.csv'):
            i = 1
            while os.path.isfile('archiv/log_' + timestamp + '_' + str(i) + '.csv'):
                i = i + 1
            os.rename(r'' + self.logfile_path + self.logfile_name, r'archiv/log_' + timestamp + '_' + str(i) + '.csv')
        else:
            os.rename(r'' + self.logfile_path + self.logfile_name, r'archiv/log_' + timestamp + '.csv')

        print("... Lofgile wurde in Archiv verschoben")

        # Create an new logfile
        Log = Logger(rest_call_url, logfile_path, logfile_name, delimiter, datapoints)


    def cleanup(self, rest_call_url, logfile_path, logfile_name, delimiter, datapoints):
        # checking whether folder exists or not and delete the folder
        if os.path.exists('archiv'):
            shutil.rmtree('archiv')
            print("... Archiv wurde gelöscht")
        else:
            print("... Es existiert kein Archiv")


    def help(self):
        print("Hilfe")
        print("********************************************************")
        print("start")
        print("Startet den Logger mit den Konfigurationen aus dem config.ini File")
        print("Der Logger läuft solange, bis man diesen mit betätigen der ENTER")
        print("Taste abbricht.")
        print(" ")
        print("edit")
        print("Mit dem Befehl edit können einzelne Werte aus dem config.ini File")
        print("verändert werden um das Verhalten des Loggers anzupassen.")
        print("Wichtig: Es gibt keine Validierung der eingetragenen Werte. ")
        print("Falsche Werte können dazu führen, dass das Programm nicht mehr")
        print("richtig funktioniert.")
        print("rest_call_url:".ljust(25) + "Hier muss eine gültige URL eingegeben werden")
        print("".ljust(25) + "welche eine Antwort in Form eines JSON Files zurücksendet")
        print("logfile_name:".ljust(25) + "Dieser Wert defineirt den Namen des Logfiles.")
        print("".ljust(25) + "Der Name muss zwingend mit .csv enden.")
        print("logfile_path:".ljust(25) + "Dieser Wert defineirt den Pfad, wo das Logfile")
        print("".ljust(25) + "abgespeichert wird. Ein Pfad muss mit / enden.")
        print("".ljust(25) + "Beispiel: logfileordner/")
        print("loopwaittime:".ljust(25) + "Definiert nach wie vielen Sekunden die Abfrage")
        print("".ljust(25) + "erneut gemacht werden soll.")
        print("delimiter:".ljust(25) + "Definiert das Trennzeichen für das Logfile (csv)")
        print("record_only_changes:".ljust(25) + "True = Es werden nur Veränderungen geloggt")
        print("".ljust(25) + "False = Es werden alle Einträge geloggt")
        print("datapoints:".ljust(25) + "Definiert welcher Daten aus dem REST Call (JSON)")
        print("".ljust(25) + "berücksichtigt werden sollen. Zum Beispiel:")
        print("".ljust(25) + "timezone, coord.lat, weather.main")
        print("".ljust(25) + "Wichtig: Bleibt die Einstellung leer, werden alle Daten verwendet")
        print("max_rows:".ljust(25) + "Definiert wie viele Zeilen ein Logfile maximal")
        print("".ljust(25) + "haben kann. Wird der Wert überschritten, wird das Logfile ins")
        print("".ljust(25) + "Archiv verschoben und ein neues File wird angelegt.")
        print(" ")
        print("config")
        print("Ladet die aktuellen Konfigurationen aus dem config.ini File")
        print("und zeigt diese an.")
        print(" ")
        print("newfile")
        print("Das aktiuelle Logfile wird ins Archiv verschoben und ein neues wird angelegt.")
        print(" ")
        print("cleanup")
        print("Löscht das komplette Archiv (falls vorhanden).")
        print(" ")
        print("exit")
        print("Das Programm wird beendet")
        print("********************************************************")
        print(" ")


class Logger:
    def __init__(self, rest_call_url, logfile_path, logfile_name, delimiter, datapoints):
        # Check if logfile already exist
        logfile = logfile_path + logfile_name
        if os.path.isfile(logfile):
            pass
        else:
            # Get current date and time
            timestamp = datetime.datetime.now()
            timestamp = timestamp.strftime(format="%Y-%m-%d %H:%M:%S")

            # Generate logfile with header row
            header = logfile + " - " + timestamp
            with open(logfile, 'w', newline='') as file:
                writer = csv.writer(file)
                writer.writerow([header])
                file.close()

            self.log_record(rest_call_url, logfile_path, logfile_name, delimiter, datapoints, first_record=True)


    def log_record(self, api_url, logfile_path, logfile_name, delimiter, datapoints, first_record=False, record_only_changes=False):

        last_record = ""

        while doLoop:

            # Sleep just when loop
            if first_record == False:
                time.sleep(int(App.loopWaitTime))

            # Get API request and load JSON
            response = requests.get(api_url)
            api_values = json.loads(response.text)

            # Check response status
            if response.status_code == 200:
                # Connection sucessfull
                loglevel = "INFO"
            elif response.status_code == 500:
                # Server error
                loglevel = "ERROR"
            elif response.status_code == 400:
                # Client error
                loglevel = "CRITIAL"
            """    
            elif response.status_code == 'DEBUG':
                status = "DEBUG"
            elif response.status_code == 'WARNINGS':
                status = "WARNINGS"
            """

            # Manuall correction for * Option
            api_values['weather'] = dict(chain(*map(dict.items, api_values['weather'])))

            # Use pandas to convert json to a table
            data = pd.json_normalize(api_values)

            if record_only_changes == True:
                # Check if there is a change since the last record
                if last_record == api_values:
                    print("... Es gab keine Veränderung")
                    continue

                # save the last record
                last_record = api_values

            # Get current date and time (time of API call)
            timestamp = datetime.datetime.now()
            timestamp = timestamp.strftime(format="%Y-%m-%d %H:%M:%S")

            # Insert timestamp and LogLevel in table
            data.insert(loc=0, column='log_level', value=[loglevel])
            data.insert(loc=0, column='timestamp', value=[timestamp])

            logfile = logfile_path + logfile_name

            # Check for max rows
            file = open(logfile)
            reader = csv.reader(file)
            lines = len(list(reader))
            if lines >= int(App.max_rows):
                file.close()
                print("... Maximale Anzahl Zeilen erreicht")
                # Move File in archiv and create new file, if file = maxrows
                App.newfile(api_url, logfile_path, logfile_name, delimiter, datapoints)
            else:
                file.close()

            # Check if first row
            if first_record == False:
                # Add row in logfile
                if datapoints == "":
                    data.to_csv(logfile, index=False, header=None, mode='a', sep=delimiter)
                else:
                    # Converting string to list
                    datapoints_list = datapoints.strip('][').split(', ')
                    data.to_csv(logfile, index=False, header=None, mode='a', sep=delimiter, columns=datapoints_list)

                print(timestamp + " - Eintrag in Logfile gespeichert")
            else:
                # Add just title row
                header = data.head(0)
                if datapoints == "":
                    header.to_csv(logfile, index=False, mode='a', sep=delimiter)
                else:
                    datapoints_list = datapoints.strip('][').split(', ')
                    header.to_csv(logfile, index=False, mode='a', sep=delimiter, columns=datapoints_list)

            # Leave Loop if first record (Header)
            if first_record == True:
                print("... Neues Logfile wurde angelegt")
                break  # break here


# Program starts here
########################################################################################################################

if __name__ == '__main__':

    print("... Starte REST-Loggger (v 1.0.0) by Simon Schmider")

    # Check config file, create one if dont exist
    App = Application()

    # Load config settings etc.
    App.load_settings()
    delayTime = 1
    doLoop = True

    # Check log file and set header and title row if don't exist
    Log = Logger(App.rest_call_url, App.logfile_path, App.logfile_name, App.delimiter, App.datapoints)

    print("... Lade Programmeinstellungen", end='\n \n')
    App.show_settings()

    while True:
        print("... Mögliche Befehle: start, edit, config, newfile, cleanup, help, exit")
        print("Was möchten Sie tun?")
        doAction = input()

        if doAction == "start":
            # set doLoop = True in case when already started before and doLoop = False
            doLoop = True
            first_record = False

            # Change str to boolean
            if App.record_only_changes == "True":
                App.record_only_changes = True
            else:
                App.record_only_changes = False

            # Call API and log de response (loop)
            t = threading.Timer(delayTime, Log.log_record, args=[App.rest_call_url, App.logfile_path, App.logfile_name, App.delimiter, App.datapoints, first_record, App.record_only_changes])
            t.start()

            print("... Starte Logger")
            print("Stop?")
            doStop = input()
            doLoop = False
            t.join()
            print("... Logger gestoppt")

        elif doAction == "edit":
            print("Welche Einstellung soll angepasst werden? (Beispiel: delimiter)")
            edit_key = input()
            print("Definiere den neuen Wert für die Einstellung: " + edit_key)
            edit_value = input()

            App.set(edit_key, edit_value)

        elif doAction == "config":
            # load new settings from config.ini and print it
            App.load_settings()
            App.show_settings()

        elif doAction == "newfile":
            # set doLoop = True in case when already started before and doLoop = False
            doLoop = True

            App.newfile(App.rest_call_url, App.logfile_path, App.logfile_name, App.delimiter, App.datapoints)

        elif doAction == "cleanup":
            print("Mit dem Befehl cleanup werden alle Dateien im Archiv gelsöcht. \n "
                  "Sollen wirklich alle alten Dateien im Archiv gelöscht werden? \n "
                  "Bestätige mit 'Ja' ")
            cleanup = input()

            if cleanup == "Ja":
                # set doLoop = True in case when already started before and doLoop = False
                doLoop = True

                App.cleanup(App.rest_call_url, App.logfile_path, App.logfile_name, App.delimiter, App.datapoints)
            else:
                print("cleanup Befehl abgebrochen")

        elif doAction == "help":
            App.help()

        elif doAction == "exit":
            break  # break here and exit program

        else:
            print("... Der folgende Befehl existiert nicht: " + doAction)

    print("... Programm wird beendet")

