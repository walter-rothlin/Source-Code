import csv
import datetime
import json
import pathlib
import time
from enum import Enum
import requests


def get_timestamp():
    """
    function to get Date and time
    :return: Date and time as string
    """
    return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())


class LogLevel(Enum):
    """
    Enum for all log levels
    """
    DEBUG = 'DEBUG'
    INFO = 'INFO'
    WARN = 'WARNING'
    ERROR = 'ERROR'
    CRITICAL = 'CRITICAL'


class MyLogger:
    def __init__(self, file_columns, filename: str = 'test.csv', seperator: str = ';', max_file_length: int = 10,
                 only_changes: bool = False) -> None:
        """
        Initializer for MyLogger
        :param file_columns: columns of header
        :param filename: filename of file
        :param seperator: separator for values
        :param max_file_length: maximal file length
        :param only_changes: boolean if it should only log changes
        """
        self.__file_columns = file_columns
        self.__max_file_length = max_file_length
        self.__filename = filename
        self.__only_changes = only_changes
        self.__seperator = seperator
        self.__file_exists()
        self.__csv_file = self.__check_file()

    def __create_header(self) -> None:
        """
        function to create header of file
        """
        xml_header_format = "# <Name>{}</Name> <Date>{}</Date>"
        self.write_line([xml_header_format.format(self.__filename, get_timestamp())], True)
        self.write_line(self.__file_columns, True)

    def write_line(self, row_elements: list[str], is_header: bool = False) -> None:
        """
        function to write line in file
        :param row_elements: row to write in file
        :param is_header: boolean if is header or not
        """
        self.__csv_file = self.__check_file()
        writer = csv.writer(self.__csv_file, delimiter=self.__seperator)
        if is_header:
            writer.writerow(row_elements)
        else:
            if self.__only_changes:
                if self.__get_lines_of_file() > 2 \
                        and self.__get_last_row_logged() == row_elements[1:len(row_elements)]:
                    return
                else:
                    writer.writerow(row_elements)
            else:
                writer.writerow(row_elements)

            # Ringbuffer
            if self.__max_file_length - 1 < self.__get_lines_of_file() - 2:
                self.__delete_oldest_line()
        self.__csv_file.close()

    def __delete_oldest_line(self) -> None:
        """
        function to delete third line of file
        """
        file_list = self.__return_file_lines()
        with open(self.__filename, 'w', encoding='utf-8') as file:
            for number, line in enumerate(file_list):
                if number not in [2]:
                    file.write(line)

    def __get_lines_of_file(self) -> int:
        """
        :return: amount of lines in files
        """
        with open(self.__filename, "r", encoding='utf-8') as file:
            return len(file.readlines())

    def __return_file_lines(self) -> list:
        """
        :return: list of all rows in file
        """
        with open(self.__filename, 'r', encoding='utf-8') as file:
            return file.readlines()

    def __get_last_row_logged(self) -> list[str]:
        """
        gets last row from file without timestamp
        :return: list of all values from last row
        """
        # Read all the lines into a List
        lst = list(self.__return_file_lines())
        # Get just the last line
        return list(lst[len(lst) - 1].strip().split(self.__seperator, 1, )[1].split(';'))

    def __check_file(self):
        """
        checks if file exists and returns file in write or append mode
        :return: file in write or append mode
        """
        if pathlib.Path(self.__filename).is_file():
            return open(self.__filename, 'a', newline='', encoding='utf-8')
        else:
            return open(self.__filename, 'w', newline='', encoding='utf-8')

    def __file_exists(self) -> None:
        """
        Checks if file exists then asks if append or overwrite
        """
        if not pathlib.Path(self.__filename).is_file():
            self.__create_header()
        else:
            mode = input("Möchtest du das File überschreiben (Yes or No) [*No]:")
            if mode.lower() == 'yes':
                open(self.__filename, 'w').close()
                self.__create_header()

    def get_seperator(self) -> str:
        """
        getter for seperator
        :return: seperator
        """
        return self.__seperator

    def set_seperator(self, new_seperator: str) -> None:
        """
        setter for seperator
        :param new_seperator: new seperator
        """
        if new_seperator != "":
            self.__seperator = new_seperator

    def set_filename(self, new_filename: str) -> None:
        """
        setter for filename
        :param new_filename: new filename
        """
        if new_filename != "":
            self.__filename = new_filename
        self.__file_exists()

    def get_filename(self) -> str:
        """
        getter for filename
        :return: filename
        """
        return self.__filename

    def set_max_file_length(self, new_max_file_length: str) -> None:
        """
        setter for defined maximal file length
        :param new_max_file_length: new maximal file length
        """
        if new_max_file_length != "":
            self.__max_file_length = int(new_max_file_length)

    def get_max_file_length(self) -> int:
        """
        getter for maximal file length
        :return: maximal file length
        """
        return self.__max_file_length

    def set_only_changes(self, new_only_changes: str) -> None:
        """
        setter for only changes bool
        :param new_only_changes: yer or no as string
        """
        if new_only_changes.lower() == "yes":
            self.__only_changes = True
        else:
            self.__only_changes = False

    def get_only_changes(self) -> bool:
        """
        getter for only changes
        :return: only changes as boolean
        """
        return self.__only_changes


