# ----------------------------------------------------------------------------------------------------------------------
# Name: Mike_Keller_A20_DS.py
#
# Description:
# Loggerklasse -> Wird als general Implemenation programmiert, welches die gewünschten Objekt in eine File loggt.
# CLI-Programm -> Holt die gewünschten Wetterdaten von der Webseite https://openweathermap.org/ in einem gewissen
#                 Polling intervall
# DictionaryHelper -> Helps to create a Dictionary in one place
# FileHelper -> Helps with a File operation
# ShutdownHelper -> Helps to shut down the CLI
# Unit Tests   -> Tests sowohl das CLI-Programm, wie auch die Loggerklasse
#
# Author: Mike Keller
#
# History
# 27.11.2021    Mike Keller     Initial Version (UnitTest, first part of FileLogger, first part of WeatherCli)
# 27.11.2021    Mike Keller     More UnitTests, Added more classes (LogLevel, LogStrategy and Helpers) more
# 28.11.2021    Mike Keller     More UnitTests, Added more Logic to FileLogger and Cli
# 29.11.2021    Mike Keller     More UnitTests + Added Take same file or max 3 File at the same
#                               Place from the same place
# 30.11.2021    Mike Keller     More UnitTest + Added closing Program with a Key listener
# 30.11.2021    Mike Keller     Refactoring
# 01.12.2021    Mike Keller     Added ShutdownHelper
# ----------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      - Keine Reference-Applikation und ohne User Input
#
# Class Design und Implementation:
#      + Eigene Klassen vorhanden
#      - Notwendige (__eq__ __str__ ) Methoden nicht implementiert
#      + __init__ alle wichtige Parameter und haben sinnvolle Default-Werte
#      + Alle Instance Variablen sind private
#      + OnlyChanges implementiert
#      + Ringbuffer implementiert
#      - Einigen Methoden könnten private oder private static sein (bessere encapsulation)
#      + Kein Exceptionhandling in der Klasse oder in der Applikation
#
# Test:
#      ++ Sinnvolle automatisierte Test implementiert
#
# Note: 5.5
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wo wird unterschieden zwischen changesOnly True/False?
# ------------------------------------------------------------------
import csv
import datetime
import requests
import json
import time
import unittest
from enum import Enum
import os
import sys

from filelock import FileLock
from pynput import keyboard
import signal


class LogLevel(Enum):
    Info = 1,
    Debug = 2,
    Warnings = 3,
    Error = 4,
    Critical = 5


class LogStrategy(Enum):
    FixedSlices = 1,
    OnlyChanges = 2


class DictionaryHelper:
    @staticmethod
    def createLogDictionary(logTime,
                            logLevel,
                            temperatur="",
                            pressure="",
                            humidity="",
                            city="",
                            country="",
                            message="",
                            unit="metric"):
        """
        Creates a dictionary in one place with the parameter which are given to the method
        :param logTime:
        :param logLevel:
        :param temperatur:
        :param pressure:
        :param humidity:
        :param city:
        :param country:
        :param message:
        :param unit:
        :return: newly created dictionary
        """
        logDict = {}
        logDict["Log Time"] = logTime
        logDict["Log Level"] = logLevel

        if temperatur != "":
            if unit == "metric":
                logDict["Temperature"] = temperatur + " in Celsius"
            elif unit == "imperial":
                logDict["Temperature"] = temperatur + " in Fahrenheit"
        else:
            logDict["Temperature"] = temperatur

        if pressure != "":
            logDict["Pressure"] = pressure + " Millibar"
        else:
            logDict["Pressure"] = pressure

        if humidity != "":
            logDict["Humidity"] = humidity + "%"
        else:
            logDict["Humidity"] = humidity

        logDict["City"] = city
        logDict["Country"] = country
        logDict["Message"] = message

        return logDict

class FileHelper:
    @staticmethod
    def getAllLogFilesFromPlace(filePathSearch, weatherPlace):
        """
        Gets the filenames in a specific directory with a special name in the filename
        :param filePathSearch:
        :param weatherPlace:
        :return: a sorted filename list, sorted by the Moddate
        """
        listWithLogFiles = []
        for file in os.listdir(filePathSearch):
            if file.endswith(".csv") and weatherPlace in file:
                logFilesDict = {}
                logFilesDict["FileName"] = os.path.splitext(file)[0]
                logFilesDict["Timestamp"] = [os.stat(filePathSearch + "/" + file).st_mtime]
                listWithLogFiles.append(logFilesDict)
        # Files need to be sorted, newest file is the first entry, oldest file is the last entry
        return sorted(listWithLogFiles, key=lambda x: (x['Timestamp'], x['FileName']))


class ShutDownHelper:
    @staticmethod
    def on_press(key):
        """
        Checks if the ESC Key is pressed to terminate the application.
        Is specially not in a class because it didn't worked that way
        :param key:
        :return: nothing. Just does a print which says that the program is killed
        """
        if key == keyboard.Key.esc:
            print("Sie haben sich entschieden das Programm zu beenden. Danke für Ihre Nutzung und auf Wiedersehen!")
            os.kill(os.getppid(), signal.SIGTERM)


