#!usr/bin/python
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Aufgabe der MLZ in Python
#
#Eine einfache Logger-Klasse in Python schreiben,
#die Daten in eine CSV-Datei speichert.
#Die Datei hat zwei feste Header-Zeilen.
#Jeder Log-Eintrag enthält einen Zeitstempel, ein Log-Level und die übergebenen Daten.
#Die zentrale Methode ist add_to_log().
#Der Logger soll konfigurierbar sein
#und optional nur Änderungen loggen oder alte Einträge löschen.
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Datum der Aufgabe
#14.01.2026
#Andreas Rosenkranz
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

from datetime import datetime
import os

class CsvLogger:
    def __init__(self, file_path, delimiter="|", append=True, timestamp_format="%Y-%m-%d %H:%M:%S"):
        self.__file_path = file_path
        self.__delimiter = delimiter
        self.__append = append
        self.__timestamp_format = timestamp_format
        self.__columns = None
        self.__strategy = "OnlyChanges"
        self.__last_data = None
        self.__max_entries = 3


        folder = os.path.dirname(self.__file_path)
        if folder != "":
            os.makedirs(folder, exist_ok=True)

        if (not self.__append) or (not os.path.exists(self.__file_path)) or os.path.getsize(self.__file_path) == 0:
            created = datetime.now().strftime("%B %d, %Y %H:%M:%S")
            with open(self.__file_path, "w") as f:
                f.write(f"# <Filename>{self.__file_path}</Filename><Created>{created}</Created>\n")
                f.write("Timestamp" + self.__delimiter + "Level\n")

    def __set_title(self):
        with open(self.__file_path, "r") as f:
            lines = f.readlines()

        title = "Timestamp" + self.__delimiter + "Level"
        for c in self.__columns:
            title += self.__delimiter + c

        lines[1] = title + "\n"

        with open(self.__file_path, "w") as f:
            f.writelines(lines)

    def __scroll(self):
        if self.__max_entries <= 0:
            return
        with open(self.__file_path, "r") as f:
            lines = f.readlines()
        header = lines[:2]
        entries = lines[2:]
        if len(entries) > self.__max_entries:
            entries = entries[-self.__max_entries:]
            with open(self.__file_path, "w") as f:
                f.writelines(header + entries)

    def __count_entries(self):
        if not os.path.exists(self.__file_path):
            return 0
        with open(self.__file_path, "r") as f:
            lines = f.readlines()
        if len(lines) <= 2:
            return 0
        return len(lines) - 2


    def add_to_log(self, level, data_dict):
        if self.__strategy == "OnlyChanges":
            if self.__last_data == data_dict:
                return False

        if self.__columns is None:
            self.__columns = list(data_dict.keys())
            self.__set_title()

        ts = datetime.now().strftime(self.__timestamp_format)
        level = str(level).upper().strip()

        line = ts + self.__delimiter + level
        for key in data_dict:
            line += self.__delimiter + str(data_dict[key])
        line += "\n"

        self.__last_data = dict(data_dict)

        with open(self.__file_path, "a") as f:
            f.write(line)

        self.__scroll()
    
    def __str__(self):
        return (
            f"Path/Filename: {self.__file_path}\n"
            f"Aktive Log-Zeilen: {self.__count_entries()}\n"
            f"Delimiter: {self.__delimiter}\n"
            f"Strategy: {self.__strategy}\n"
            f"Max Entries: {self.__max_entries}"
        )


if __name__ == "__main__":
    log = CsvLogger("/home/snap3/Documents/test.csv", append=False)
    log.add_to_log("INFO", {"Temp": "10.1", "Hum": "55"})
    log.add_to_log("INFO", {"Temp": "10.2", "Hum": "55"})
    log.add_to_log("INFO", {"Temp": "10.3", "Hum": "55"})
    log.add_to_log("INFO", {"Temp": "10.4", "Hum": "55"})
    log.add_to_log("INFO", {"Temp": "10.5", "Hum": "55"})
    print(log)

