# ------------------------------------------------------------------
# Name  : WeatherLogger.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_01.py
#
# Description: Polling REST Service and write values to console
# https://openweathermap.org/current
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version ()
# 10-Oct-2021   Walter Rothlin      Adapted for BWI-A20
# 28-Nov-2021   Walter Rothlin      Changed URL-encoding und request URL Parameter Uebergabe
# 25-Oct-2022   Walter Rothlin      Abbruch der Polling-Schleife
# ------------------------------------------------------------------

import json
import time
import requests

'''Für Klasse nötige Importe'''
import datetime
import logging
import os

'''Reusable Logger-Klasse'''
class LogGenerator:
    '''API Beschreibung'''
    # A Logger-Class written by Jan Derrer

    # 1) newFile : (Boolean) : True = Neues Log-File generieren, False = Bestehendes Log-File benutzen : Default = True
    # 2) fileDirectory : (raw str) : Ordner in welchem Log-File gespeichert ist/wird : Default = Projektordner
    # 3) fileName : (str) : Name mit Dateityp des Log-Files : Default = __name__ + _Log.csv
    # 4) timeStampFormat : (str) : Formatierung aller Datum und Uhrzeiten im Log-File : Default = %Y-%m-%d %H:%M:%S
    # 5) maxLengthLog : (int) : Maximale Anzahl Log-Zeilen (exkl. Header-Zeilen), welche im File enthalten sind. : Default = 15
    # 6) changesOnly : (Boolean) : True = Message wird nur geloggt, wenn sie von der vorherig geloggten Message abweicht., False = Message wird in jedem Fall geloggt : Default = False
    # 7) msgLogLevel : (int) : 1 = DEBUG, 2 = INFO, 3 = WARNING, 4 = ERROR, 5 = CRITICAL : Default = 2

    '''Initializer'''
    def __init__(self,newFile=True,fileDirectory ='',fileName = str(__name__+'_Log.csv'),timeStampFormat='%Y-%m-%d %H:%M:%S',maxLengthLog=15,changesOnly=False,delimiter ='|',msgLogLevel=2):

        '''File-Paramenter setzen'''
        self.__newFile = newFile
        self.__fileDirectory = fileDirectory
        if self.__fileDirectory == '':
            self.__fileDirectory = os.path.abspath(os.curdir)                       # Nimmt Projektordner als Default-Path
        else:
            pass
        self.__fileName = fileName
        self.__filePath = self.__fileDirectory + "\\" + self.__fileName
        self.__maxLengthLog = maxLengthLog
        self.__changesOnly = changesOnly

        '''Log-Paramenter setzen'''
        self.__delimiter = delimiter
        self.__msgLogLevel = msgLogLevel                                            # Codes: 1 = DEBUG, 2 = INFO, 3 = WARNING, 4 = ERROR, 5 = CRITICAL

        '''Logger einrichten'''
        self.__logger = logging.getLogger(__name__)
        self.__logger.setLevel(logging.DEBUG)

        self.__formatterText = '%(asctime)s' + str(self.__delimiter) + '%(levelname)s' + str(self.__delimiter) + '%(message)s'
        self.__timeStampFormat = timeStampFormat
        self.__fileFormatter = logging.Formatter(self.__formatterText, self.__timeStampFormat)

        '''DateTime generieren und formatieren'''
        dateTimeFormat = '{timestamp:'+str(timeStampFormat)+'}'
        self.__timeStampNow = dateTimeFormat.format(timestamp=datetime.datetime.now())

        '''New File oder append: Definierung Speicherort, File-Formatierung, Header '''
        if os.path.isfile(self.__filePath) == True:                                 # Check ob File bereits besteht.
            if self.__newFile == True:
                self.__filePath = self.__fileDirectory + '\\New_' + self.__fileName # Falls "New File" gewünscht aber File bereits besteht, wird ein neues File generiert.
                while os.path.isfile(self.__filePath) == True:
                    newCounter = 1
                    self.__filePath = self.__fileDirectory + '\\New_' + str(newCounter) +'_'+ self.__fileName
                    newCounter +=1

                '''Speicherort und Filename definieren'''
                self.__fileHandler = logging.FileHandler(self.__filePath, 'a')

                '''Header generieren'''
                with open(self.__filePath, 'w') as csv_file:
                    csv_file.write(r'<Name>G:\\' + self.__fileName + '/Name> <Date>' + self.__timeStampNow + '</Date>\n')
                    csv_file.write('Timestamp' + self.__delimiter + 'Level' + 'Message\n')
            elif self.__newFile == False:
                with open(self.__filePath, 'r+') as csv_file:                       # Falls "append" gewünscht und File bereits besteht, wird gecheckt ob Header vorhanden
                    fileHeader = csv_file.readline()
                    if fileHeader == "":                                            # Falls erste Zeile leer ist, wird ein Header generiert
                        csv_file.write(r'<Name>G:\\' + self.__fileName + '/Name> <Date>' + self.__timeStampNow + '</Date>\n')
                        csv_file.write('Timestamp' + self.__delimiter + 'Level' + 'Message\n')
                    else:
                        pass

                '''Speicherort und Filename definieren'''
                self.__fileHandler = logging.FileHandler(self.__filePath, 'a')
        else:
            if self.__newFile == True:                                              # Falls "New File" gewünscht und File existiert auch nicht

                '''Speicherort und Filename definieren'''
                self.__fileHandler = logging.FileHandler(self.__filePath, 'a')

                '''Header generieren'''
                with open(self.__filePath, 'w') as csv_file:
                    csv_file.write(r'<Name>G:\\' + self.__fileName + '/Name> <Date>' + self.__timeStampNow + '</Date>\n')
                    csv_file.write('Timestamp' + self.__delimiter + 'Level' + self.__delimiter + 'Message\n')
            else:
                generateNewFile = input('File existiert nicht. Neues File generieren? [*Ja/Nein]:')   # Falls "append" gewünscht aber File existiert nicht, wird gefragt, ob ein neues File generiert werden soll. Defaultantwort "Ja".
                if generateNewFile == '':
                    appendToNewFile = True
                elif generateNewFile == 'Nein':
                    appendToNewFile = False
                else:
                    appendToNewFile = True
                if appendToNewFile == True:

                    '''Speicherort und Filename definieren'''
                    self.__fileHandler = logging.FileHandler(self.__filePath, 'a')

                    '''Header generieren'''
                    with open(self.__filePath, 'w') as csv_file:
                        csv_file.write(r'<Name>G:\\' + self.__fileName + '/Name> <Date>' + self.__timeStampNow + '</Date>\n')
                        csv_file.write('Timestamp' + self.__delimiter + 'Level' + 'Message\n')
                else:
                    raise Exception('File existiert nicht!')                        # Falls kein neues File generiert werden soll, wird eine Exception erhoben.

        '''Formatter an Handler übergeben und Handler in Logger übergeben'''
        self.__fileHandler.setFormatter(self.__fileFormatter)
        self.__logger.addHandler(self.__fileHandler)

    '''Delimitter setzen'''
    def setDelimiter(self,delimiter):                                               # Gilt nur für die Delimiter im Log-Eintrag, nicht für die Delimiter im Header, diese bleiben gem. Klassenaufruf
        self.__delimiter = delimiter
        self.__formatterText = '%(asctime)s' + str(self.__delimiter) + '%(levelname)s' + str(self.__delimiter) + '%(message)s'
        self.__fileFormatter = logging.Formatter(self.__formatterText, self.__timeStampFormat)
        self.__fileHandler.setFormatter(self.__fileFormatter)
        self.__logger.addHandler(self.__fileHandler)

    '''Anzahl Logeinträge setzen'''
    def setMaxLengthLog(self,maxLengthLog):
        self.__maxLengthLog = maxLengthLog

    '''Logstrategie setzen'''
    def setOnlyChanges(self,changesOnly):
        self.__changesOnly = changesOnly

    '''Logeintrag generieren'''
    def generateLog (self,logMsg):
        lineCounter = -1
        with open(self.__filePath,'r') as logFile:                                  # Anzahl Zeilen im File ermitteln
            listlogLines = logFile.readlines()
            for line in listlogLines:
                lineCounter += 1

        '''Scrolling Area'''
        while lineCounter > self.__maxLengthLog:
            del listlogLines[2]
            lineCounter -=1
        with open(self.__filePath,'w') as logFile:
            for line in listlogLines:
                logFile.write(line)

        '''ChangesOny - FUNKTIONIERT NICHT'''
        if self.__changesOnly == True:
            with open(self.__filePath, 'r') as file:
                fileContents = file.readlines()
                contentLastLine = fileContents[-1]
                listContentLastLine = contentLastLine.split(self.__delimiter)
                lastLogMsg = str(listContentLastLine[-1])
            if lastLogMsg == logMsg:                                               # Check ob letzser Log-Eintrag gleich ist wie der neue. Fehler: Obwohl sie identisch sind, werden sie immer als != gewertet.
                canBeLogged = False
            else:
                canBeLogged = True
        else:
            canBeLogged = True

        '''Loglevel wird definiert und Logeintrag wird generiert'''
        if canBeLogged == True:
            if self.__msgLogLevel == 1:
               self.__logger.debug(logMsg)
            elif self.__msgLogLevel == 2:
                self.__logger.info(logMsg)
            elif self.__msgLogLevel == 3:
                self.__logger.warning(logMsg)
            elif self.__msgLogLevel == 4:
                self.__logger.error(logMsg)
            elif self.__msgLogLevel == 5:
                self.__logger.critical(logMsg)
            else:
                self.__logger.info(logMsg)
        else:
            pass