class WeatherCli:
    def checkInput(self, dataType, dataValue, defaultValue, message):
        """
        A generic method to check the user input, and gives more tries to do the correct input.
        After 3 Tries it takes the default value
        :param dataType:
        :param dataValue:
        :param defaultValue:
        :param message:
        :return: the corresponding value to the datatype
        """
        counter = 0
        whiteListDelimiter = [",", "|", ";", " "]
        while counter <= 2:
            try:
                if dataValue == "":
                    return defaultValue
                elif dataType == "float":
                    counter += 1
                    return float(dataValue)
                elif dataType == "int":
                    counter += 1
                    return int(dataValue)
                elif dataType == "unit":
                    counter += 1
                    if dataValue.lower() == "m":
                        return "metric"
                    elif dataValue.lower() == "f":
                        return "imperial"
                    else:
                        raise ValueError
                elif dataType == "delimiter":
                    counter += 1
                    if dataValue in whiteListDelimiter:
                        return dataValue
                    else:
                        raise ValueError
                elif dataType == "maxAmountLogEntry":
                    counter += 1
                    intValue = int(dataValue)
                    if intValue < 3:
                        raise ValueError
                    return intValue
                elif dataType == "logStrategy":
                    counter += 1
                    if dataValue.lower() == "c":
                        return LogStrategy.OnlyChanges
                    elif dataValue.lower() == "s":
                        return LogStrategy.FixedSlices
                    else:
                        raise ValueError
                elif dataType == "newFile":
                    counter += 1
                    if dataValue.lower() == "y":
                        return True
                    elif dataValue.lower() == "n":
                        return False
                    else:
                        raise ValueError
                elif dataType == "lang":
                    counter += 1
                    if dataValue.lower() == "de":
                        return "de"
                    elif dataValue.lower() == "fr":
                        return "fr"
                    elif dataValue.lower() == "en":
                        return "en"
                    elif dataValue.lower() == "it":
                        return "it"
                    else:
                        raise ValueError
                elif dataType == "filePath":
                    if not os.path.exists(dataValue):
                        print("Ihr angebenes Verzeichnis existiert noch nicht und wird jetzt erstellt!")
                        # Decision of the program that the path will be created if not existent
                        os.makedirs(dataValue)
                        time.sleep(1)
                        return dataValue
                    else:
                        return dataValue
                else:
                    return dataValue
            except ValueError:
                dataValue = input(f"\nIhr falscher Wert: {dataValue}\n" + message)
        else:
            print("\nSie haben es 3 Mal versucht. Der Defaultwert wird jetzt für diesen Parameter übernommen!\n"
                  f"Defaultwert = {defaultValue}")
            # Give the user a second pause the realise that the default value is getting taken
            time.sleep(1)
            return defaultValue


    def doInputs(self):
        """
        Method for all the inputs the user needs to do initially
        """
        informationString = "Guten Tag und Willkommen zur Wetter Applikation!\n" \
                            "Die nächsten paar Zeilen werden gewisse Parameter abfragen, die Sie eingeben können,\n" \
                            "falls sie dies nicht tun, sind schon Defaultwerte hinterlegt, " \
                            "die somit verwendet werden.\n" \
                            "Wenn eine Eingabe falsch wäre, werden Sie nochmals gebeten die Eingabe zu wiederholen.\n" \
                            "Dazu haben Sie maximal 3 Versuche, sonst wird der Defaultwert übernommen\n" \
                            "Wenn Sie direkt den Defaultwert übernehmen wollen, " \
                            "können Sie direkt die Entertaste drücken." \
                            "Viel Spass beim benutzen der Applikation\n" \
                            "------------------------------------------------------------------------------------------"
        print(informationString)
        pollingTimeInput = input("In welchen Intervall soll der Wetterservice das Wetter abfragen? "
                                 "Angabe in [s] (default: 20s): ")
        pollingTime = self.checkInput("int", pollingTimeInput, 20, "Das ist keine ganzzahlige Zahl.\n"
                                                                   "Bitte geben Sie nochmals den Intervall ein: ")

        weatherPlaceInput = input("\nVon welchem Ort möchten Sie das Wetter anzeigt bekommen? "
                                  "Ihre Eingabe (default: Winterthur): ")
        weatherPlace = self.checkInput("", weatherPlaceInput, "Winterthur", "")

        unitInput = input(
            "\nIn welchem Format möchten Sie die Daten erhalten?\n"
            "Für metrisches System geben Sie bitte ein [m] ein,\n"
            "für angloamerikansches System geben Sie bitte ein [f] ein (default: metrisches System): ")
        unit = self.checkInput("unit", unitInput, "metric", "Ihre Auswahl konnte nicht verarbeitet werden. "
                                                  "Bitte versuchen Sie es erneut: ")

        languageInput = input("\nIn welcher Sprache möchten Sie das Wetter geloggt haben?"
                              "\nMögliche Inputs: de -> Deutsch, fr -> Französisch, en -> Englisch, it -> Italienisch"
                              "\nIhre Eingabe (default: Deutsch): ")
        language = self.checkInput("lang", languageInput, "de",
                                   "Ihre Auswahl konnte nicht verarbeitet werden. Bitte versuchen Sie es erneut: ")

        delimiterInput = input("\nWelches Zeichen möchten Sie als Trennung in der Log Datei verwenden?"
                               "\nMöglicher Trennzeichen (',', ';', '|', ' ') "
                               "\nIhre Eingabe (default: |): ")
        delimiter = self.checkInput("delimiter", delimiterInput, "|", "Ihre Auswahl konnte nicht verarbeitet werden. "
                                                                       "Bitte versuchen Sie es erneut: ")

        maxAmountLogEntriesInFileInput = input("\nWas ist die maximale Anzahl Log Einträge, "
                                               "die Sie in der Datei sehen möchten?"
                                               "\nIhre Eingabe (Mindestens 3 Einträge, default: 100): ")
        maxAmountLogEntriesInFile = self.checkInput("maxAmountLogEntry", maxAmountLogEntriesInFileInput, 100,
                                                    "Ihre Auswahl konnte nicht verarbeitet werden. "
                                                    "Bitte versuchen Sie es erneut: ")

        logStrategyInput = input("\nWie möchten Sie genau die Einträge im Log File sehen?"
                             "\nFalls Sie nur sehen möchten, wenn Änderung sich ergeben dann geben Sie ein [c] ein,"
                             "\nfalls Sie einfach loggen möchten im gewissen Intervall geben Sie [s] ein"
                             "\nIhre Eingabe (default: Wird einfach geloggt): ")
        logStrategy = self.checkInput("logStrategy", logStrategyInput, LogStrategy.FixedSlices,
                                      "Ihre Auswahl konnte nicht verarbeitet werden. Bitte versuchen Sie es erneut: ")

        newFileInput = input("\nMöchten Sie die Daten in ein LogFile loggen, welches bereits erstellt ist,"
                             " oder möchten Sie"
                             "\nein neues File erstellen?"
                             "\nFür ein neues File geben Sie [Y] ein,"
                             "\nFür ein bereits vorhandenes File [N]"
                             "\nIhre Eingabe (default: Bestehendes File):")
        newFile = self.checkInput("newFile", newFileInput, False,
                                  "Ihre Auswahl konnte nicht verarbeitet werden. Bitte versuchen Sie es erneut: ")
        if newFile:
            filePathInput = input("\nWo möchten Sie ihr File erstellen? Geben Sie denn dazugehörigen Pfad ein"
                                  "\nIhre Eingabe (default: C:/Temp): ")
            # Special case, because if the Method checkInput is getting called with the value "" then is just takes that
            # but in the some cases that's not the correct value
            if filePathInput == "":
                filePathInput = "C:/Temp"
            filePath = self.checkInput("filePath", filePathInput, "C:/Temp", "")
        else:
            filePathSearchInput = input("\nIn welchem Pfad sollen die Logdaten ergänzt werden?"
                                        "\nGeben Sie nur das Verzeichnis an ohne den Filenamen. Es wird automatisch "
                                        "das modifizierte File verwendet"
                                        "\nIhre Eingabe (default C:/Temp):")
            if filePathSearchInput == "":
                filePathSearchInput = "C:/Temp"
            filePath = self.checkInput("filePath", filePathSearchInput, "C:/Temp", "")


        return (pollingTime,
                weatherPlace,
                unit,
                language,
                delimiter,
                maxAmountLogEntriesInFile,
                logStrategy,
                newFile,
                filePath)

    def checkDebugMode(self):
        """
        Checks if the program runs in the Debug Mode
        :return: If in Debug Mode return True else False
        """
        gettrace = getattr(sys, 'gettrace', None)
        if gettrace():
            return True
        else:
            return False

    def getLastLogFile(self, weatherPlace, filePathSearch):
        """
        Gets the last fileName by ModDate in a specific Directory
        :param weatherPlace:
        :param filePathSearch:
        :return:
        """
        sortedList = FileHelper.getAllLogFilesFromPlace(filePathSearch, weatherPlace)
        if any(sortedList):
            return sortedList[-1]["FileName"]
        else:
            return ""

    def runWeahterCli(self):
        """
        Main application which fetches the data from the openweather API
        :return:
        """
        (pollingTime,
         weatherPlace,
         unit,
         language,
         delimiter,
         maxAmountLogEntriesInFile,
         logStrategy,
         newFile,
         filePath) = self.doInputs()

        # listener is not until here instantiated because we wait for the user input
        listener = keyboard.Listener(on_press=ShutDownHelper.on_press)
        listener.start()
        print("Wenn Sie das Programm beenden wollen drücken Sie die ESC-Taste!")

        appKey = "0b3f53bce02af68051fc82d53db8bdbb"
        serviceUrl = "https://api.openweathermap.org/data/2.5/weather"

        # create file with a almost unique name
        fileName = f"{weatherPlace}_{datetime.datetime.now().strftime('%Y_%m_%d %H.%M.%S')}"
        if not newFile:
            newFileName = self.getLastLogFile(weatherPlace, filePath)
            if newFileName != "":
                fileName = newFileName

        fileLogger = FileLogger(
            fileName=fileName,
            delimiter=delimiter,
            maxAmountLogEntry=maxAmountLogEntriesInFile,
            logStrategy=logStrategy,
            newFile=newFile,
            filePath=filePath)

        if self.checkDebugMode():
            logDict = DictionaryHelper.createLogDictionary(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                                                           LogLevel.Debug.name,
                                                           "",
                                                           "",
                                                           "",
                                                           "",
                                                           "",
                                                           "Attribute wie der FileLogger instanziiert wurde: "
                                                           f"maxAmountLogEntry: {fileLogger.maxAmountLogEntry} "
                                                           f"logStrategy: {fileLogger.logStrategy.name}")
            fileLogger.createLogEntry(logDict)

        while True:
            callUrl = serviceUrl + f"?q={weatherPlace}&units={unit}&lang={language}&appid=" + appKey
            response = requests.get(callUrl)
            if self.checkDebugMode():
                logDict = DictionaryHelper.createLogDictionary(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                                                               LogLevel.Debug.name,
                                                               "",
                                                               "",
                                                               "",
                                                               "",
                                                               "",
                                                               f"Aufgerufene Url: {callUrl}")
                fileLogger.createLogEntry(logDict)

            jsonResponse = json.loads(response.text)

            try:
                temp = jsonResponse['main']['temp']
                pressure = jsonResponse['main']['pressure']
                humidity = jsonResponse['main']['humidity']
                city = jsonResponse["name"]
                country = jsonResponse["sys"]["country"]

                logDict = DictionaryHelper.createLogDictionary(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                                                     LogLevel.Info.name,
                                                     str(round(temp, 1)),
                                                     str(pressure),
                                                     str(humidity),
                                                     city,
                                                     country,
                                                     "",
                                                     unit)
                print(logDict)
                fileLogger.createLogEntry(logDict)
                time.sleep(pollingTime)
            except:
                logDict = DictionaryHelper.createLogDictionary(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                                                               LogLevel.Error.name,
                                                               "",
                                                               "",
                                                               "",
                                                               "",
                                                               "",
                                                               "Fehler beim Auslesen der JsonDaten")
                fileLogger.createLogEntry(logDict)
                time.sleep(pollingTime)


