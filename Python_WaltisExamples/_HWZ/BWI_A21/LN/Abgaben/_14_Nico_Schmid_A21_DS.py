# ------------------------------------------------------------------
# Name  : Nico_Schmid_A21_DS.py
#
# Description: Polling REST Service and log results using the Logger class
# https://openweathermap.org/current
#
# Author: Walter Rothlin, Nico Schmid
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version ()
# 10-Oct-2021   Walter Rothlin      Adapted for BWI-A20
# 28-Nov-2021   Walter Rothlin      Changed URL-encoding und request URL Parameter Uebergabe
# 25-Oct-2022   Walter Rothlin      Abbruch der Polling-Schleife
# 21-Nov-2022   Nico Schmid         Hinzufügen der Logger-Klasse
# ------------------------------------------------------------------
import datetime
import requests
import json
import time

#############################
# Logger
#############################
import os.path
from enum import Enum


class Logger:
    """
        Logger class to log information in a structured manner into a csv file

        ...

        Attributes
        ----------
        delimiter : str
            delimiter to separate the columns within the files
        file_path : str
            path to the folder where the file is stored
        file_name : str
            name ot the file
        scroll_count : int
            max amount of lines the log file should contain
        log_strategy : str
            'FIXED_SLICES': Log all entries
            'ONLY_CHANGES': Log only new entries
        attach : bool
            whether the new content should overwrite the old content or attach to file
        header_titles : list[str]
            headers of the content to be logged
        time_format : str
            format of the timestamps


        Methods
        -------
        write_log(log_level, strategy, content):
            Writes a new log-entry into the logfile
        """

    class Mode(Enum):
        """
        Enum for the Debug Mode
        """
        DEBUG = 1
        """
        This is the DEBUG selection. Use this for DEBUG
        """
        INFO = 2
        """
        This is the INFO selection. Use this for INFO
        """
        WARNINGS = 3
        """
        This is the WARNINGS selection. Use this for WARNINGS
        """
        ERROR = 4
        """
        This is the ERROR selection. Use this for ERROR
        """
        CRITICAL = 5
        """
        This is the CRITICAL selection. Use this for CRITICAL
        """

    class Strategy(Enum):
        """
        Enum for the Debug Mode
        """
        FIXED_SLICES = 1
        """
        This is the FIXED_SLICES selection. Use this to log all entries
        """
        ONLY_CHANGES = 2
        """
        This is the ONLY_CHANGES selection. Use this to log only new entries
        """

    def __init__(self, delimiter: str = "|", file_path: str = './', file_name: str = "log_file.csv",
                 scroll_count: int = 20,
                 log_strategy: Strategy = 'FIXED_SLICES',
                 attach: bool = True, header_titles: list[str] = None, time_format: str = '%Y-%m-%d %H:%M:%S'):
        """
                Constructs all the necessary attributes for the log object.

                Parameters
                ----------
                    delimiter : str
                        delimiter to separate the columns within the files
                    file_path : str
                        path to the folder where the file is stored
                    file_name : str
                        name ot the file
                    scroll_count : int
                        max amount of lines the log file should contain
                    log_strategy : Enum
                        FIXED_SLICES: Log all entries
                        ONLY_CHANGES: Log only new entries
                    attach : bool
                        whether the new content should overwrite the old content or attach to file
                    header_titles : list[str]
                        headers of the content to be logged
                    time_format : str
                        format of the timestamps
                """
        self.__delimiter = delimiter
        self.__file_path = file_path
        self.__file_name = file_name
        self.__scroll_count = scroll_count
        self.__log_strategy = log_strategy
        self.__attach = attach
        self.__header_titles = header_titles
        self.__time_format = time_format
        self.__open_file()

    def get_delimiter(self):
        return self.__delimiter

    def set_delimiter(self, delimiter):
        """
        Set the new value for delimiter
        """
        self.__delimiter = delimiter

    def get_file_path(self):
        return self.__file_path

    def set_file_path(self, file_path):
        """
        Set the new value for file_path
        """
        self.__file_path = file_path

    def get_file_name(self):
        return self.__file_name

    def set_file_name(self, file_name):
        """
        Set the new value for file_name
        """
        self.__file_name = file_name

    def get_scroll_count(self):
        return self.__scroll_count

    def set_scroll_count(self, scroll_count):
        """
        Set the new value for scroll_count
        """
        self.__scroll_count = scroll_count

    def get_log_strategy(self):
        return self.__log_strategy

    def set_log_strategy(self, log_strategy):
        """
        Set the new value for log_strategy
        """
        self.__log_strategy = log_strategy

    def get_attach(self):
        return self.__attach

    def set_attach(self, attach):
        """
        Set the new value for attach
        """
        self.__attach = attach

    def get_time_format(self):
        return self.__time_format

    def set_time_format(self, time_format):
        """
        Set the new value for time_format
        """
        self.__time_format = time_format

    # Properties
    delimiter = property(get_delimiter, set_delimiter)
    file_path = property(get_file_path, set_file_path)
    file_name = property(get_file_name, set_file_name)
    scroll_count = property(get_scroll_count, set_scroll_count)
    log_strategy = property(get_log_strategy, set_log_strategy)
    attach = property(get_attach, set_attach)
    time_format = property(get_time_format, set_time_format)

    def __open_file(self):
        """
        Opens the log-file
        """
        if self.__header_titles is None:
            self.__header_titles = []

        self.__path = os.path.join(self.__file_path, self.__file_name)
        if self.__attach is False:
            self.__write_header()

        else:
            try:
                with open(self.__path, "r") as file:
                    self.__write_header() if len(file.readlines()) <= 1 else self.__scroll()
            except FileNotFoundError:
                self.__write_header()

    def __write_header(self):
        """
        Writes the header into the log-file
        """
        file = open(self.__path, "w")
        now = datetime.datetime.now()
        current_date = now.strftime("%Y-%m-%d %H:%M:%S")
        file.write("#<Name>" + self.__file_name + "</Name> <Date>" + current_date + "</Date>" + "\n")

        col_string = ""
        for header in self.__header_titles:
            col_string = col_string + header + self.__delimiter
        file.write("Timestamp" + self.__delimiter + "Level" + self.__delimiter + col_string + "\n")
        file.close()

    def __scroll(self):
        """
        Scrolls through the log-file
        """
        lines = self.__get_all_lines()
        with open(self.__path, "w") as file:
            if len(lines) > self.__scroll_count:
                end = len(lines) - self.__scroll_count + 2
                header = lines[:2]
                content = lines[end:len(lines)]
                lines = header + content
            for line in lines:
                file.write(line)

    def __get_all_lines(self):
        """
        Return all lines from the log-file

            Returns:
                    lines (array): Array with all lines of the log-file
        """
        with open(self.__path, "r") as file:
            lines = file.readlines()
        return lines

    def __check_changes(self, content: str):
        """
        Checks whether the new content is the same as the old

            Parameters:
                    content (str): content to be logged

            Returns:
                    check_changes (bool): Bool whether the new content is equal to the old (False) or not (True)
        """
        lines = self.__get_all_lines()
        last_line_content = lines[-1].split(self.__delimiter)[2:]
        new_line_content = content.split(self.__delimiter)[2:]
        return new_line_content != last_line_content

    def write_log(self, log_level: Mode, content: str):
        """
        Writes a new log-entry into the logfile

        Parameters
        ----------
        log_level : Enum
            'DEBUG'
            'INFO'
            'WARNINGS'
            'ERROR'
            'CRITICAL'
        content : str
            Content that needs to be logged

        Returns
        -------
        None
        """
        now = datetime.datetime.now()
        timestamp = now.strftime(self.__time_format)

        write_string = timestamp + self.__delimiter + log_level.name + self.__delimiter + content + "\n"

        if (self.__log_strategy.value == 2 and self.__check_changes(write_string)) or self.__log_strategy.value == 1:
            file = open(self.__path, "a")
            file.write(write_string)
            file.close()

            # Scroll
            self.__scroll()


