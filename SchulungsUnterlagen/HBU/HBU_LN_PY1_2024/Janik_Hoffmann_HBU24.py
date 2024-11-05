# ------------------------------------------------------------------
# Name:     Janik_Hoffmann_HBU24.py
#
# Autor:    Janik Hoffmann
#
# Date:     21.10.2024
#
#
#   TODO:
#           -überprüfen auf max Zeilen
#           -Strategie überprüfen
#       
# ------------------------------------------------------------------

import datetime
import requests
import json
import time
import os

class Logger:

    # Constructor
    def __init__(self, file_path, file_name, header_line, append=False, delimiter = ';', max_entries = 1000, strategy="Fixed Slices" ):
        self.__delimiter = delimiter
        self.__file_path = file_path
        self.__file_name = file_name
        self.__max_entries = max_entries
        self.__date_format = '%Y-%m-%d %H:%M:%S'
        self.__header_line = self.__delimiter.join(header_line)
        self.__strategy = strategy

        if append:
            self.__file_mode = 'a'
        else:
            self.__file_mode = 'w'


        #Datei erstellen oder öffnen
        self.__file = open(os.path.join(self.__file_path, self.__file_name), self.__file_mode)

        if not append:
            self.__write_header()


    # Getter and Setter 
    def set_delimiter(self, new_delimiter):
        self.__delimiter = new_delimiter
        
    def get_delimiter(self):
        return self.__delimiter

    def __set_filepath(self, new_filepath):
        self.__file_path = new_filepath
        
    def get_filepath(self):
        return self.__file_path

    def __set_filename(self, new_filename):
        self.__file_name = new_filename
        
    def get_filename(self):
        return self.__file_name

    def set_max_entries(self, new_max_entries):
        self.__max_entries = new_max_entries
        
    def get_max_entries(self):
        return self.__max_entries

    def set_date_format(self, new_date_format):
        self.__date_format = new_date_format

    def get_date_format(self):
        return self.__date_format

    def __set_header_line(self, new_header_line):
        self.__header_line = self.__delimiter.join(new_header_line)
        
    def get_header_line(self):
        return self.__header_line
    
    def set_strategy(self, new_strategy):
        self.__strategy = new_strategy
        
    def get_strategy(self):
        return self.__strategy
    


    # print Objekt
    def __str__(self):
        return f"Logdatei: {self.__file}; für Daten im Format: {self.__header_line}"


    #Methods
    def __write_header(self):
        """Writes header in Logfile."""
        start_time = datetime.datetime.now().strftime(self.__date_format)
        self.__file.write(f"#<Name>{os.path.abspath(self.__file.name)}</Name> <Date>{start_time}</Date>\n")
        self.__file.write(f"{self.__header_line}\n")
        self.__file.flush()
    

    def write_entry(self, entry):
        """new entry in Logfile"""
        #TODO überprüfen auf max Zeilen
        #TODO Strategie überprüfen
        timestamp = datetime.datetime.now().strftime(self.__date_format)
        entry_as_string = self.__delimiter.join([timestamp] + entry)
        self.__file.write(f"{entry_as_string}\n")
        self.__file.flush()

# end of Logger class






#weatherLogger (Vorlage von Walter Rothlin)

#Logger erstellen
weather_Logger = Logger(file_path=".", file_name="WeatherLogFile.txt", header_line= ["Timestamp","Level","Ort","q [%]","p_Low [bar]"], append=False)

end_point_url = "https://api.openweathermap.org/data/2.5/weather"
pollingTime = float(input("Polling-Time [s]:"))
ort = input("Ort  [*Uster]   :")
if ort == "":
    ort = 'Uster'

max_counter = int(input("Anzahl requests :"))

appId = "7981747fff728da336869572a14f0a6d"

firstTime = True
counter = 0
doLoop = True
while doLoop:
    counter += 1
    request_url = end_point_url + "?q=" + ort + "&units=metric&lang=de&appid=" + appId
    print("Request:\n", request_url, "\n\n") if firstTime else False
    response = requests.get(request_url)
    response_text = response.text
    response_json = json.loads(response_text)
    
    ortsname = response_json['name']
    pressure = response_json['main']['pressure']
    humidity = response_json['main']['humidity']

    weather_Logger.write_entry(["INFO", ortsname , f"{humidity}", f"{pressure}"])
    time.sleep(pollingTime)
    firstTime = False
    if counter >= max_counter:
        doLoop = False

