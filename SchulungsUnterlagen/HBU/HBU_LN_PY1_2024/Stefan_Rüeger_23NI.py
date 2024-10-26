#!/usr/bin/python3

# MLZ HFU 2024
#
# WetterLogger
# ============
#
# Implemeniert eine Logger-Klasse und zeichnet Daten von OpenWeather auf.
#
# Autor:  Stefan Rüeger
# Klasse: HFU 23NI
# Dozent: Walter Rothlin
#

import json
import requests
from time import sleep
from datetime import datetime
from os.path import join

########################## Logger Einstellungen ##########################
API_key         = "aef827df6d038c6c4e604cf10a15962c"
location        = "Kindhausen"
lang            = "de"
delimiter       = ";"
file_path       = "."
file_name       = "WetterLog.csv"
max_entries     = 6
only_changes    = False
append_log      = False
sample_time     = 2 # Sekunden
log_level       = ['DEBUG', 'INFO', 'WARNINGS', 'ERROR', 'CRITICAL']
##########################################################################

url_str     = f"https://api.openweathermap.org/data/2.5/weather?q={location}&units=metric&lang={lang}&appid={API_key}"

class FileLogger:

    # Konstruktor
    def __init__(self, 
                 filename='log.txt', 
                 path='./', 
                 append=False, 
                 max_entries=100, 
                 title = "Titel", 
                 description = "Description",
                 only_changes = False,
                 format_timestamp = "%Y-%m-%d %H:%M:%S",
                 delimiter = ';'):
        
        self.__filename = filename
        self.__filepath = path
        self.__max_entries = max_entries
        self.__log_length = 0
        self.__log_title = title
        self.__log_description = description
        self.__only_changes = only_changes
        self.__last_entry = ''
        self.__format_timestamp = format_timestamp
        self.__log_append = append
        self.delimiter = delimiter

        self.__fullpath = join(self.__filepath, self.__filename)

        self.__fixLogLength()
        if self.__log_append:
            self.__log_length = self.logLength()
        else:
            self.newLog(self.__log_title, self.__log_description)
            self.__log_length = 0


    # String-Repräsentation des Objekts
    def __str__(self):
        return f"Objekt der Klasse FileLogger, filename = [{self.__filename}]"
    
    # Business-Methoden
    # =================    

    def newLog(self, title, description):
        """Erstelle ein neues Log-File.

        Argumente
        title       : Titel des Logfiles
        description : Spaltenbeschriftung
        """
        with open (self.__fullpath, 'w', encoding='utf-8') as file:
            file.write(title+'\n')
            file.write(description+'\n')


    def __fixLogLength(self):
        """Passt die Anzahl Logeinträge an, falls neues Maximum < altes Maximum."""
        actual_length = self.logLength()
        if actual_length > self.__max_entries:
            with open (self.__fullpath, 'r', encoding='utf-8') as file:
                log = file.readlines()
            
            self.newLog(self.__log_title, self.__log_description)
            
            with open (self.__fullpath, 'a', encoding='utf-8') as file:
                line_count = -1
                for line in log:
                    if line_count > actual_length - max_entries:
                        file.write(line)
                    line_count += 1
        self.__log_length = max_entries


    def logLength(self):
        """Ermittelt die antuelle Länge des Log.

        Rückgabewert : aktuelle Länge (int)
        """
        with open (self.__fullpath, 'r', encoding='utf-8') as file:
            log = file.readlines()
            actual_length = 0
            for line in log:
                actual_length += 1
        return actual_length-2


    def __delFirstEntry(self):
        """Löscht ersten Log-Eintrag falls Log > Maximum."""
        with open (self.__fullpath, 'r', encoding='utf-8') as file:
            log = file.readlines()
        with open (self.__fullpath, 'w', encoding='utf-8') as file:
            line_count = 0
            for line in log:
                if line_count != 2:
                    file.write(line)
                line_count += 1


    def addEntry(self, new_entry):
        """Fügt neuen Eintrag ins Log.

        Argumente
        new_entry : neuer Eintrag (string)
        """
        with open (self.__fullpath, 'a', encoding='utf-8') as file:

            if self.__log_length >= self.__max_entries:
                self.__delFirstEntry()
                
            entry = f"{self.__timeStamp()}{self.delimiter}{new_entry}"

            if self.__only_changes:
                self.__last_entry = new_entry
                if self.__last_entry == new_entry:
                    file.write(entry)
                    self.__log_length += 1
                    self.__last_entry = new_entry
            else:
                file.write(entry)
                self.__log_length += 1


    def __timeStamp(self):
        """Erstelle aktuellen Zeitstempel.

        Rückgabewert : aktuelles Datum und aktuelle Zeit (string)
        """
        return datetime.now().strftime(self.__format_timestamp)

    # setter / getter Methoden
    #
    def get_filepath(self):
        return self.__filepath

    def set_filepath(self, filepath):
        self.__filepath = filepath
        self.__fullpath = join(self.__filepath, self.__filename)

    def get_filename(self):
        return self.__filename

    def set_filename(self, filename):
        self.__filename = filename
        self.__fullpath = join(self.__filepath, self.__filename)
        print(self.__fullpath)

    def get_maxEntries(self):
        return self.__max_entries

    def set_maxEntries(self, max_entries):
        self.__max_entries = max_entries

    def get_appendLog(self):
        return self.__log_append

    def set_appendLog(self, append):
        self.__log_append = append

    def get_onlyChanges(self):
        return self.__only_changes

    def set_onlyChanges(self, only_changes):
        self.__only_changes = only_changes

    def get_delimiter(self):
        return self.delimiter

    def set_onlyChanges(self, delimiter):
        self.delimiter = delimiter