class FileLogger:
    def createNewLogFile(self):
        """
        Creates a new LogFile
        if there are more than 3 Files with the same place in the filename then the last ones get deleted
        """
        while len(FileHelper.getAllLogFilesFromPlace(self.filePath, self.fileName.split('_')[0])) >= 3:
                os.unlink(self.filePath + "/" +
                          FileHelper.getAllLogFilesFromPlace(self.filePath,
                                                             self.fileName.split('_')[0])[0]["FileName"] + ".csv")
        with open(self.__fullFilePath, "w") as logFile:
            logFile.write(f"# <Name>{self.__fullFilePath}</Name>\n")

    def __init__(self,
                 fileName,
                 delimiter="|",
                 filePath = "C:/Temp",
                 maxAmountLogEntry = 100,
                 logStrategy = LogStrategy.FixedSlices,
                 newFile = True):
        self.__fileName = fileName
        self.__delimiter = delimiter
        self.__filePath = filePath
        self.__maxAmountLogEntry = maxAmountLogEntry
        self.__logStrategy = logStrategy
        self.__newFile = newFile
        self.__fullFilePath = f"{self.__filePath}/{self.__fileName}.csv"

        if self.__newFile:
            self.createNewLogFile()
        else:
            if not os.path.isfile(self.__fullFilePath):
                print("Das File existiert noch nicht, wurde jetzt aber angelegt!")
                self.createNewLogFile()
                logDict = DictionaryHelper.createLogDictionary(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                                                               LogLevel.Warnings.name,
                                                               "",
                                                               "",
                                                               "",
                                                               "",
                                                               "",
                                                               "File musste entgegen User Eingabe neu erstellt werden")
                self.createLogEntry(logDict)
            else:
                self.checkForRingBuffer()


    @property
    def fileName(self):
        return self.__fileName

    @fileName.setter
    def fileName(self, newFileName):
        self.__fileName = newFileName
        self.__fullFilePath = f"{self.__filePath}/{newFileName}.csv"

    @property
    def delimiter(self):
        return self.__delimiter

    @delimiter.setter
    def delimiter(self, newDelimiter):
        self.__delimiter = newDelimiter

    @property
    def filePath(self):
        return self.__filePath

    @filePath.setter
    def filePath(self, newFilePath):
        self.__filePath = newFilePath
        self.__fullFilePath = f"{newFilePath}/{self.__fileName}.csv"

    @property
    def maxAmountLogEntry(self):
        return self.__maxAmountLogEntry

    @maxAmountLogEntry.setter
    def maxAmountLogEntry(self, newMaxAmountLogEntry):
        self.__maxAmountLogEntry = newMaxAmountLogEntry

    @property
    def logStrategy(self):
        return self.__logStrategy

    @logStrategy.setter
    def logStrategy(self, newLogStrategy):
        self.__logStrategy = newLogStrategy

    @property
    def newFile(self):
        return self.__newFile

    @newFile.setter
    def newFile(self, setNewFile):
        self.__newFile = setNewFile

    @property
    def fullFilePath(self):
        return self.__fullFilePath

    def getNumberOfLinesInFile(self):
        """
        Gets the number of lines in the file
        :return: amount of lines in the file
        """
        return sum(1 for line in open(self.__fullFilePath))

    def checkForRingBuffer(self):
        """
        Checks if there are more lines in the file than expected
        All entries of the expected number gets deleted
        """
        while self.getNumberOfLinesInFile() >= self.__maxAmountLogEntry:
            # Line number 3 of the file needs to be deleted because the first line holds the comment regarding
            # the name of the file and the second line holds the title of the Csv Rows
            lineToBeDeleted = 3
            with open(self.__fullFilePath, "r") as allLogEntries:
                listWithEntries = list(allLogEntries)

            del listWithEntries[lineToBeDeleted - 1]

            try:
                with open(self.__fullFilePath, "w") as allLogEntries:
                    for currentLogEntry in listWithEntries:
                        allLogEntries.write(currentLogEntry)
            except PermissionError as e:
                logDict = DictionaryHelper.createLogDictionary(
                    datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    LogLevel.Critical.name,
                    "",
                    "",
                    "",
                    "",
                    "",
                    f"Rechte Fehler beim schreiben des Log Eintrages {type(e)}")
                self.createLogEntry(logDict)

    def createLogEntryWithDelimeter(self, listOfElements):
        """
        Create a string of the elements which needs to be written to the file with the according delimiter
        :param listOfElements:
        :return: string with the elements for the Log entry and delimiter
        """
        logString = ""
        for i in listOfElements:
            logString += i + self.__delimiter

        logString += "\n"
        return logString

    def writeCsvTitles(self, keys):
        """
        Writes just the CSV-Titles to the file in the correct form
        :param keys:
        """
        numLines = self.getNumberOfLinesInFile()
        if numLines == 1:
            try:
                with open(self.__fullFilePath, "a+") as logFile:
                    logFile.write(self.createLogEntryWithDelimeter(keys))
            except PermissionError as e:
                logDict = DictionaryHelper.createLogDictionary(
                    datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    LogLevel.Critical.name,
                    "",
                    "",
                    "",
                    "",
                    "",
                    f"Rechte Fehler beim schreiben des Log Eintrages {type(e)}")
                self.createLogEntry(logDict)

    def checkLastEntry(self, newLogEntry):
        """
        Checks if the last entry is the same that wants to be added to the file
        :param newLogEntry:
        :return: True if the entry is different and False if it's the same
        """
        with open(self.__fullFilePath, "r") as logFile:
            lastLine = logFile.readlines()[-1]
        listOfLastEntry = lastLine.split(self.__delimiter)

        # jump over the first 2 entries because those doesn't need to be checked (Log Time and LogLevel)
        counter = 2
        for i in list(newLogEntry.values())[2:]:
            if i != listOfLastEntry[counter]:
                return True
            counter += 1

        return False

    def createLogEntry(self, logDict):
        """
        Writes the effective Log entry to the file
        :param logDict:
        """
        self.writeCsvTitles(logDict.keys())
        self.checkForRingBuffer()

        if self.__logStrategy == LogStrategy.OnlyChanges:
            shouldAppend = self.checkLastEntry(logDict)
        else:
            shouldAppend = True

        if shouldAppend == True:
            try:
                with open(self.__fullFilePath, "a") as logFile:
                    logFile.write(self.createLogEntryWithDelimeter(list(logDict.values())))
            except PermissionError as e:
                logDict = DictionaryHelper.createLogDictionary(
                    datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    LogLevel.Critical.name,
                    "",
                    "",
                    "",
                    "",
                    "",
                    f"Rechte Fehler beim schreiben des Log Eintrages {type(e)}")
                self.createLogEntry(logDict)
        else:
            print("Die lezte Abfrag um {0} hat keine Änderung hervorgebracht".format(logDict["Log Time"]))

