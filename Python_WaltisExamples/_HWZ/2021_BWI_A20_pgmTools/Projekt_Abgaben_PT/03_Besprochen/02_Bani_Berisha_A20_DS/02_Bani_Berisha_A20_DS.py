# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und User Input ist möglich
#      - keine Startime im Header
#      - Header wird bei Append (restart mit gleichem filename) nochmals appended
#      - Unsinnige User-Eingaben können zum Absturz führen
#      - Kein Output / Lebenszeichen im Onlychanges Mode
#      - Runden nicht implementiert
#
# Class Design und Implementation:
#      + Eigene Klasse ohne reuse
#      - Notwendige (__eq__ __str__ ) Methoden nicht vorhanden
#      + __init__ wichtige parameter haben Default-Werte
#      - Alle Instance Variablen sind public
#      ++ OnlyChanges funktioniert (ohne Toleranz)
#      - Immer Ringbuffer eingeschaltet
#      - Einigen Methoden könnten private oder private static sein (bessere encapsulation)
#      - Kein Exceptionhandling in der Klasse oder in der Applikation
#      - Header str innerhalb der __init__ erstellen anhand der headerListe
#
# Test:
#      - Keine Test implementiert
#
# Note: 4.5
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wo wird unterschieden zwischen changesOnly True/False?
# ------------------------------------------------------------------

# Bani Berisha - Logger RestAPI Class & Application
# 02-12-2021 - Abgabe Version

import datetime, json, time, pathlib, logging, requests

#User Individual Information
serviceURL = "https://api.openweathermap.org/data/2.5/weather?q=Bern&units=metric&lang=de&appid="
appId = "8151ae9c2b52f12779adf0c0b810c694"
delimiter = "|"

#User Inputs
filename = input("Filename (.csv): ")
pollingTime = float(input("Polling-Time [s]:"))

onlyChanges = input("Onlychanges: [y|n]")
if onlyChanges == "y" or not onlyChanges:
    onlyChanges = True
else:
    onlyChanges = False

ringBuffer = int(input("Ringbuffer:"))

loggerLevel = logging.getLogger(__name__)
logLevel = input("Log-Level?:")
if "DEBUG":
    loggerLevel.setLevel(logging.DEBUG)
elif "INFO":
    loggerLevel.setLevel(logging.INFO)
elif "WARNING":
    loggerLevel.setLevel(logging.WARNING)
elif "ERROR":
    loggerLevel.setLevel(logging.ERROR)
else:
    loggerLevel.setLevel(logging.CRITICAL)

def oldLine(filename):
    lines = None
    with open(filename, 'r') as fp:
        lines = fp.readlines()
    with open(filename, 'w') as fp:
        for number, line in enumerate(lines):
            if number not in [2]:
                fp.write(line)
#Length function
def getLines(filename):
    file = open(filename, "r")
    length = len(file.readlines())
    file.close()
    return length
#File exists or not
def checkFile():
    if pathlib.Path(filename).is_file():
        return open(filename, 'a', newline='')
    else:
        return open(filename, 'w', newline='')

class Logger:
    def __init__(self,
                 filename: str,
                 onlyChanges=False,
                 delimiter='|',
                 headerColumns="",
                 ringBuffer=100):
        self.csv_file = checkFile()
        self.ringBuffer = ringBuffer
        self.onlyChanges = onlyChanges
        self.lastRowLogged = ""

        Xml_Format = "# <Name>{}</Name>"
        Column_Header_Format = "Timestamp" + delimiter + "Level" + delimiter + Column_Headers
        self.writeLine(Xml_Format.format(filename), isHeader=True)
        self.writeLine(Column_Header_Format.format(headerColumns), isHeader=True)

    def writeLine(self, row, isHeader=False):
        self.csv_file = checkFile()
        if isHeader:
            self.csv_file.write(row + "\n")
        else:
            rowLogged = False
            rowToLog = row.split("|", 2)[2]
            if self.lastRowLogged == rowToLog:
                rowLogged = True
            self.lastRowLogged = rowToLog
            if rowLogged:
                if self.onlyChanges:
                    return
                else:
                    print(row)
                    self.csv_file.write(row + "\n")
            else:
                print(row)
                self.csv_file.write(row + "\n")

            # RingBuffer
            if self.ringBuffer < getLines(filename) - 2:
                oldLine(filename)
        self.csv_file.close()

Columns = ["temp", "pressure", "humidity", "lon", "lat", "cloud"]
Column_Headers = ""
for column in Columns:
    Column_Headers += column + delimiter

logger = Logger(filename,
                onlyChanges=onlyChanges,
                headerColumns=Column_Headers,
                delimiter=delimiter,
                ringBuffer=ringBuffer)
#Applikation
while True:
    responseStr = requests.get(serviceURL + appId)
    jsonResponse = json.loads(responseStr.text)
    temp = jsonResponse['main']['temp']
    pressure = jsonResponse['main']['pressure']
    humidity = jsonResponse['main']['humidity']
    lon = jsonResponse['coord']['lon']
    lat = jsonResponse['coord']['lat']
    cloud = jsonResponse['weather'][0]['description']

    log_Format = "{}" + delimiter + "{}"
    logger.writeLine(
        log_Format.format(datetime.datetime.now(), logLevel) + delimiter +
        str(temp) + delimiter + str(pressure) + delimiter + str(humidity) +
        delimiter + str(lon) + delimiter + str(lat) + delimiter + str(cloud))
    time.sleep(pollingTime)