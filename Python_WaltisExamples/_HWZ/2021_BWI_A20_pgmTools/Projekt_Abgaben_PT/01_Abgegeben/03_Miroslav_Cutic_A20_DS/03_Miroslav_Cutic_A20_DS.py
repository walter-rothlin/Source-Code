from datetime import datetime
import time
import json
import requests
import os.path


def getTimeStamp(dateFormat):
    return datetime.now().strftime(dateFormat)


def addQueryParamter(value):
    return "?q=" + value


def getFileNameWithTimeStamp(fileName):
    indexBeforeFileType = fileName.index(".")
    fileName = fileName[:indexBeforeFileType] + "_" + getTimeStamp("%Y_%m_%d") + fileName[indexBeforeFileType:]
    return fileName


class RESTLogger:
    def __init__(self, titleFields, delimiter="|", filePath="", fileName="", ringBuffer=100, onlyChanges=False,
                 newFile=True):
        self.__delimiter = delimiter
        self.__filePath = filePath
        self.__fileName = fileName
        self.__ringBuffer = ringBuffer
        self.__onlyChanges = onlyChanges
        self.__newFile = newFile
        self.lastLoggedEntry = ""

        fileName = getFileNameWithTimeStamp(fileName)

        if self.__newFile or not os.path.exists(self.__filePath + self.__fileName):
            xmlHeader = "# <Name>" + fileName + "</Name>"
            self.addLog(xmlHeader, append=False, isHeader=True)
            if titleFields:
                self.addLog("Timestamp" + self.__delimiter + "Level" + self.__delimiter + titleFields,
                            isHeader=True)

    def __str__(self):
        retStr = "delimiter    : " + self.__delimiter + "\n"
        retStr += "filePath     : " + self.__filePath + "\n"
        retStr += "fileName     : " + self.__fileName + "\n"
        retStr += "ringBuffer   : " + str(self.__ringBuffer) + "\n"
        retStr += "onlyChanges  : " + str(self.__onlyChanges) + "\n"
        retStr += "newFile      : " + str(self.__newFile) + "\n"
        return retStr

    def addLog(self, logBody, level="INFO", append=True, isHeader=False):
        duplicatedEntry = False
        if self.lastLoggedEntry == logBody:
            duplicatedEntry = True
        self.lastLoggedEntry = logBody

        prefix = getTimeStamp("%Y-%m-%d %H:%M:%S") + self.__delimiter + level + self.__delimiter
        if not isHeader:
            if duplicatedEntry:
                if self.__onlyChanges:
                    return
                else:
                    logBody = prefix + logBody
                    print(logBody)
            else:
                logBody = prefix + logBody
                print(logBody)

        if append:
            logFile = open(self.__filePath + self.__fileName, "a")
        else:
            logFile = open(self.__filePath + self.__fileName, "w")
        logFile.write(logBody + "\n")
        logFile.close()

        # Ringbuffer
        logFile = open(self.__filePath + self.__fileName, "r")
        logFileLines = logFile.readlines()
        logFile.close()
        amountOfLogEntries = len(logFileLines) - 2  # Without header lines

        if amountOfLogEntries > self.__ringBuffer:
            del logFileLines[2]
            updatedLogFile = open(self.__filePath + self.__fileName, "w+")
            for line in logFileLines:
                updatedLogFile.write(line)
            updatedLogFile.close()


if __name__ == '__main__':
    delimiter = ";"
    endPoint = "http://api.openweathermap.org/data/2.5/weather"
    apiKey = "&appid=da364beec702195be0ed69f1e4314b17"
    defaultMetricSuffix = "&units=metric"
    defaultPoolingTime = 2
    defaultRingBuffer = 100
    queryParameters = ""
    titleFields = ""

    propertiesToLog = [
        "name", "country", "feels_like", "temp", "pressure",
    ]

    for field in propertiesToLog:
        titleFields += field + delimiter

    city = input("From which city do you want to know the weather? : ")
    if not city:
        city = "Zagreb"  # Default city
    queryParameters = addQueryParamter(city)

    poolingTime = input("What pooling time suits you? : ")
    if not poolingTime:
        poolingTime = defaultPoolingTime  # Default pooling time
    poolingTime = int(poolingTime)

    ringBuffer = input("What's the maximum of entries you'd like to log? : ")
    if not ringBuffer:
        ringBuffer = defaultRingBuffer  # Default ring buffer
    ringBuffer = int(ringBuffer)

    strategy = input("Would you like to log only changes? [y|n]: ")
    if not strategy or strategy == "y":
        strategy = True  # Default strategy
    else:
        strategy = False

    restLogger = RESTLogger(titleFields, delimiter=delimiter, fileName="miroTest.txt",
                            onlyChanges=strategy, ringBuffer=ringBuffer, newFile=False)

    while True:
        requestUrl = endPoint + queryParameters + apiKey + defaultMetricSuffix
        response = requests.get(requestUrl)
        jsonData = json.loads(response.text)

        if response.status_code == 404:
            if jsonData["message"] == "city not found":
                print("\nWhoops! Looks like you entered an invalid city. Please try again!")

        logEntry = ""
        for field in propertiesToLog:
            if field == "name":
                logEntry += str(jsonData[field]) + delimiter
            elif field == "country":
                logEntry += str(jsonData["sys"][field]) + delimiter
            else:
                logEntry += str(jsonData["main"][field]) + delimiter

        restLogger.addLog(logEntry)
        time.sleep(poolingTime)