if __name__ == '__main__':
    cli = WeatherCli()
    cli.runWeahterCli()


class TestFileLogger(unittest.TestCase):
    def setUp(self):
        self.fileLogger = FileLogger("UnitTestLogger_2021_11_28")


class TestFileLoggerInit(TestFileLogger):
    def test_InitFileName(self):
        self.assertEqual("UnitTestLogger_2021_11_28", self.fileLogger.fileName)

    def test_InitDelimiter(self):
        self.assertEqual("|", self.fileLogger.delimiter)

    def test_InitFilePath(self):
        self.assertEqual("C:/Temp", self.fileLogger.filePath)

    def test_InitMaxAmountLogEntry(self):
        self.assertEqual(100, self.fileLogger.maxAmountLogEntry)

    def test_InitLogStrategy(self):
        self.assertEqual(LogStrategy.FixedSlices, self.fileLogger.logStrategy)

    def test_InitNewFile(self):
        self.assertTrue(self.fileLogger.newFile)


class TestFileLoggerProperties(TestFileLogger):
    def test_SetFileName(self):
        newFileName = "SetterTest_2021_11_28"
        self.fileLogger.fileName = newFileName
        self.assertEqual(newFileName, self.fileLogger.fileName)

    def test_SetDelimeter(self):
        newDelimiter = ";"
        self.fileLogger.delimiter = newDelimiter
        self.assertEqual(newDelimiter, self.fileLogger.delimiter)

    def test_SetFilePath(self):
        newFilePath = "C:/Temp/Test"
        self.fileLogger.filePath = newFilePath
        self.assertEqual(newFilePath, self.fileLogger.filePath)

    def test_SetMaxAmountLogEntries(self):
        newMaxAmountLogEntry = 12
        self.fileLogger.maxAmountLogEntry = newMaxAmountLogEntry
        self.assertEqual(newMaxAmountLogEntry, self.fileLogger.maxAmountLogEntry)

    def test_SetLogStrategy(self):
        newLogStrategy = LogStrategy.OnlyChanges
        self.fileLogger.logStrategy = newLogStrategy
        self.assertEqual(newLogStrategy, self.fileLogger.logStrategy)

    def test_SetNewFile(self):
        setNewFile = False
        self.fileLogger.newFile = setNewFile
        self.assertEqual(setNewFile, self.fileLogger.newFile)