########## End Logger ##########


def get_timestamp():
    return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())


serviceURL = "https://api.openweathermap.org/data/2.5/weather"
pollingTime = float(input("Polling-Time [s]:"))
ort = input("Ort  [*Uster]   :")
if ort == "":
    ort = 'Uster'

max_counter = int(input("Anzahl requests :"))

appId = "ba036f34713e8eb86ae2914d3028a834"

# Initiate Logger
Strategy = Logger.Strategy
Mode = Logger.Mode

# Initiate Logger
input_attach = input("Attach[True | False]: ")
if input_attach == "True":
    input_attach = True
elif input_attach == "False":
    input_attach = False

input_delimiter = input("Delimiter")
input_scroll_count = int(input("Scroll-Bereich[int]"))
input_strategy = Strategy[input("Strategie[FIXED_SLICES | ONLY_CHANGES]")]
input_log_mode = Mode[input("Log-Level[Debug | "
                            "INFO | "
                            "WARNINGS | "
                            "ERROR | "
                            "CRITICAL]")]

separator = input_delimiter

# So würde ein ein normaler Logger aufruf aussehen.
# Wird in dieser Klasse nicht verwendet, da die Daten aus der CLI kommen. Dient rein zur Demonstration
# logger_normal = Logger(attach=False, file_path='./', file_name='log_file.csv', delimiter=separator,
#                header_titles=["Ort", "Temp",
#                               "pressure", "humidity", "cloud", "Wind",
#                               "windDirection"], scroll_count=20,
#                log_strategy=Strategy.FIXED_SLICES)

# Instanzieren der Logger-Klasse mittels CLI-Eingaben
logger_cli = Logger(attach=input_attach, file_path='./', file_name='log_file.csv', delimiter=separator,
                    header_titles=["Ort", "Temp",
                                   "pressure", "humidity", "cloud", "Wind",
                                   "windDirection"], scroll_count=input_scroll_count,
                    log_strategy=input_strategy)

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

    print(get_timestamp(), ": ", ortsname, "[", land, "]", "(", lon, "/", lat, ")      ", temp, "°C ", pressure,
          "mBar ",
          humidity, "% ", cloud, "  Wind:", windSpeed, "m/s ", windDirection, "° ", sep='')

    # Log
    log_content = ortsname + "[" + land + "](" + str(lon) + "/" + str(lat) + ")" + separator + str(
        temp) + "°C " + separator + str(pressure) + "mBar " + separator + str(
        humidity) + "% " + separator + cloud + separator + "Wind:" + str(windSpeed) + "m/s " + separator + str(
        windDirection) + "°"

    # Normaler Log-Eintrag, Rein zu Demonstrationszwecken
    # logger_normal.write_log(Mode.WARNINGS, log_content)

    # Log-Eintrag mittels CLI-Eingaben
    logger_cli.write_log(input_log_mode, log_content)

    time.sleep(pollingTime)
    firstTime = False
    if counter >= max_counter:
        doLoop = False

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