'''CLI Applikation'''
def getTimestamp():
    return '{ts:%Y-%m-%d %H:%M:%S}'.format(ts=datetime.datetime.now())

serviceURL = "https://api.openweathermap.org/data/2.5/weather"
pollingTime = float(input("Polling-Time [s]:"))
ort = input("Ort  [*Glarus]   :")
if ort == "":
    ort = 'Glarus'

max_counter = int(input("Anzahl requests :"))

appId = "4507d2e28110537f9985155381a91020"

'''Aufruf Klasse'''
weatherLog = LogGenerator(newFile=False, fileName='01_WeatherLog.csv', maxLengthLog=15, delimiter='|.|', timeStampFormat='%Y-%m-%d %H:%M:%S')

'''optional: Aufruf Setter'''
#weatherLog.setDelimiter('| : |')
#LogGenerator.setMaxLengthLog(weatherLog,10)

firstTime = True
counter = 0
doLoop = True
while doLoop:
    counter += 1
    requestStr = serviceURL + "?q=" + ort + "&units=metric&lang=de&appid=" + appId
    print("Request:\n", requestStr, "\n\n") if firstTime else False
    responseStr = requests.get(requestStr)

    jsonResponse = json.loads(responseStr.text)

    '''Aufruf ein Log-Eintrag zu generieren'''
    weatherLog.generateLog(jsonResponse)                                                # Die zu loggende Message ist zu übergeben.

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