class TestCreateNewLogFile(TestFileLogger):
    def test_CreateNewLogFile(self):
        self.fileLogger.createNewLogFile()

        self.assertTrue(os.path.isfile(self.fileLogger.fullFilePath))

        with open(self.fileLogger.fullFilePath, "r") as logFile:
            firstLine = logFile.readline()
            self.assertEqual(f"# <Name>{self.fileLogger.fullFilePath}</Name>\n", firstLine)

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)


class TestGetNumberOfLinesInFile(TestFileLogger):
    def test_GetNumberOfLinesInFile_withOneLine(self):
        self.fileLogger.createNewLogFile()
        numberOfLines = self.fileLogger.getNumberOfLinesInFile()
        self.assertEqual(1, numberOfLines)

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_GetNumberOfLinesInFile_withTwoLine(self):
        self.fileLogger.createNewLogFile()
        self.fileLogger.writeCsvTitles(["TestKey1", "TestKey2"])
        numberOfLines = self.fileLogger.getNumberOfLinesInFile()
        self.assertEqual(2, numberOfLines)

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)


class TestRingBuffer(TestFileLogger):
    def createFile(self):
        testLogDict = {}
        testLogDict["TestKey1"] = "Test1"
        testLogDict["TestKey2"] = "Test2"

        counter = 1
        while counter < 10:
            self.fileLogger.createLogEntry(testLogDict)
            counter += 1

    def test_RingBufferHasNothingToDo(self):
        self.createFile()
        self.fileLogger.maxAmountLogEntry = 15
        # Ringbuffer needs nothing to do because the maxAmountOfLogEntry is bigger
        self.assertEqual(11, self.fileLogger.getNumberOfLinesInFile())

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_RingBufferNeedToBeOneEntryDeleted(self):
        self.createFile()

        # Before the ringbuffer is getting called the File has 11 Lines in the File
        self.assertEqual(11, self.fileLogger.getNumberOfLinesInFile())

        self.fileLogger.maxAmountLogEntry = 10
        self.fileLogger.checkForRingBuffer()
        # After the ringbuffer has been called the file just have 10 Lines in now
        self.assertEqual(9, self.fileLogger.getNumberOfLinesInFile())

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_GenerateFailureWhileWritingEntries(self):
        self.createFile()

        self.fileLogger.maxAmountLogEntry = 10
        with self.assertRaises(PermissionError):
            # Generating a file lock so the Ringbuffer can no deleted the entries
            with FileLock(self.fileLogger.fullFilePath):
                self.fileLogger.checkForRingBuffer()

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)


