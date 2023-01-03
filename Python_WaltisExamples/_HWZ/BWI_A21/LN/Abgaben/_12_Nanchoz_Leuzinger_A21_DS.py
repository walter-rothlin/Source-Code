import datetime
import requests
import json
import time
import logging


#Logger-Klasse mit INFO-Level

class MyLoggerClass:
    '''Erstellung der Klasse '''
    '''Filename, Speicherort und der delimiter wird festgelegt'''
    def __init__(self, delimiter="|", filename="WeatherLogger.csv", filepath=r"WeatherLogger.csv"):   # C:\Users\Nanchoz Leuzinger\PycharmProjects\WeatherProjekt\WeatherLogger.csv
        self.__filename = filename
        self.__filepath = filepath
        self.__delimiter = delimiter
        '''private'''
        ''' Implementierung Logger'''                                                                                                                                       # https://docs.python.org/3/howto/logging.html
        self.__logger = logging.getLogger()                                                                                                                                 # https://stackoverflow.com/questions/14058453/making-python-loggers-output-all-messages-to-stdout-in-addition-to-log-file

    def MyLogger(self):
        '''Level wird auf Info gesetzt (NOTSET, DEBUG, INFO, WARNING, ERROR, CRITICAL'''                                                                                    # https://towardsdatascience.com/how-to-do-logging-in-python-37fee87b718c
        self.__logger.setLevel(logging.INFO)

        ''' Umwandlung Datum zu String'''
        timec = str(datetime.datetime.now().replace(second=0, microsecond=0))                                                                                               # https://stackoverflow.com/questions/3183707/stripping-off-the-seconds-in-datetime-python

        '''Generierung File mit Header gem. Beispiel'''
        with open(self.__filepath, 'w') as log:
            log.write(r'<Name>G:\\' + self.__filename + '/Name> <Date>' + timec + '</Date>\n')                                                                              # https://www.programiz.com/python-programming/file-operation
            log.write('Timestamp' + self.__delimiter + 'Level' + 'Msg\n')

        ''' Der handler schreibt effektiv das Protokoll'''
        handler = logging.FileHandler('WeatherLogger.csv', mode='a')

        ''' Ausgabe aus dem Logger (Würde noch jede Menge andere Möglichkeiten geben gem. python Webseite)'''                                                                  # https://docs.python.org/3/library/logging.config.html#import-resolution-and-custom-importers
        formtext = '%(asctime)s' + str(self.__delimiter) + '%(levelname)s' + str(self.__delimiter) + '%(message)s'
        print(formtext)

        '''Der formatter überbringt die Nachrichten zu den Kontextinformationen '''
        formatter = logging.Formatter(formtext,
                                      "%Y-%m-%d %H:%M:%S")
        handler.setFormatter(formatter)
        self.__logger.addHandler(handler)

        '''Die INFO Nachricht wird mit der INFO()-Methode protokolliert'''
    def Aufruf_logger(self, logEintrag):
        self.__logger.info(logEintrag)



def getTimestamp():
    return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())

serviceURL = "https://api.openweathermap.org/data/2.5/weather"
pollingTime = float(input("Polling-Time [s]:"))
ort = input("Ort  [*Stockholm]   :")
if ort == "":
    ort = 'Stockholm'

max_counter = int(input("Anzahl requests :"))

appId = "b950a732b1f8777a5e64c7ce41728ba9"

'''Aufruf der Klasse'''
weatherlog = MyLoggerClass('|')
weatherlog.MyLogger()

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


    weatherlog.Aufruf_logger(jsonResponse)


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

    print(getTimestamp(), ": ", ortsname, "[", land, "]", "(", lon, "/", lat, ")      ", temp, "°C ", pressure, "mBar ", humidity, "% ", cloud, "  Wind:", windSpeed, "m/s ", windDirection, "° ", sep='')
    time.sleep(pollingTime)
    firstTime = False
    if counter >= max_counter:
        doLoop = False

'''
Youtube:
https://www.youtube.com/watch?v=gsa1oFn9n0M&t=1100s
https://www.youtube.com/watch?v=0YUdYk5E-w4
https://www.youtube.com/watch?v=NqlWBfFO92g&t=1s
https://www.youtube.com/watch?v=p0A4CV4MWd0&t=420s
https://www.youtube.com/watch?v=rcfmITJ2E7c&t=3100s
https://www.youtube.com/watch?v=aCk-qE_WQJ4&t=85s
'''


# ---------------------------------------------------------
# Review / Beurteilung
# ---------------------------------------------------------
# 1. Lauffähiger Code abgegeben (2 Punkte)                                  2
#    Alles in einem File (ausnahmsweise für diese Aufgabenstellung)
#    Filename: Vorname_Nachname_A19_DS.py (z.B. Rea_Vogel_A19_DS.py)
# 2. CLI Applikation schreibt ein Log-File (2 Punkte)                       2
# 3. Für den Weather REST Service wurde ein eigener Token verwendet         2
# 4. Eine eigene, reusable Klasse mit
#    einfachem Interface implementiert (4 Punkte)                           2 (Essenz nicht in Klasse gelöst)
# 5. Nur absolut Notwendiges ist public (2 Punkte)                          2
# 6. Kommentare in Form von doc_strings sind enthalten                      1
# 7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                   0 (Keine korrektes XML)
# 8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)              1
#    Log-Entries enthalten formatierten Time-Stamp und Level                1
# 9. Scrolling Strategie implementiert                                      0
# 10. Anzahl Zeilen für Scrollbereich definierbar                           0
# 11. ChangesOnly implementiert                                             0
# 12. Append / New implementiert                                            0
# 13. Delimiter via __init__ setzbar (mit Default-Wert)                     0
# 14. Strategie via __init__ setzbar (mit Default-Wert)                     0
# 15. Scrolling area via __init__ setzbar (mit Default-Wert)                0
#                                                                       ---------
#                                                                          13
#                                                                       =========




