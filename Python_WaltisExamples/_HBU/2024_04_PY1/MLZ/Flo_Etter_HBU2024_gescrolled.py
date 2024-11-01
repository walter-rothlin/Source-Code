
'''
Bewertung
========
1. Lauffähiger Code abgegeben (2 Punkte)                                                2
2. CLI Applikation schreibt ein Log-File (2 Punkte)                                     2
3. Für den Weather REST Service wurde ein eigener Token verwendet                       1
4. Eine eigene, reusable Klasse mit einfachem Interface implementiert (4 Punkte)        4
5. Nur absolut Notwendiges ist public (2 Punkte)                                        0
6. Kommentare in Form von doc_strings sind enthalten                                    0
7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                                 0
8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)                            1
9. Log-Entries enthalten formatierten Time-Stamp und Level                              1
9a. Scrolling Strategie implementiert                                                   1
10. Anzahl Zeilen für Scrollbereich definierbar                                         1
11. ChangesOnly implementiert                                                           0
12. Append / New implementiert                                                          1
13. Delimiter via __init__ setzbar (mit Default-Wert)                                   1
14. Strategie via __init__ setzbar (mit Default-Wert)                                   1
15. Scrolling area via __init__ setzbar (mit Default-Wert)                              1
                                                                -------------------------
                                                                Max. Punkte:22         18
                                                                =========================

- initializer kreiert kein file
- kein heartbeat
- Strategie "OnlyChanges" nicht implementiert
- Strategie "FixedSlices" löscht auch header?

'''

import json
import requests
import time
import datetime
import os
#-------------Konstruktor-----------
class Logger:
    def __init__(self, file_path, delimiter='|', log_level='INFO', max_entries=10, strategy='Fixed Slices', append=False):
        self.file_path = file_path
        self.delimiter = delimiter
        self.log_level = log_level
        self.max_entries = max_entries
        self.strategy = strategy
        self.append = append
        self.entries = []
        self.start_time = datetime.datetime.now()
#-------------Ende Konstruktor-----------

# -------Erstellen der Log-Datei mit Header
        # Wenn Datei existiert und append=False, Datei neu erstellen
        if not self.append: # neue Zeile
            self._init_log_file()
        
    def _init_log_file(self):
        with open(self.file_path, 'w') as f:
            f.write(f"<!-- Log File: {self.file_path}, Start-Time: {self.start_time} -->\n")
            f.write(f"Timestamp{self.delimiter}Log-Level{self.delimiter}Message\n")

    def log(self, message, level='INFO'):
        timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log_entry = f"{timestamp}{self.delimiter}{level}{self.delimiter}{message}\n"

        # Füge neuen Eintrag hinzu
        self.entries.append(log_entry)

        # Prüfen, ob die maximale Anzahl der Einträge erreicht ist
        if len(self.entries) > self.max_entries:
            if self.strategy == 'Fixed Slices':
                self.entries = self.entries[-self.max_entries:]  # Behalte nur die letzten max_entries

        # Schreibe die Datei neu mit den neuesten Einträgen, behalte den Header
        self._write_log_file()


    def _write_log_file(self):
        with open(self.file_path, 'w') as f:
            f.write(f"<!-- Log File: {self.file_path}, Start-Time: {self.start_time} -->\n")
            f.write(f"Timestamp{self.delimiter}Log-Level{self.delimiter}Message\n")
            f.writelines(self.entries)
#-------------Ende-----------
            
#-------------Setter definieren-----------
            # Setter sind public, nicht private
            
    def set_delimiter(self, delimiter):  # Delimiter (Default: „|“, siehe Zeile 8)
        self.delimiter = delimiter

    def set_file_path(self, file_path):  #File-Path und File-Name
        self.file_path = file_path

    def set_max_entries(self, max_entries):  #Anzahl Einträge, ab wann „gescrolled“ wird 
        self.max_entries = max_entries       # resp. alte Einträge gelöscht werden soll

    def set_strategy(self, strategy):  #Aufzeichnungs-Strategie (Fixed Slices, OnlyChanges)
        self.strategy = strategy
#-------------Setter Ende-----------

# CLI Applikation zum Testen des Loggers
def weather_logger(sample_time, url, logger): # Argumente 'Sample-Time', 'url' implementiert
    try:                         # url ==> ist link zu Link oder die Adresse einer Webseite
        while True:
            response = requests.get(url)
            response_data = json.loads(response.text)

            ort = response_data['name']
            land = response_data['sys']['country']
            temp = round(response_data['main']['temp'], 1)
            wetter = response_data['weather'][0]['description']
            luftfeuchtigkeit = response_data['main']['humidity']
            luftdruck = response_data['main']['pressure']
            #sunrise_unix = response_data['sys']['sunrise']
            #sunrise_time = datetime.datetime.fromtimestamp(sunrise_unix).strftime("%H:%M:%S")

            # Log-Nachrichten
            logger.log(f"Ortsname: {ort}, Land: {land}, Temp: {temp}°C, Wetter: {wetter}, "
                       f"Luftfeuchtigkeit: {luftfeuchtigkeit}%, Luftdruck: {luftdruck}mbar", level='INFO')
                       # alt: Sonnenaufgang: {sunrise_time}",
            
            time.sleep(sample_time)
    except KeyboardInterrupt:
        # Wenn mit ctrl+c beenden, dann wird untiger Text in die Konsole geschrieben
        print("Die letzten Log-Zeilen wurden ins File weather_log.txt geschrieben")
        print('Weather logging beendet.')


if __name__ == '__main__':
    # Beispiel für CLI-Eingaben
    ort = input('Ort:')
    units = 'metric'
    api_key = 'f6c545d8fd2e92577c73ab77b6438c10'
    #sprache = 'de'
    url = f"https://api.openweathermap.org/data/2.5/weather?q={ort}&units={units}&lang=de&APPID={api_key}"

    # Logger Initialisieren
    logger = Logger(file_path='Flo_Etter_log.txt', delimiter='|', max_entries=4, strategy='Fixed Slices', append=False)

    # Wetterdaten periodisch loggen
    weather_logger(sample_time=5, url=url, logger=logger)
