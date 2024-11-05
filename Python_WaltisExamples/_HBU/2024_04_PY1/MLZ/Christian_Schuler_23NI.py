#!/usr/bin/python3

'''
Bewertung
========
1. Lauffähiger Code abgegeben (2 Punkte)                                                2
2. CLI Applikation schreibt ein Log-File (2 Punkte)                                     2
3. Für den Weather REST Service wurde ein eigener Token verwendet                       1
4. Eine eigene, reusable Klasse mit einfachem Interface implementiert (4 Punkte)        4
5. Nur absolut Notwendiges ist public (2 Punkte)                                        2
6. Kommentare in Form von doc_strings sind enthalten                                    1
7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                                 1
8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)                            1
9. Log-Entries enthalten formatierten Time-Stamp und Level                              1
9a. Scrolling Strategie implementiert                                                   0
10. Anzahl Zeilen für Scrollbereich definierbar                                         1
11. ChangesOnly implementiert                                                           0
12. Append / New implementiert                                                          1
13. Delimiter via __init__ setzbar (mit Default-Wert)                                   1
14. Strategie via __init__ setzbar (mit Default-Wert)                                   0
15. Scrolling area via __init__ setzbar (mit Default-Wert)                              0
                                                                -------------------------
                                                                Max. Punkte:22         18
                                                                =========================
- initializer kreiert kein file

'''

import datetime
import time
import json
import requests

class CsuLogger:

    #initialisierer
    def __init__(self, delimiter=';', file_path='./', file_name='Christian_Schuler_log.txt', new_file=True, log_count=1000):
        print('__init__() called!')
        self.__delimiter = delimiter
        self.__file_path = file_path
        self.__file_name = file_name
        self.__new_file = new_file
        self.__log_count = log_count
        self.__timestamp_format = '%d.%m.%Y %H:%M:%S'
        self.__started = False
    
    # wie toString Methode
    def __str__(self):
        return f'''Ein Objekt der Klasse CsuLogger: 
                    Trennzeichen = {self.__delimiter}
                    Standard Pfad = {self.__file_path}
                    Standard Name = {self.__file_name}
                    Neue Datei = {self.__new_file}
                    Anzahl Logs = {self.__log_count}
                '''

    # setter / getter
    def set_delimiter(self, new_delimiter):
        if not self.__started:
            self.__delimiter = new_delimiter
    def get_delimiter(self):
        return self.__delimiter
    
    def set_file_path(self, new_file_path):
        self.__file_path = new_file_path
    def get_file_path(self):
        return self.__file_path
    
    def set_file_name(self, new_file_name):
        self.__file_name = new_file_name
    def get_file_name(self):
        return self.__file_name

    # Flag nur setzbar, wenn Logger nicht gestartet
    def set_new_file(self, new_new_file):
        if not self.__started:
            self.__new_file = new_new_file
    def get_file_path(self):
        return self.__new_file

    def set_log_count(self, new_log_count):
        self.__log_count = new_log_count
    def get_file_path(self):
        return self.__log_count   

    def set_timestamp_format(self, new_timestamp_format):
        self.__timestamp_format = new_timestamp_format
    def get_timestamp_format(self):
        return self.__timestamp_format 
    
    #Private Methoden
    def __get_formatted_timestamp(self):
        return format(datetime.datetime.now(), self.__timestamp_format)


    #Business Methoden
    def start(self):
        '''
        Diese Methode startet das Loggen
        '''
        self.__started = True
        print('start() called')
        #unabhängig von der Timestamp Property!
        self.__started_Timestamp = str(format(datetime.datetime.now(),'%d.%m.%Y %H:%M:%S'))
        
        if self.__new_file:
            #neue datei erstellen oder existierende überschreiben
            f = open(self.__file_name, 'w', encoding='utf-8')
            f.write(f'# <Name>{self.__file_path}{self.__file_name}</Name> <Date>{self.__started_Timestamp}</Date>\n')
            f.write(f'Timestamp{self.__delimiter}Level{self.__delimiter}Text{self.__delimiter}\n')

        else:
            #bestehende Datei ergänzen
            f = open(self.__file_name, 'a', encoding='utf-8')

        #f.write(f'{self.__logging_start}\n')
        f.close()
    
    def stopp(self):
        '''
        Diese Methode stoppt das Loggen
        '''
        self.__started = False
        print('stopp() called')
    
    def add(self,log_level=1,text=None):
        '''
        Diese Methode erzeugt einen neuen Log Eintrag
        '''
        if not self.__started:
            self.start()

        if log_level == 1:
            log_level_text = 'DEBUG'
        elif log_level == 2:
            log_level_text = 'INFO'
        elif log_level == 3:
            log_level_text = 'WARNINGS'
        elif log_level == 4:
            log_level_text = 'ERROR'
        elif log_level == 5:
            log_level_text = 'CRITICAL'
        else:
            log_level_text = 'NOT DEFINED'
        
        f = open(self.__file_name, 'a', encoding='utf-8')
        f.write(f'{self.__get_formatted_timestamp()}{self.__delimiter}{log_level_text}{self.__delimiter}{text}\n')
        f.close() 

        
# -------------------- Tests --------------------
if __name__ == '__main__':
    #Instanz vom Objekt erstellen
    testLogger = CsuLogger()
    #eigener Token
    url_str = 'https://api.openweathermap.org/data/2.5/weather?q=Matt&units=metric&lang=de&appid=26e417f6de4eaa1d9894cec154d7d65b'

    #definierter String ausgeben
    print(testLogger)

    #delimiter property anzeigen
    print(testLogger.get_delimiter())

    #delimiter ändern und wieder anzeigen
    testLogger.set_delimiter(',')
    print(testLogger.get_delimiter())
    
    #Timestamp Property ändern
    testLogger.set_timestamp_format('%d-%m-%Y')

    #Logger Instanz explizit starten
    testLogger.start()

    #Erster Eintrag ohne Argumente
    testLogger.add()

    #Nach dem Start soll der Delimiter nicht mehr geändert werden können
    testLogger.set_delimiter(';')
    
    #Format vom Timestamp ändern
    testLogger.set_timestamp_format('%d.%m.%Y %H:%M:%S')
    
    testLogger.add()

    testLogger.add(log_level=1,text='hallo')
    time.sleep(2)
    testLogger.add(log_level=2, text='ein Eintrag')
    time.sleep(5)
    testLogger.add(log_level=3, text='dies loggen')
    testLogger.add(log_level=4)
    time.sleep(2)
    testLogger.add(log_level=5, text='Übersicht verloren, was ist erledigt und was fehlt noch ...')
    testLogger.add(log_level=125)
 
    #Test mit Wetterdaten
    def get_output_str(responseStr):
        jsonResponse = json.loads(responseStr.text)

        Ort_str = jsonResponse['name']
        Temp_str = jsonResponse['main']['temp']
        Pressure_str = jsonResponse['main']['pressure']
        Humidity_str = jsonResponse['main']['humidity']

        return str(f'{Ort_str} {Temp_str}°C {Pressure_str}hPa {Humidity_str}%')
    
    print(get_output_str(requests.get(url_str)))

    testLogger.add(log_level=2,text=get_output_str(requests.get(url_str)))
    time.sleep(30)
    testLogger.add(log_level=2,text=get_output_str(requests.get(url_str)))

    #Logger stoppen
    testLogger.stopp()