#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Logger_Benz_Christian.py
# Source: 
#
# Description: Logs weather data received from a REST-Service (JSON)
#
# Autor: Christian Benz 
#
# History:
# 29-Jun-2026   Christian Benz
# ------------------------------------------------------------------

import requests
import json
import time
import datetime
from pathlib import Path
from typing import List, Iterable, Any, Optional

class LogMode:
    FixedSlices = 1
    OnlyChanges = 2

class txtlogger:
    def __init__(self,
        file_path: str,
        header: str,
        description: List[str],
        delimiter: str = ";",
        max_entries: Optional[int] = None,
        log_mode: int = LogMode.FixedSlices,
        encoding: str = "utf-8"
        ):

        self.file_path = Path(file_path)
        self.header = header
        self.description = description
        self.delimiter = delimiter
        self.max_entries = max_entries
        self.log_mode = log_mode
        self.encoding = encoding
        self._last_values = None

        # Zielverzeichnis anlegen
        self.file_path.parent.mkdir(parents=True, exist_ok=True)

        # Datei mit Header erstellen, falls sie noch nicht existiert
        if not self.file_path.exists():
            with self.file_path.open("w", encoding=self.encoding) as file:
                file.write(self.header + "\n")
                file.write(self.delimiter.join(self.description) + "\n")

    def log(self, values: Iterable[Any]):

            values = list(values)
            
             # Nur bei Änderung loggen
            if self.log_mode == LogMode.OnlyChanges and self._last_values is not None:
                if self._last_values[1:] == values[1:]:
                    return

            # Alter Wert speichern, um Änderungen zu erkennen
            self._last_values = values.copy()

            line = self.delimiter.join(map(str, values))

            with self.file_path.open("a", encoding=self.encoding) as file:
                file.write(line + "\n")

            # Prüfen, ob die maximale Anzahl an Einträgen überschritten wurde
            self._check_max_entries()


    def _check_max_entries(self):

        if self.max_entries is None:
            return

        with self.file_path.open("r", encoding=self.encoding) as file:
            lines = file.readlines()

        if len(lines) <= 1:
            return

        header = lines[0]
        description = lines[1]
        data = lines[2:]

        # Wenn die maximale Anzahl an Einträgen überschritten wurde, die ältesten Einträge entfernen
        if len(data) > self.max_entries:
            data = data[-self.max_entries:]

            # Datei mit den verbleibenden Einträgen neu schreiben
            with self.file_path.open("w", encoding=self.encoding) as file:
                file.write(header)
                file.write(description)
                file.writelines(data)


if __name__ == "__main__":
    def getTimestamp(preStr = "", postStr="", formatString="nice"):
        formatStr = '{:%Y-%m-%d %H:%M:%S}'
        if (formatString == ""):
         formatStr = '{:%Y%m%d%H%M%S}'
        elif (formatString == "nice"):
            formatStr = '{:%Y-%m-%d %H:%M:%S}'
        else:
            formatStr = formatString
        retStr = formatStr.format(datetime.datetime.now())
        return preStr + retStr + postStr

    File_Path = "D:/Logs/"
    File_Name = "weatherLog.txt"
    Log_Mode = LogMode.FixedSlices # OnlyChanges , FixedSlices
    Max_Entries = 10
    delimiter = "|" # "|", ";"
    pollingTime = float(input("Polling-Time [s]           :"))


    ort_wetterstation = input("Ort                        :")
    language = input("Sprache [de,el,en,fr,hr,it]:")
    if language == '':
        language = 'de'
    if ort_wetterstation == '':
        ort_wetterstation = 'Wangen+SZ'

    url_end_point = "http://api.openweathermap.org/data/2.5/weather"
    params_end_point = {
        'q': ort_wetterstation,
        'appid': 'ebf674f5b0680bb41e7882be2ad3946d',
        'mode': '',          # xml, html
        'units': 'metric',   # standard, metric, imperial
        'lang': language,        # de, el (Greek), en (English), fr (French), hr (Croatian), it (Italien)
    }


    responseStr = requests.get(url_end_point, params=params_end_point)
    jsonResponse = json.loads(responseStr.text)

    coord = jsonResponse['coord']
    print(jsonResponse)
    print(coord)
    print(jsonResponse['weather'][0])

    # Konfigurationsheader erstellen
    headerStr  = "# <Config><Ort>" + ort_wetterstation + "</Ort><Lon>" + str(coord['lon']) + "</Lon><Lat>" + str(coord['lat']) + "</Lat><FName>" + File_Name + "</FName></Config>"
    # Header für die Spaltenüberschriften erstellen
    description = ["Timestamp", "Level", "Temp [°C]", "Druck [mBar]", "Feuchte [%]", "Bezeichnung [" + language + "]", "Beschreibung [" + language + "]"]

    # Logger-Instanz erstellen
    logger = txtlogger(file_path=File_Path + File_Name, header =headerStr ,description=description, delimiter=delimiter, log_mode=Log_Mode, max_entries=Max_Entries)


    doLoop = True
    while doLoop:
        responseStr = requests.get(url_end_point, params=params_end_point)
        jsonResponse = json.loads(responseStr.text)
        temp = jsonResponse['main']['temp']
        pressure = jsonResponse['main']['pressure']
        humidity = jsonResponse['main']['humidity']
        bezeichnung = jsonResponse['weather'][0]['main']
        beschreibung = jsonResponse['weather'][0]['description']

        logStr = getTimestamp() + delimiter +  "INFO" + delimiter + str(temp) + delimiter + str(pressure) + delimiter + str(humidity) + delimiter + bezeichnung + delimiter + beschreibung
        print(logStr)

        # Loggen der Daten in die Datei
        logger.log([getTimestamp(),"INFO", str(temp), str(pressure), str(humidity), bezeichnung, beschreibung])


        time.sleep(pollingTime)