serviceURL = "https://api.openweathermap.org/data/2.5/weather"
pollingTime = float(input("Polling-Time [s]:"))
ort = input("Ort  [*Uster]   :")
if ort == "":
    ort = 'Uster'

max_counter = int(input("Anzahl requests :"))

appId = "c6d04c34cdf99be23443f2e4bf9ab2dc"

columns = ["Timestamp", "Level", "Ortsname", "Land", "Temperatur", "Druck", "Feuchtigkeit", "Längengrad",
           "Breitengrad", "Wolken", "Windgeschwindigkeit", "Windrichtung"]

user_filename = input("Bitte ein Pfad und Filename .csv eing eben [*test.csv]:")
if user_filename == "":
    user_filename = 'test.csv'

myLogger = MyLogger(columns, filename=user_filename)

myLogger.set_seperator(input("Wähle ein Delimeter [;]:"))

myLogger.set_only_changes(input("Only changes (Yes or No) [*No]:"))

myLogger.set_max_file_length(input("Wähle   eine maximale Anzahl an Reihen [*10]:"))

firstTime = True
counter = 0
doLoop = True
while doLoop:
    counter += 1
    requestStr = serviceURL + "?q=" + ort + "&units=metric&lang=de&appid=" + appId
    print("Request:\n", requestStr, "\n\n") if firstTime else False
    responseStr = requests.get(requestStr)
    print("Response:\n", responseStr.text, "\n\n") if firstTime else False

    jsonResponse = json.loads(responseStr.text)

    ortsname = jsonResponse['name']
    land = jsonResponse['sys']['country']
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']
    windSpeed = jsonResponse['wind']['speed']
    windDirection = jsonResponse['wind']['deg']

    myLogger.write_line([get_timestamp(), LogLevel.INFO.value, ortsname,
                         land, str(temp), str(pressure), str(humidity),
                         str(lon), str(lat), cloud, str(windSpeed), str(windDirection)])

    time.sleep(pollingTime)
    firstTime = False
    if counter >= max_counter:
        doLoop = False
        print('Gewünschte Zeilen wurden geschrieben.')

# ---------------------------------------------------------
# Review / Beurteilung
# ---------------------------------------------------------
# 1. Lauffähiger Code abgegeben (2 Punkte)                                  2
#    Alles in einem File (ausnahmsweise für diese Aufgabenstellung)
#    Filename: Vorname_Nachname_A19_DS.py (z.B. Rea_Vogel_A19_DS.py)
# 2. CLI Applikation schreibt ein Log-File (2 Punkte)                       2
# 3. Für den Weather REST Service wurde ein eigener Token verwendet         2
# 4. Eine eigene, reusable Klasse mit
#    einfachem Interface implementiert (4 Punkte)                           4
# 5. Nur absolut Notwendiges ist public (2 Punkte)                          2
# 6. Kommentare in Form von doc_strings sind enthalten                      1
# 7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                   1
# 8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)              1
#    Log-Entries enthalten formatierten Time-Stamp und Level                1
# 9. Scrolling Strategie implementiert                                      1
# 10. Anzahl Zeilen für Scrollbereich definierbar                           1
# 11. ChangesOnly implementiert                                             1
# 12. Append / New implementiert                                            1
# 13. Delimiter via __init__ setzbar (mit Default-Wert)                     1
# 14. Strategie via __init__ setzbar (mit Default-Wert)                     1
# 15. Scrolling area via __init__ setzbar (mit Default-Wert)                1
#                                                                       ---------
#                                                                          23
#                                                                       =========