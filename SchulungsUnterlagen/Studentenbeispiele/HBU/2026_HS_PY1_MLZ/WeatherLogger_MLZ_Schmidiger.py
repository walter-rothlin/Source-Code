#!/usr/bin/python
#
# WeatherLogger_MLZ_Schmidiger.py
#  
# 
# 29.06.2026 / pi
#

# Beginn des Programmes

import requests
import json
import time
import datetime

def getTimestamp(format="%Y-%m-%d %H:%M:%S"):
    return f'{datetime.datetime.now():{format}}'

class Logger:
    def __init__(self,
                 fileName='weatherLog.txt',
                 filePath='.',
                 delimiter='|',
                 maxEntries=20,
                 logStrategy='FixedSlices',
                 append=False,
                 timestampFormat='%Y-%m-%d %H:%M:%S',
                 titleLine='Data'):

        self.__fileName = fileName
        self.__filePath = filePath
        self.__delimiter = delimiter
        self.__maxEntries = maxEntries
        self.__logStrategy = logStrategy
        self.__timestampFormat = timestampFormat
        self.__lastLogData = ''
        self.__titleLine = titleLine

        self.__fullFileName = filePath + '/' + fileName
        if append == False:
            self.__writeHeader()

    @property
    def delimiter(self):
        return self.__delimiter
    
    @delimiter.setter
    def delimiter(self, value):
        self.__delimiter = value

    @property
    def FileName(self):
        return self.__fileName

    @FileName.setter
    def fileName(self, value):
        self.__fileName = value
        self.__fullFileName = self.__filePath + '/' + self.__fileName

    @property
    def FilePath(self):
        return self.__filePath

    @FilePath.setter
    def filePath(self, value):
        self.__filePath = value
        self.__fullFileName = self.__filePath + '/' + self.__fileName

    @property
    def MaxEntries(self):
        return self.__maxEntries

    @MaxEntries.setter
    def maxEntries(self, value):
        self.__maxEntries = value

    @property
    def LogStrategy(self):
        return self.__logStrategy

    @LogStrategy.setter
    def logStrategy(self, value):
        self.__logStrategy = value

    @property
    def TimestampFormat(self):
        return self.__timestampFormat

    @TimestampFormat.setter
    def timestampFormat(self, value):
        self.__timestampFormat = value

    def __writeHeader(self):
        fHandler = open(self.__fullFileName, 'w')

        header1 = f'# <Config><FileName>{self.__fileName}</FileName><StartTime>{getTimestamp()}</StartTime></Config>'
        header2 = 'Timestamp' + self.__delimiter + 'Level' + self.__delimiter + self.__titleLine

        fHandler.write(header1 + '\n')
        fHandler.write(header2 + '\n')
        fHandler.close()

    def addLogEntry(self, logData, level='INFO'):
        if self.__logStrategy == 'OnlyChanges':
            if logData == self.__lastLogData:
                print('.', end='', flush=True)
                return

        self.__lastLogData = logData

        logStr = getTimestamp(self.__timestampFormat) + self.__delimiter + level + self.__delimiter + logData
        print(logStr)

        fHandler = open(self.__fullFileName, 'a')
        fHandler.write(logStr + '\n')
        fHandler.close()

        self.__scrollFile()

    def __scrollFile(self):

        fHandler = open(self.__fullFileName, 'r')
        lines = fHandler.readlines()
        fHandler.close()

        headerLines = lines[0:2]
        dataLines = lines[2:]

        if len(dataLines) > self.__maxEntries:
            dataLines.pop(0)

            fHandler = open(self.__fullFileName, 'w')
            fHandler.writelines(headerLines)
            fHandler.writelines(dataLines)
            fHandler.close()
 
 
if __name__ == '__main__':
    print('Wetter Logger Testpgrogramm')

    pollingTime = input('Sample-Time [s] (default 2): : ') or '2'
    pollingTime = float(pollingTime)
    maxCounter = input('Anzahl Requests (default 10)') or '10'
    maxCounter = int(maxCounter)
    ort = input('Ort (default Wangen SZ): ') or 'Wangen SZ'
    language = input("Sprache [de,el,en,fr,hr,it] (default de):") or 'de'
    logFilePath = input('Log-File Pfad (default . für aktueller Ordner): ') or '.'
    logFileName = input('Log-File Name (default weatherLog.txt): ') or 'weatherLog.txt'
    strategy = input('Strategie [FixedSlices, OnlyChanges] (default OnlyChanges): ') or 'OnlyChanges'
    url_end_point = input('URL REST-Call (default OpenWeatherMap):') or 'http://api.openweathermap.org/data/2.5/weather'

    params_end_point = {
            'q': ort,
            'appid': '2d5c991c7c7fb45d482dfbba17ecd777',
            'mode': '',          
            'units': 'metric',   
            'lang': language
    }

    logger = Logger(fileName=logFileName,
                    filePath=logFilePath,
                    delimiter='|',
                    maxEntries=20,
                    logStrategy=strategy,
                    append=False,
                    timestampFormat='%Y-%m-%d %H:%M:%S',
                    titleLine='Temp [°C]|Druck [hPa]|Feuchte [%]|Beschreibung'
)

    counter = 0
    doLoop = True
    while doLoop:
        counter += 1
        responseStr = requests.get(url_end_point, params=params_end_point)
        jsonResponse = json.loads(responseStr.text)
        temp = jsonResponse['main']['temp']
        pressure = jsonResponse['main']['pressure']
        humidity = jsonResponse['main']['humidity']
        beschreibung = jsonResponse['weather'][0]['description']

        tempStr = f'{temp:.1f}'
        pressureStr = f'{pressure:.1f}'
        humidityStr = f'{humidity:.1f}'

        logData = logger.delimiter.join([tempStr, pressureStr, humidityStr, beschreibung])

        logger.addLogEntry(logData, level='INFO')

        time.sleep(pollingTime)

        if counter >= maxCounter:
            doLoop = False