def main():
    """Hauptprogramm, initialisiert die Logger-Klasse und liest aktuelle 
    Wetterwerte von OpenWeather aus. Gibt Werte auf Bildschirm aus und 
    speichert sie mit im Header des Codes konfigurierbaren Strategien im Log.
    """
    wd = json.loads(requests.get(url_str).text)
    print(f"\n\n  AKTUELLE WETTERDATEN {wd['name']} {wd['sys']['country']}\n", 52 * "-", "\n")
    print(f"  {wd['main']['temp']:3.1f}°C, gefühlt wie {wd['main']['feels_like']:3.1f}°C. {wd['weather'][0]['description']}\n")
    print(f"  {wd['coord']['lat']}° nördliche Breite, {wd['coord']['lon']}° östliche Länge")
    print(f"  www.openstreetmap.org/#map=14/"+str(wd['coord']['lat'])+"/"+str(wd['coord']['lon']), "\n")
    print(f"              Wind: {wd['wind']['speed']:.1f} m/s aus {wd['wind']['deg']}°")
    print(f"         Luftdruck: {wd['main']['pressure']:d} hPa")
    print(f"  Rel. Luftfeuchte: {wd['main']['humidity']:d}%")
    print(f"             Sicht: {wd['visibility']/1000:.1f} km\n")
    print(f"Abbruch der Aufzeichnung mit Ctrl-C.\n")
    

    time_stamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    header_title = f"#<Name>{join(file_path, file_name)}</Name> <Date> {time_stamp} </Date>"
    header_description = f"Zeitstempel{delimiter}Temp[°C]{delimiter}Luftdruck[hPa]{delimiter}rF[%]{delimiter}Beschreibung{delimiter}Log-Level"
    log = FileLogger(append=append_log, 
                     max_entries=max_entries, 
                     title=header_title, 
                     description=header_description, 
                     only_changes=only_changes, 
                     delimiter=delimiter,
                     filename=file_name,
                     path=file_path)
    print(f"Objekt-Referenz von Objekt 'Log': \n{log}\n")

    print("Zeitstempel           Temp     Luftdruck  rF    Beschreibung")

    while True:
        wd = json.loads(requests.get(url_str).text)
        print(f"{time_stamp} {wd['main']['temp']:6.1f}°C {wd['main']['pressure']:6d} hPa {wd['main']['humidity']:4d}%   {wd['weather'][0]['description']:20}")
        
        log_entry = f"{wd['main']['temp']:.1f}{log.delimiter}"
        log_entry += f"{wd['main']['pressure']:d}{log.delimiter}{wd['main']['humidity']:d}{log.delimiter}"
        log_entry += f"{wd['weather'][0]['description']}{log.delimiter}{log_level[1]}\n"
        log.addEntry(log_entry)
        sleep(sample_time)


if __name__ == '__main__': 
    try:
        main()
    except KeyboardInterrupt:
        pass
