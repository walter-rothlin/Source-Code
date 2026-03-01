#!/usr/bin/python

import os
from datetime import datetime
import requests
import json
import time
import datetime

class CSVLogger:
    def __init__(
        self,
        path,
        headers,
        max_rows,
        comment,
        timestamp_format="%Y-%m-%d %H:%M:%S",
        delimiter=",",
        encoding="utf-8",
        start_mode="append",                 # "new" oder "append"
    ):    
    
    # __ --> private Variablen und Methoden
    # _ --> protected --> nur geschützt gegen aussen, wenn abgeleitet wird, kann direkt auf diese varible zugegriffen werden   
        self.__path = path
        self.__headers = list(headers)
        self.__fieldnames = ["Timestamp"] + self.__headers
        self.__max_rows = int(max_rows)
        self.__comment = comment
        self.__timestamp_format = timestamp_format
        self.__delimiter = delimiter
        self.__encoding = encoding
        self.__start_mode = start_mode

        self.__last_values = None  # Werte der letzten Datenzeile (ohne timestamp)
        self.__data_count = 0      # Anzahl Datenzeilen im File (ohne Kommentar/Header)

        # Datei vorbereiten bzw. Zustand laden
        self.__ensure_file_and_load_state()
        print(self.__fieldnames)
        
    # ------------------------- Öffentliche Methoden -------------------------
    
    # -------------------------- Getter und Setter ---------------------------
    def get_path(self):
        return self.__path
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können
    # hier als Beispiel eines Getters als Kommentar
    # def set_path(self, new_path):
        # self.__path = new_path

    def get_headers(self):
        return self.__headers
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können    

    def get_fieldnames(self):
        return self.__fieldnames
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können

    def get_max_rows(self):
        return self.__max_rows
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können
    
    def get_comment(self):
        return self.__comment
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können

    def get_timestamp_format(self):
        return self.__timestamp_format
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können    

    def get_delimiter(self):
        return self.__delimiter
        
    def set_delimiter(self, new_delimiter):
        self.__delimiter = new_delimiter

    def get_encoding(self):
        return self.__encoding
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können

    def get_start_mode(self):
        return self.__start_mode
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können

    def get_last_values(self):
        return self.__last_values
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können

    def get_data_count(self):
        return self.__data_count
    # setter macht keinen Sinn, der Wert soll nicht während der Laufzeit verändert werden können

    
    
    # ---------------------- Öffentlicher Nutzcode --------------------------
    def add_to_log(self, data):
        """
        Fügt einen Datensatz an, *nur* wenn sich gegenüber dem letzten Eintrag Daten geändert haben.
        :param data: Dict (Keys müssen den headers entsprechen) oder Sequenz in der Reihenfolge von headers
        :param ts: optionaler Zeitstempel; Standard: jetzt
        :return: True, wenn geschrieben wurde; False, wenn keine Änderung
        """
        values = self.__csv_join(data)
        if self.__last_values is not None and self.__last_values == values:
            # Keine Änderung -> nichts schreiben
            print('keine Änderung')
            return False

        # Zeitstempel
        timestamp = self.__getTimestamp()
        row = timestamp + self.__delimiter + values

        # Anhängen
        with open(self.__path, "a", encoding=self.__encoding) as f:
            f.write(row + "\n")
            print(f'Hinzugefüg: {row}')

        # Zustand aktualisieren
        self.__last_values = values
        self.__data_count += 1
        print(f'Data Count: {self.__data_count}')

        # Ringpuffer: älteste Datenzeile entfernen, Kommentar & Header bleiben
        if self.__data_count > self.__max_rows:
            self.__trim_oldest_data_row()

        return True   
    
   # ------------------------- Interne Methoden -------------------------
    
    def __ensure_file_and_load_state(self):
        
        '''Legt Datei mit Kommentar & Header an, falls nötig, oder lädt Zustand.
        Berücksichtigt start_mode ('new' | 'continue') und overwrite_comment_on_continue.'''
        if self.__start_mode == "new":
            # Datei neu anlegen (ggf. Verzeichnis erstellen)
            directory = os.path.dirname(self.__path)
            if directory:
                os.makedirs(directory, exist_ok=True)   # exists_ok vermeidet einen fehler, wenn das file schon da ist
            '''with vereinfacht das Arbeiten mit Kontexten,
            die Ressourcen öffnen und wieder sauber aufräumen müssen (Dateien, Locks, Datenbank‑Transaktionen, …).
            Es sorgt dafür, dass am Ende automatisch aufgeräumt wird – auch wenn ein Fehler auftritt.'''
            with open(self.__path, "w", encoding=self.__encoding) as f:
                f.write(f"# {self.__comment}\n")
                f.write(self.__csv_join(self.__fieldnames) + "\n")
            self.__last_values = None
            self.__data_count = 0
            return

        # start_mode == "continue"
        if not os.path.exists(self.__path):
            # Falls nicht vorhanden, neu erstellen
            directory = os.path.dirname(self.__path)
            if directory:
                os.makedirs(directory, exist_ok=True)   # exists_ok vermeidet einen fehler, wenn das file schon da ist
            '''with vereinfacht das Arbeiten mit Kontexten,
            die Ressourcen öffnen und wieder sauber aufräumen müssen (Dateien, Locks, Datenbank‑Transaktionen, …).
            Es sorgt dafür, dass am Ende automatisch aufgeräumt wird – auch wenn ein Fehler auftritt.'''
            with open(self.__path, "w", encoding=self.__encoding) as f:
                f.write(f"# {self.__comment}\n")  #f string mit kommentar + new line
                f.write(self.__csv_join(self.__fieldnames) + "\n")
            self.__last_values = None
            self.__data_count = 0
            return
        
    def __csv_join(self, fields):
        """
        Den time stamp und die Zeilenüberschriften zusammen hängen
        """
        return self.__delimiter.join(fields) # join fügt alle Elemente einr Sequenz, z.B. einer Liste als string zusammen
        
        
    def __getTimestamp(self):
        """
        Time Stamp generieren
        """
        
        return datetime.datetime.now().strftime(self.__timestamp_format)
        
        
    def __trim_oldest_data_row(self):
        """
        Entfernt die *erste Datenzeile* (Zeile 3 in der Datei), behält Kommentar & Header.
        """
        with open(self.__path, "r", encoding=self.__encoding) as f:
            lines = f.read().splitlines()

        if len(lines) < 3:
            return

        # Entferne die älteste Datenzeile (Index 2)
        del lines[2]

        with open(self.__path, "w", encoding=self.__encoding) as f:
            for line in lines:
                f.write(line + ("\n" if not line.endswith("\n") else ""))

        self.__data_count -= 1
        print(f'Ältester Eintrag gelöscht: Data Count: {self.__data_count}')
        
        # __last_values bleibt korrekt, da wir stets am Ende angefügt haben 



    def __str__(self):
        # last_values schön formatieren:
        if self.__last_values is None:
            last_values_str = "— (noch keine Datenzeile geschrieben)"
        else:
            last_values_str = str(self.__last_values)

        return (
            "CSVLogger-Status\n"
            f"  Pfad           : {self.__path}\n"
            f"  Aktive Zeilen  : {self.__data_count}\n"
            f"  Letzter Eintrag: {last_values_str}"
        )     
   
          