# ---------------------------------------------------------
# Review / Beurteilung
# ---------------------------------------------------------
# 1. Lauffähiger Code abgegeben (2 Punkte)                                  1  (filename)
#    Alles in einem File (ausnahmsweise für diese Aufgabenstellung)
#    Filename: Vorname_Nachname_A19_DS.py (z.B. Rea_Vogel_A19_DS.py)
# 2. CLI Applikation schreibt ein Log-File (2 Punkte)                       2
# 3. Für den Weather REST Service wurde ein eigener Token verwendet         2
# 4. Eine eigene, reusable Klasse mit
#    einfachem Interface implementiert (4 Punkte)                           4
# 5. Nur absolut Notwendiges ist public (2 Punkte)                          2
# 6. Kommentare in Form von doc_strings sind enthalten                      0 nur einzeilige doc-strings und der Rest als #
# 7. Log-File enthält eine Kommentar-Zeile mit XML-Syntax                   0 nicht korrekte XML Syntax
# 8. Log-File enthält eine Headerzeile (Spalten-Bezeichnungen)              0 nur timestamp und loglevel
#    Log-Entries enthalten formatierten Time-Stamp und Level                1
# 9. Scrolling Strategie implementiert                                      1
# 10. Anzahl Zeilen für Scrollbereich definierbar                           0 nicht testbar
# 11. ChangesOnly implementiert                                             0 nicht testbar
# 12. Append / New implementiert                                            0 nicht testbar
# 13. Delimiter via __init__ setzbar (mit Default-Wert)                     1
# 14. Strategie via __init__ setzbar (mit Default-Wert)                     1
# 15. Scrolling area via __init__ setzbar (mit Default-Wert)                1
#                                                                       ---------
#                                                                          16
#                                                                       =========