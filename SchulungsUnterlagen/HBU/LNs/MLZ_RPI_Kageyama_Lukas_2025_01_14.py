#!/usr/bin/python

# -----------------------------------------------------------------------
# Name: MLZ_class_logger.py
#
# Description: MLZ zum Modul Python für Raspi
#              Eigene Klasse zum Daten loggen
#
# Autor: Lukas Kageyama
#
# History
# 14.01.2026   Lukas Kageyama   erste Version (Spezifikation nicht vollumfänglich abgedeckt)
#                                
# Implementierung/Testing pendent (Klasse datalogger), Stand 14.01.2026
# - filepath
# - mode
# - log Strategie
# - scrolling (Log)
# - log level
# - Anzhal aktive Zeilen (Log)
#
# -----------------------------------------------------------------------

import json
import requests
import time
from datetime import datetime

class datalogger:
    log_count = 0   
    
    # Konstruktor
    def __init__(self, filepath = './', filename = 'logfile.csv', delimiter = '|', mode = 'a', log_strategy = 'always', timestamp_format = '%Y%m%d%H%M%S'):
        self.__filepath = filepath
        self.__filename = filename
        self.__delimiter = delimiter
        self.__mode = mode
        self.__log_strategy = log_strategy
        self.__timestamp_format = timestamp_format
        datalogger.log_count += 1
        
    # Setter / Getter
    def get_filepath(self):
        return self.__filepath
        
    def set_filepath(self, new_filepath):
        self.__lastname = new_filepath

    def get_filename(self):
        return self.__filename
        
    def set_filename(self, new_filename):
        self.__firstname = new_filename
        
    def get_delimiter(self):
        return self.__delimiter
        
    def set_delimiter(self, new_delimiter):
        self.__delimiter = new_delimiter
        
    def get_mode(self):
        return self.__mode
        
    def set_mode(self, new_mode):
        self.__mode = new_mode
        
    def get_log_strategy(self):
        return self.__log_strategy
        
    def set_log_strategy(self, new_log_strategy):
        self.__log_strategy = new_log_strategy

    def __str__(self):
        return f"{self.__filepath}{self.__filename}"
        
    # Weitere Methoden der Klasse (Business-Methoden)
    def add_to_log(self, data):
        with open(self.__filename, self.__mode) as logfile: 
    
            current_date_time = datetime.now()
            timestamp = current_date_time.strftime(self.__timestamp_format) + self.__delimiter
            
            if logfile.tell() == 0:
                str_file_info = f"# Dateiname: {self.__filename}, Erster Logeintrag: {datetime.now()}\n"
                logfile.write(str_file_info)                
                str_csv_header = f"Zeitstempel{self.__delimiter}{self.__delimiter.join(data.keys())}\n"
                logfile.write(str_csv_header)
                        
            str_csv_data = f"{timestamp}{self.__delimiter.join(data.values())}\n"
            logfile.write(str_csv_data)

# Code partly reused from Weatherlogger.py (Lukas Kageyama) but modified
def poll_weather_data(url = "https://api.openweathermap.org/data/2.5/weather?q=Frauenfeld&units=metric&lang=de&appid=ae370e8e497235edea916f46d9af6067"):

        responseStr = requests.get(url)
        responseStr = responseStr.text
        jsonResponse = json.loads(responseStr)
            
        relevant_data = {'Ortsname'             : str(jsonResponse['name']),
                         'Land'                 : str(jsonResponse['sys']['country']),
                         'Temperatur'           : str(jsonResponse['main']['temp']),
                         'rel. Luftfeuchtigkeit': str(jsonResponse['main']['humidity']),
                         'Luftdruck'            : str(jsonResponse['main']['pressure']),
                         'Minimaltemperatur'    : str(jsonResponse['main']['temp_min']),
                         'Maximaltemperatur'    : str(jsonResponse['main']['temp_max']),
                         'Wetterphaenomen'      : str(jsonResponse['weather'][0]['description'])
                        }
        print('.')
        return relevant_data
# end code reuse

# Code reused from umrechner.py (Lukas Kageyama im Unterricht HFU erarbeitet)
def input_float(prompt = 'Eingabe:', min = None, max = None):

    has_error = True
    while(has_error):
        try:
            in_str = input(prompt)
            in_str = in_str.replace(' ', '').replace("'", '').replace(',','.').replace('..', '.')
            ret_val = float(in_str)
            if min is not None and ret_val < min:
                print(f'ERROR: "{ret_val}" kleiner als {min}')
            elif max is not None and ret_val > max:
                print(f'ERROR: "{ret_val}" grösser als {max}')
            else:
                has_error = False
        except Exception:
            print(f'ERROR: "{in_str}" ist kein Float!')
    return ret_val
# end code reuse


# Hauptprogramm
if __name__ == '__main__':
    
    welcome_text = f'''
Willkommen beim besten Wetterlogger der Welt
=============================================
'''
    print(welcome_text)
    logger = datalogger(filename = 'weather_log.csv')
    interval = input_float('Bitte Polling-Interval eingeben und mit ENTER bestätigen: ')
    
    try:
        print(f'Start Polling mit Intervall {interval}s...\n->Exit Polling with CTRL+C\n')
        while(True):
            current_weather = poll_weather_data()
            logger.add_to_log(current_weather)
            #print(logger)
            time.sleep(interval)
        
    except KeyboardInterrupt:
        print('Polling und Logging beendet. Programm fertig')