# ------------------------------------------------------------------
# Hier beginnt das Testprogramm
# Basis übernommen von:
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_05.py
# ------------------------------------------------------------------

if __name__ == '__main__':
    
    
    """
    Benutzereingabe und initialisierung
    """
    
    ort_wetterstation = 'Eschenbach SG' #input("Ort                        :")# vorübergehend hardgecoded --> weniger aufwändig zum testen
    language = 'de' #input("Sprache [de,el,en,fr,hr,it]:")                    # vorübergehend hardgecoded --> weniger aufwändig zum testen
    if language == '':
        language = 'de'
    if ort_wetterstation == '':
        ort_wetterstation = 'Wangen+SZ' 


    lofFilename = "weatherLog.txt"
    delimiter = ";"
    pollingTime = 1.0 #float(input("Polling-Time [s]           :"))           # vorübergehend hardgecoded --> weniger aufwändig zum testen

    url_end_point = "http://api.openweathermap.org/data/2.5/weather"
    params_end_point = {
        'q': ort_wetterstation,
        'appid': 'd59e52382422b206e555c82ee6bfda04',
        'mode': '',          # xml, html
        'units': 'metric',   # standard, metric, imperial
        'lang': language,        # de, el (Greek), en (English), fr (French), hr (Croatian), it (Italien)
    }

    # muss hier schonmal abgefragt werden, damit die Coordinaten in den commentar des loggers abgefüllt werden können
    responseStr = requests.get(url_end_point, params=params_end_point)
    jsonResponse = json.loads(responseStr.text)

    coord = jsonResponse['coord']        
    
    # Instanz des loggers erstellen mit den vorher ermittelten Usereingaben
    logger = CSVLogger(
            path=lofFilename,
            headers=["Level", "Temp [°C]", "Druck [mBar]", "Feuchte [%]", "Bezeichnung [" + language + "]", "Beschreibung [" + language + "]"],
            max_rows=10,
            comment="<Config><Ort>" + ort_wetterstation + "</Ort><Lon>" + str(coord['lon']) + "</Lon><Lat>" + str(coord['lat']) + "</Lat><FName>" + lofFilename + "</FName></Config>",
            timestamp_format="%Y-%m-%d %H:%M:%S",
            delimiter=delimiter,
            encoding="utf-8",
            start_mode="new")
            
    doLoop = True
    
    while doLoop:
        responseStr = requests.get(url_end_point, params=params_end_point)
        jsonResponse = json.loads(responseStr.text)
        temp = jsonResponse['main']['temp']
        pressure = jsonResponse['main']['pressure']
        humidity = jsonResponse['main']['humidity']
        bezeichnung = jsonResponse['weather'][0]['main']
        beschreibung = jsonResponse['weather'][0]['description']                  
             
        logger.add_to_log(["INFO", str(temp), str(pressure), str(humidity), bezeichnung, beschreibung])
        
        # Eingrag erstellen, der vom letzten abweicht, damit das Befüllen der Datei getestet werden kann     
        #logger.add_to_log(["WARNING", str(temp), str(pressure), str(humidity), bezeichnung, beschreibung])          
        
        # __str__ testen
        print(logger) 
        
        time.sleep(pollingTime)
    
