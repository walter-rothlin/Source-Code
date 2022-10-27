#!/usr/bin/python3

#-------------------------------------
# Name: MLZ_Logger.py
# Source: /home/pi/Documents/MLZ_Logger.py
#
# Description: Logging application with CSV output
#
# Autor: Philipp Schaefer
#
# History:
# 24-Oct-2022   Philipp Schaefer    Inital Version
#-------------------------------------

import json
import requests

from time import sleep, strftime, time


class DataLogger:
    loggerCount = 0
    
    # Standard methods
    # --------------------------
    
    def __init__(self, sampleTime=0, restURL="dummy", logLevel="DEBUG", scrollSize=10):
        #self.FormatTimeStamp
        self.setLogLevel()
        self.changeFileName()
        self.changeFilePath()
        self.setDelimiter()
        self.setScrollSize()


    # Business methods
    # ----------------
    
    def writeNewLog(self):
        Dlm = self.__Delim
        with open(self.__filePath+self.__fileName+".csv", 'w') as log:
            log.write("-------------------------------------------------------------------------------- \n")
            log.write("{0}{1} \n{2}{3}\n".format("File name:   ",str(self.__fileName+".csv"), "Time of logging:   ",strftime("%Y-%m-%d"+"T"+"%H:%M:%S")))
            log.write("-------------------------------------------------------------------------------- \n\n\n")
            log.write("Time-Stamp \t\t\t\t"+Dlm+" Log-Level \t"+Dlm+" Ortsname \t\t"+Dlm+" Land \t\t"+Dlm+" Temperatur \n")
            log.write("-------------------------------------------------------------------------------- \n")
            
            
    def writeLog(self,TimeStamp="0000-00-00T00:00:00",LogLevel="DEBUG",Ortsname="Default",Land="Default",Temp="0"):
        with open(self.__filePath+self.__fileName+".csv", 'a') as log:
            stringOut = "{1:s} \t{0:s} {2:s} \t\t{0:s} {3:s} \t{0:s} {4:s} \t\t{0:s} {5:5.1f}°C\n".format(self.__Delim, TimeStamp, LogLevel, Ortsname, Land, Temp)
            log.write(stringOut)
            
            
    
    #def getValues(self):
        
    
    
    # setter / getter methods
    # -----------------------
    
    def changeFileName(self, fileName="logfile"):
        self.__fileName = fileName
    
    def changeFilePath(self, filePath="/home/pi/Dokumente/"):
        self.__filePath = filePath

    def setDelimiter(self, character="|"):
        self.__Delim = character
        
    def setLogLevel(self, level="DEBUG"):
        self.logLevel = level
    
    def setScrollSize(self, scroll=10):
        self.scrollSize = scroll


if __name__ == '__main__':
    
    logger = DataLogger()
    logger.writeNewLog()
    
    #logger.LogLevel
    
    print("---Logger---")
    print("Bitte Sample-Time in Sekunden eingeben: \n")
    logger.sampleTime = int(input())
    
    url_str = "https://api.openweathermap.org/data/2.5/weather?q=Wangen+SZ&units=metric&lang=de&appid=144747fd356c86e7926ca91ce78ce170"

    print("\nLogging in progress... \n")

    for x in range(logger.scrollSize):
        responseStr = requests.get(url_str)
        responseStr = responseStr.text
        jsonResponse = json.loads(responseStr)

        time = strftime("%Y-%m-%d"+"T"+"%H:%M:%S")
        logger.writeLog(time,logger.logLevel,jsonResponse['name'],jsonResponse['sys']['country'],jsonResponse['main']['temp'])
            
        sleep(logger.sampleTime)
