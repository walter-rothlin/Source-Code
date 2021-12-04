# Import Modules
import requests
import json
from datetime import datetime
from os.path import exists
from os import remove

# Logger Klasse
# -----------------------------------------------


class Logger:
    def __init__(self, filename, spalten, delimiter="|", loglevel_aktiv=None, ringbuffer_size=4):
        if loglevel_aktiv is None:
            loglevel_aktiv = ["INFO"]
        self.filename = filename
        self.delimiter = delimiter
        self.loglevel_aktiv = loglevel_aktiv
        self.timeformat = '{:%Y-%m-%d %H:%M:%S}'
        self.messages = []
        self.xml_header = '<file name="' + filename + '" timestamp="' + str(self.get_timestamp()) + '"/>'
        self.rows = ""  # Spalten mit Delimiter benennen
        # todo: kein Delimiter beim letzten Element
        for spalte in spalten:
            self.rows += spalte + delimiter
        # todo: Ringbuffer implementieren
        self.ringbuffer_size = ringbuffer_size

    @property
    def timeformat(self):
        return self.__timeformat

    @timeformat.setter
    def timeformat(self, timeformat):
        self.__timeformat = timeformat

    def get_timestamp(self):
        return self.timeformat.format(datetime.now())

    def __remember(self, message):
        if len(self.messages) >= self.ringbuffer_size:
            self.messages = self.messages[1:]
        self.messages.append(message)

    def save(self):
        f = open(self.filename, "w")
        content = self.xml_header + "\n"
        content += self.rows + "\n"
        for message in self.messages:
            content += message + "\n"
        f.write(content + "\n")
        f.close()

    def log(self, loglevel, message):
        if loglevel in self.loglevel_aktiv:
            time = self.get_timestamp()
            linedata = str(time) + self.delimiter + loglevel + self.delimiter + message
            self.__remember(linedata)

    def log_info(self, message):
        self.log("INFO", message)

    def log_error(self, message):
        self.log("ERROR", message)

    def log_warning(self, message):
        self.log("WARNING", message)

    def log_critical(self, message):
        self.log("CRITICAL", message)

    def log_debug(self, message):
        self.log("DEBUG", message)


# CLI Applikation
# -----------------------------------------------

# API Key
api_key = "ca727b800a4b4d64220729417721a0ba"
URL = "http://api.openweathermap.org/data/2.5/weather"
filename = "Testfile.csv"

# Prüfen ob bereits ein File existiert und ggf. bestehendes File löschen:
if exists(filename):  # "if" dieser Ausdruck == True (exists gibt Boolean zurück)
    remove(filename)


# Log-File überprüfen
def print_logfile(filename):
    print("Neu generiertes Log-File:")
    f = open(filename, "r")
    print(f.read())
    f.close()


# Objekt generieren und Spalten benennen, Delimiter und Loglevel wählen
logger = Logger(filename, ["Timestamp", "Location", "Weather", "Temperature", "Country"], delimiter=";",
                loglevel_aktiv=["INFO", "ERROR"])

# Menü
print("========== Wetterstation ==========\n")
print("1: Wetter ")
print("2: Programm beenden")
aktion = 0

# Programmauswahl
while aktion != 2:  # todo: Sicherstellen das Programm nicht abstürzt, wenn bei Aktion wählen str eingegeben wird.
    aktion = int(input("Aktion wählen: "))

    if aktion == 1:
        location = input("Location: ")
        response = requests.get(URL + "?q=" + location + "&units=metric&lang=de&appid=" + api_key)
        # str in JSON umformatieren (dict)
        input_json = json.loads(response.text)
        print("Erhaltener Status-Code: ", response.status_code)  # zur Überprüfung
        print("Data =", json.dumps(input_json, indent=4))  # zeigt mir zur Überprüfung die Daten aus der Abfrage

        # Exception Handling (ERROR 404)
        if response.status_code == 404:
            logger.log_error(input_json["message"])  # übergibt direkt die Message an log_error

        else:  # einzelne Daten für Spaltenüberschriften holen
            description = input_json["weather"][0]["description"]
            temperature = str(input_json["main"]["temp"])
            country = input_json["sys"]["country"]
            entry = location + logger.delimiter + description + logger.delimiter + temperature + logger.delimiter +\
                country
            logger.log_info(entry)

        logger.save()
        print_logfile(filename)

    elif aktion == 2:
        print("Programm beendet.")

    else:
        print("Ungültige Auwahl.")