class TestLogEntryDelimiter(TestFileLogger):
    def test_CreateLogEntryWithDelimiter(self):
        delimiterString = self.fileLogger.createLogEntryWithDelimeter(["FirstElement", "SecondElement", "ThirdElement"])
        self.assertEqual("FirstElement|SecondElement|ThirdElement|\n", delimiterString)

    def test_CreateLogEntryWithChangedDelimiter(self):
        self.fileLogger.delimiter = ";"
        delimiterString = self.fileLogger.createLogEntryWithDelimeter(["FirstElement", "SecondElement", "ThirdElement"])
        self.assertEqual("FirstElement;SecondElement;ThirdElement;\n", delimiterString)


class TestCsvTitles(TestFileLogger):
    def test_WriteCsvTitles(self):
        self.fileLogger.writeCsvTitles(["FirstTitel", "SecondTitel", "ThirdTitel"])

        self.assertEqual(2, self.fileLogger.getNumberOfLinesInFile())

        with open(self.fileLogger.fullFilePath, "r") as logFile:
            self.assertEqual("FirstTitel|SecondTitel|ThirdTitel|\n",logFile.readlines()[1])

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_WriteCsvTitlesGeneratingException(self):
        with self.assertRaises(PermissionError):
            # Generating a file lock so the Ringbuffer can no deleted the entries
            with FileLock(self.fileLogger.fullFilePath):
                self.fileLogger.writeCsvTitles(["FirstTitel", "SecondTitel", "ThirdTitel"])

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_WriteCsvTitlesMutlipleTimesButOneOnceInFile(self):
        self.fileLogger.writeCsvTitles(["FirstTitel", "SecondTitel", "ThirdTitel"])
        self.fileLogger.writeCsvTitles(["FirstTitel", "SecondTitel", "ThirdTitel"])

        self.assertEqual(2, self.fileLogger.getNumberOfLinesInFile())

        with open(self.fileLogger.fullFilePath, "r") as logFile:
            self.assertEqual("FirstTitel|SecondTitel|ThirdTitel|\n", logFile.readlines()[1])

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)


class TestCheckLastEntryInLogFile(TestFileLogger):
    def test_SameNewEntryAsLast(self):
        logDict = {}
        logDict["LogTime"] = str(datetime.datetime.now())
        logDict["LogLevel"] = LogLevel.Critical.name
        logDict["FirstRealHeader"] = "FirstRealElement"
        logDict["SecondRealHeader"] = "SecondRealElement"
        self.fileLogger.createLogEntry(logDict)

        newLogDict = {}
        newLogDict["LogTime"] = str(datetime.datetime.now())
        newLogDict["LogLevel"] = LogLevel.Critical.name
        newLogDict["FirstRealHeader"] = "FirstRealElement"
        newLogDict["SecondRealHeader"] = "SecondRealElement"

        result = self.fileLogger.checkLastEntry(newLogDict)

        self.assertFalse(result)

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_DifferentNewEntryAsLast(self):
        logDict = {}
        logDict["LogTime"] = str(datetime.datetime.now())
        logDict["LogLevel"] = LogLevel.Critical.name
        logDict["FirstRealHeader"] = "FirstRealElement"
        logDict["SecondRealHeader"] = "SecondRealElement"
        self.fileLogger.createLogEntry(logDict)

        newLogDict = {}
        newLogDict["LogTime"] = str(datetime.datetime.now())
        newLogDict["LogLevel"] = LogLevel.Critical.name
        newLogDict["FirstRealHeader"] = "FirstRealElement"
        newLogDict["SecondRealHeader"] = "SecondRealDifferentElement"

        result = self.fileLogger.checkLastEntry(newLogDict)

        self.assertTrue(result)

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)


class TestCreateLogEntry(TestFileLogger):
    def test_NormalNewEntry(self):
        dateTimeNow = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        logDict = {}
        logDict["Log Time"] = dateTimeNow
        logDict["Log Level"] = LogLevel.Info.name
        logDict["Temp"] = "2.3"
        logDict["City"] = "Winterthur"

        self.fileLogger.createLogEntry(logDict)
        self.assertEqual(3, self.fileLogger.getNumberOfLinesInFile())

        with open(self.fileLogger.fullFilePath, "r") as logFile:
            self.assertEqual(f"{dateTimeNow}|Info|2.3|Winterthur|\n", logFile.readlines()[2])

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_OnlyChangesWithoutChange(self):
        self.fileLogger.logStrategy = LogStrategy.OnlyChanges
        dateTimeNow = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        logDict = {}
        logDict["Log Time"] = dateTimeNow
        logDict["Log Level"] = LogLevel.Info.name
        logDict["Temp"] = "2.3"
        logDict["City"] = "Winterthur"

        self.fileLogger.createLogEntry(logDict)
        self.fileLogger.createLogEntry(logDict)
        self.assertEqual(3, self.fileLogger.getNumberOfLinesInFile())

        with open(self.fileLogger.fullFilePath, "r") as logFile:
            self.assertEqual(f"{dateTimeNow}|Info|2.3|Winterthur|\n", logFile.readlines()[2])

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_OnlyChangesWithaChange(self):
        self.fileLogger.logStrategy = LogStrategy.OnlyChanges
        dateTimeNow = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        logDict = {}
        logDict["Log Time"] = dateTimeNow
        logDict["Log Level"] = LogLevel.Info.name
        logDict["Temp"] = "2.3"
        logDict["City"] = "Winterthur"
        self.fileLogger.createLogEntry(logDict)

        dateTimeNowNew = str(datetime.datetime.now())
        newLogDict = {}
        newLogDict["Log Time"] = dateTimeNowNew
        newLogDict["Log Level"] = LogLevel.Info.name
        newLogDict["Temp"] = "2.4"
        newLogDict["City"] = "Winterthur"
        self.fileLogger.createLogEntry(newLogDict)

        self.assertEqual(4, self.fileLogger.getNumberOfLinesInFile())

        with open(self.fileLogger.fullFilePath, "r") as logFile:
            self.assertEqual(f"{dateTimeNowNew}|Info|2.4|Winterthur|\n", logFile.readlines()[3])

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)

    def test_GenerateFailureWhileWritingEntry(self):
        with self.assertRaises(PermissionError):
            # Generating a file lock so the Ringbuffer can no deleted the entries
            with FileLock(self.fileLogger.fullFilePath):
                logDict = {}
                logDict["Log Time"] = str(datetime.datetime.now())
                logDict["Log Level"] = LogLevel.Info.name
                logDict["Temp"] = "2.3"
                logDict["City"] = "Winterthur"
                self.fileLogger.createLogEntry(logDict)

        # clean up File from unit test
        os.remove(self.fileLogger.fullFilePath)


class DictionaryHelperTest(unittest.TestCase):
    def test_CreateLogDictionary(self):
        datetimeNow = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
        actualDict = DictionaryHelper.createLogDictionary(
            datetimeNow,
            LogLevel.Debug.name,
            "2.3",
            "998",
            "82",
            "Winterthur",
            "CH"
        )
        expectedDict = {}
        expectedDict["Log Time"] = datetimeNow
        expectedDict["Log Level"] = LogLevel.Debug.name
        expectedDict["Temperature"] = "2.3 in Celsius"
        expectedDict["Pressure"] = "998 Millibar"
        expectedDict["Humidity"] = "82%"
        expectedDict["City"] = "Winterthur"
        expectedDict["Country"] = "CH"
        expectedDict["Message"] = ""
        self.assertDictEqual(expectedDict, actualDict)

    def test_CreateLogDictionaryTemperatureInFahrenheit(self):
        datetimeNow = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
        actualDict = DictionaryHelper.createLogDictionary(
            datetimeNow,
            LogLevel.Debug.name,
            "2.3",
            "998",
            "82",
            "Winterthur",
            "CH",
            "",
            "imperial"
        )
        self.assertEqual("2.3 in Fahrenheit", actualDict["Temperature"])


class FileHelperTest(unittest.TestCase):
    def test_GetAllLogFilesFromPlace(self):
        fileNames = []
        for i in range(2):
            fileName = f"C:/Temp/TestCity_2021_11_30_{i}.csv"
            with open(fileName, "w") as logFile:
                logFile.write("This is a test header")
                fileNames.append(fileName)

        files = FileHelper.getAllLogFilesFromPlace("C:/Temp", "TestCity")
        self.assertEqual(2, len(files))

        #clean up test files
        for file in fileNames:
            os.remove(file)


    def test_GetAllLogFilesFromPlaceButNoFiles(self):
        files = FileHelper.getAllLogFilesFromPlace("C:/Temp", "TestCityNotExistent")
        self.assertEqual(0, len(files))

    def test_CorrectOrder(self):
        fileNames = []
        fileNamesToDelete = []
        for i in range(2):
            fileName = f"C:/Temp/TestCity_2021_11_30_{i}.csv"
            with open(fileName, "w") as logFile:
                logFile.write("This is a test header")
                fileNames.append(f"TestCity_2021_11_30_{i}")
                fileNamesToDelete.append(fileName)
                time.sleep(1)

        files = FileHelper.getAllLogFilesFromPlace("C:/Temp", "TestCity")
        counter = 0
        for element in fileNames:
            self.assertEqual(element, files[counter]["FileName"])
            counter += 1

        # clean up test files
        for file in fileNamesToDelete:
            os.remove(file)


class TestWeatherCli(unittest.TestCase):
    def setUp(self):
        self.weatherCli = WeatherCli()


class TestWeatherCliInit(TestWeatherCli):
    def test_GetLastLogFile(self):
        fileNames = []
        for i in range(2):
            fileName = f"C:/Temp/TestCity_2021_11_30_{i}.csv"
            with open(fileName, "w") as logFile:
                logFile.write("This is a test header")
                fileNames.append(fileName)

        lastFile = self.weatherCli.getLastLogFile("TestCity", "C:/Temp")
        self.assertEqual("TestCity_2021_11_30_1", lastFile)

        # clean up test files
        for file in fileNames:
            os.remove(file)

    def test_GetLastLogFileButNoOneIsThere(self):
        lastFile = self.weatherCli.getLastLogFile("TestCityNotExistent", "C:/Temp")
        self.assertEqual("", lastFile)
