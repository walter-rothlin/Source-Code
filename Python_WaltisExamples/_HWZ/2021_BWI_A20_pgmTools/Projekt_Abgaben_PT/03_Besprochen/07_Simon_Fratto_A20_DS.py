'''
Name: Simon Fratto
Klasse: BWI-A20
Fach: Programming Tools
Abgabe Datum: 02.12.2021 18:00

Applikation: Log REST Service Call

Beschreibung:
Mit dem Tool kann man jeglichen REST Service aufrufen und das Resultat in einem File abspeichern

API Key:
22ba180b36721054905c21878f73dafc (https://openweathermap.org/api)

URL Tested:
- http://api.openweathermap.org/data/2.5/weather?q=Cali&appid=22ba180b36721054905c21878f73dafc
- https://cat-fact.herokuapp.com/facts
- https://api.kucoin.com/api/v1/market/stats?symbol=BTC-USDT

'''
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und User Input ist möglich
#      - Bei Usereingaben sind mögliche Werte in [] nicht sinnvoll
#      - User-Eingaben können zum Absturz führen
#      - Sehr komplex und nicht intuitiv
#
# Class Design und Implementation:
#      - viel zu viele Klassen, Relevante Logger-Klasse nicht vorhanden
#      - verstehe die Klassen nicht (total ca 2500 Zeilen Code!)
#
# Test:
#      + Test implementiert
#
# Note: 5.5 Am Ziel vorbei aber viel geleistet
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wo wird unterschieden zwischen changesOnly True/False?
# ------------------------------------------------------------------

import requests
import json
import time
import datetime
from threading import Timer
from enum import Enum
import os
import tkinter
from tkinter import *
from tkinter import ttk


# Beinhaltet die Information ob etwas in einem Applikationslauf schon ausgeführt wurde
# Boolean
class RunOnce:
    def __init__(self):
        super(RunOnce, self).__init__()
        self.__runOnce = True

    def __str__(self):
        return "RunOnce"

    def __repr__(self):
        return vars(self)

    def getRunOnce(self):
        return self.__runOnce

    def setRunOnce(self, value):
        if not isinstance(value, bool):
            raise ValueError("RunOnce is not Boolean [{}]".format(type(value)))
        self.__runOnce = value

    RunOnce = property(getRunOnce, setRunOnce)


# Beinhaltet die Information wie ein File Name erweitert werden soll,
# falls der Overwrite = False ist und das File schon existiert
# Integer
class FileExtension:
    def __init__(self):
        super(FileExtension, self).__init__()
        self.__fileExtension = None

    def __str__(self):
        return "FileExtension"

    def __repr__(self):
        return vars(self)

    def getFileExtension(self):
        if self.__fileExtension is None:
            return ""
        return "_(" + str(self.__fileExtension) + ")"

    def setFileExtension(self, value):
        if not isinstance(value, int):
            raise ValueError("File Extention is not Integer [{}]".format(type(value)))
        self.__fileExtension = value

    FileExtension = property(getFileExtension, setFileExtension)


# Beinhaltet die Information ob ein bestehendes File überschrieben werden darf
# oder ob ein neues erstellt werden muss mit anderem Namen
# Boolean (True = File darf überschrieben werden; False= File darf nicht überschrieben werden)
class FileOverwrite:
    def __init__(self):
        super(FileOverwrite, self).__init__()
        self.__fileOverwrite = True

    def __str__(self):
        return "FileOverwrite"

    def __repr__(self):
        return vars(self)

    def getFileOverwrite(self):
        return self.__fileOverwrite

    def setFileOverwrite(self, value):
        if not isinstance(value, bool):
            raise ValueError("File Overwrite is not Boolean [{}]".format(type(value)))
        self.__fileOverwrite = value

    FileOverwrite = property(getFileOverwrite, setFileOverwrite)


# Beinhaltet die Information mit welchem Datei Type (Datei Ende) das File erstellt werden soll
# String: xml, csv, txt, doc, ...
class FileType:
    def __init__(self):
        super(FileType, self).__init__()
        self.__fileType = "csv"

    def __str__(self):
        return "FileType"

    def __repr__(self):
        return vars(self)

    def getFileType(self):
        return self.__fileType

    def setFileType(self, value):
        if not isinstance(value, str):
            raise ValueError("File Type is not String [{}]".format(type(value)))
        if len(value) > 3:
            raise ValueError("File Type is too long")
        self.__fileType = value.lower()

    FileType = property(getFileType, setFileType)


# Beinhaltet die Information wie das File heissen soll
# kann mittels Parameter individualisiert werden.
# Sting: File1, DateiX ...
# Paramter implementiert: %Y = aktuelles Jahr; %m= aktueller Monat ; %d = aktueller Tag
class FileName:
    def __init__(self):
        super(FileName, self).__init__()
        self.__fileName = "%Y_%m_%d_REST_LOGGER"

    def __str__(self):
        return "FileName"

    def __repr__(self):
        return vars(self)

    def getFileName(self):
        name = self.__fileName
        name = name.replace("%Y", TimeProcessor.getYear())
        name = name.replace("%m", TimeProcessor.getMonth())
        name = name.replace("%d", TimeProcessor.getDay())
        return name

    def setFileName(self, value):
        if not isinstance(value, str):
            raise ValueError("File Name is not String [{}]".format(type(value)))
        self.__fileName = value

    FileName = property(getFileName, setFileName)


# Beinhaltet die Information wo das File gespeichert ist
# String: ./    c:\temp (Pfad muss existieren!)
class FilePath:
    def __init__(self):
        super(FilePath, self).__init__()
        self.__filePath = "./"

    def __str__(self):
        return "FilePath"

    def __repr__(self):
        return vars(self)

    def getFilePath(self):
        return self.__filePath

    def setFilePath(self, value):
        if not isinstance(value, str):
            raise ValueError("File Path is not String [{}]".format(type(value)))
        self.__filePath = value

    FilePath = property(getFilePath, setFilePath)


# Beinhaltet alle Information welche für das File relevant sind
# Implementierte Funktionen:
# Funktion: Gibt den File Namen inklusive Datei Typ aus
# Funktion: Gibt den Speichertort aus %Pfad/%Name.%Type
#class File(FilePath, FileName, FileType, FileOverwrite):
class File(FilePath, FileName, FileType, FileOverwrite, FileExtension, RunOnce):
    def __init__(self):
        super(File, self).__init__()

    def __str__(self):
        return "File"

    def __repr__(self):
        return vars(self)

    def getFileName(self):
        return "{}.{}".format(self.FileName + self.FileExtension, self.FileType)

    def getFileLocation(self):
        return "{}{}.{}".format(self.FilePath, self.FileName + self.FileExtension, self.FileType)


# Beinhaltet die Information ab welcher Speicherzelle Daten abgelegt werden können
# Integer
class StorageRangeStart:
    def __init__(self):
        super(StorageRangeStart, self).__init__()
        self.__storageRangeStart = 2

    def __str__(self):
        return "StorageRangeStart"

    def __repr__(self):
        return vars(self)

    def getStorageRangeStart(self):
        return self.__storageRangeStart

    def setStorageRangeStart(self, value):
        if not isinstance(value, int):
            raise ValueError("Range Start is not Integer [{}]".format(type(value)))
        if value < 0:
            raise ValueError("Range Start cannot be smaller zero")
        self.__storageRangeStart = value

    StorageRangeStart = property(getStorageRangeStart, setStorageRangeStart)


# Beinhaltet die Information bei welcher Speicherzelle sich die Instanz gerade befindet
# so dass man Daten gezielt ablegen kann
# Integer
class StorageRangePosition:
    def __init__(self):
        super(StorageRangePosition, self).__init__()
        self.__storageRangePosition = 2

    def __str__(self):
        return "StorageRangePosition"

    def __repr__(self):
        return vars(self)

    def getStorageRangePosition(self):
        return self.__storageRangePosition

    def setStorageRangePosition(self, value):
        if not isinstance(value, int):
            raise ValueError("Range Position is not Integer [{}]".format(type(value)))
        if value < 0:
            raise ValueError("Range Position cannot be smaller zero")
        self.__storageRangePosition = value

    StorageRangePosition = property(getStorageRangePosition, setStorageRangePosition)


# Beinhaltet die Information wie gross der Speicher ist
# bzw wie gross das Dict werden darf (unter berücksichtigung der Startposition)
# Integer
class StorageRangeSize:
    def __init__(self):
        super(StorageRangeSize, self).__init__()
        self.__storageRangeSize = 100

    def __str__(self):
        return "StorageRangeSize"

    def __repr__(self):
        return vars(self)

    def getStorageRangeSize(self):
        return self.__storageRangeSize

    def setStorageRangeSize(self, value):
        if not isinstance(value, int):
            raise ValueError("Range Size is not Integer [{}]".format(type(value)))
        if value < 0:
            raise ValueError("Range Size cannot be smaller zero")
        self.__storageRangeSize = value

    StorageRangeSize = property(getStorageRangeSize, setStorageRangeSize)


# Beinhaltet die Speicherzellen wie die Daten abgelegt werden
# Dict
class StorageSpace:
    def __init__(self):
        super(StorageSpace, self).__init__()
        self.__storageSpace = {}

    def __str__(self):
        return "StorageSpace"

    def __repr__(self):
        return vars(self)

    def getStorageSpace(self):
        return self.__storageSpace

    def setStorageSpace(self, value):
        self.__storageSpace = value

    StorageSpace = property(getStorageSpace, setStorageSpace)


# Beinhaltet alle Information welche für das speichern von Daten in den Storage relevant sind
# Implementierte Funktionen:
# __add__: Hinzufügen von Daten in den Speicher
# Funktion: Position zur nächsten Speicherzelle verschieben
class Storage(StorageSpace, StorageRangeSize, StorageRangeStart, StorageRangePosition):
    def __init__(self):
        super(Storage, self).__init__()

    def __str__(self):
        return "Storage"

    def __repr__(self):
        return vars(self)

    def __add__(self, data):
        self.StorageSpace[self.StorageRangePosition] = data

    # def add(self, data):
    #     self.StorageSpace[self.StorageRangePosition] = data

    def nextStoragePosition(self):
        pos = self.StorageRangePosition
        pos += 1
        if pos >= self.StorageRangeStart + self.StorageRangeSize:
            pos = self.StorageRangeStart
        self.StorageRangePosition = pos


# Beinhaltet die Information wie einzelne Daten bei der Ausgabe getrennt werden sollen
# String: | ; . ,
class Delimiter:
    def __init__(self):
        super(Delimiter, self).__init__()
        self.__delimiter = "|"

    def __str__(self):
        return "Delimiter"

    def __repr__(self):
        return vars(self)

    def getDelimiter(self):
        return self.__delimiter

    def setDelimiter(self, value):
        if not isinstance(value, str):
            raise ValueError("Delimiter is not String [{}]".format(type(value)))
        self.__delimiter = value

    Delimiter = property(getDelimiter, setDelimiter)


# Beinhaltet die Information wie die einzelnen Daten in einem Log Statement bezeichnet sind
# Initialwerte sind Erstellungszeitpunkt und Log Level
# Liste mit Strings
class LogEntryIndex:
    def __init__(self):
        super(LogEntryIndex, self).__init__()
        self.__logEntryIndex = ['CreationTime', 'LogLevel']

    def __str__(self):
        return "LogEntryIndex"

    def __repr__(self):
        return vars(self)

    def getLogEntryIndex(self):
        return self.__logEntryIndex

    def setLogEntryIndex(self, value):
        if not isinstance(value, str):
            raise ValueError("Index is not String [{}]".format(type(value)))
        self.__logEntryIndex.append(value)

    LogEntryIndex = property(getLogEntryIndex, setLogEntryIndex)


# Beinhaltet die Information wie die Log Statements klassifiziert werden
# ENUM: Debug, Info, Warnings, Error, Critical
class LogLevel(Enum):
    DEBUG = 0
    INFO = 1
    WARNINGS = 2
    ERROR = 3
    CRITICAL = 4


# Beinhaltet die Information wie das Log Statment klassifiziert ist
# Integer mit relation zu Log Level[ENUM]
class LogType:
    def __init__(self):
        super(LogType, self).__init__()
        self.__logType = LogLevel(1).value

    def __str__(self):
        return "LogType"

    def __repr__(self):
        return vars(self)

    def getLogType(self):
        return LogLevel(self.__logType).name

    def setLogType(self, value):
        if not isinstance(value, int):
            raise ValueError("Log Type is not Integer [{}]".format(type(value)))
        if (value < 0) or (value >= len(LogLevel)):
            raise ValueError("Log Type (int) out of range")
        self.__logType = value

    LogType = property(getLogType, setLogType)


# Beinhaltet alle Daten welche in einem Log Statement abgespeichert sind
# Dict
# Funktion: Hinzufügen von Daten in das Log Statement an einer spezifischen Position
# Funktion: Beziehe alle Daten innerhalb des Log Statements als Liste
# Funktion: Hinzufügen eines neuen Datensatz mit Index und mit leerem Inhalt
class LogEntry():
    def __init__(self):
        super(LogEntry, self).__init__()
        self.__logEntry = {}

    def __str__(self):
        return "LogEntry"

    def __repr__(self):
        return vars(self)

    def getLogEntry(self):
        return self.__logEntry

    def setLogEntry(self, value):
        self.__logEntry = value

    LogEntry = property(getLogEntry, setLogEntry)

    def add(self, pos, data):
        self.__logEntry[pos] = data

    def getLogEntryValues(self):
        valueList = []
        for i in range(0, LogProcessor.getProperties(indexCount=True), 1):
            if i in self.LogEntry:
                valueList.append(str(self.LogEntry[i]))
            else:
                valueList.append("")
        return valueList

    def addNewIndex(self, pos):
        self.LogEntry[pos] = ""


# Beinhaltet die Information zu welchem Zeitpunkt etwas erstellt wurde
# String
class CreationTime:
    def __init__(self):
        super(CreationTime, self).__init__()
        self.__creationTime = ""

    def __str__(self):
        return "CreationTime"

    def __repr__(self):
        return vars(self)

    def getCreationTime(self):
        return self.__creationTime

    def setCreationTime(self, value):
        if not isinstance(value, str):
            raise ValueError("Creationtime is not String [{}]".format(type(value)))
        self.__creationTime = value

    CreationTime = property(getCreationTime, setCreationTime)


# Beinhaltet das Objekt welches zu Vergleichszwecken als Referenzwert genommen wird
# Object
class BenchMark:
    def __init__(self):
        super(BenchMark, self).__init__()
        self.__benchMark = None

    def __str__(self):
        return "BenchMark"

    def __repr__(self):
        return vars(self)

    def getBenchMark(self):
        return self.__benchMark

    def setBenchMark(self, value):
        self.__benchMark = value

    BenchMark = property(getBenchMark, setBenchMark)


# Beinhaltet die Information nach welcher Methode geloggt werden soll
# ENUM:
# full = Alle Informationen werden ausgegeben;
# incremental = Alle Integer Informationen werden mit dem ersten Eintrag verglichen und die Differenz ausgegeben;
# differential = Alle Integer Informationen werden mit dem vorhergehenden Eintrag verglichen und die Differenz ausgegeben;
class LogModi(Enum):
    full = 0
    incremental = 1
    differential = 2


# Beinhaltet die Information welche Log methode gewählt wurde
# Integer mit relation zu Log Modi [ENUM]
class LogModus:
    def __init__(self):
        super(LogModus, self).__init__()
        self.__logModus = LogModi(0).value

    def __str__(self):
        return "LogModus"

    def __repr__(self):
        return vars(self)

    def getLogModus(self):
        return LogModi(self.__logModus).name

    def setLogModus(self, value):
        if not isinstance(value, int):
            raise ValueError("Log Modus is not Integer [{}]".format(type(value)))
        if (value < 0) or (value >= len(LogModi)):
            raise ValueError("Log Modus (int) out of range")
        self.__logModus = value

    LogModus = property(getLogModus, setLogModus)


# Beinhaltet alle Information welche zur Diffrenzierung der Log methoden benötigt werden
class ProcessModus(LogModus, BenchMark):
    def __init__(self):
        super(ProcessModus, self).__init__()

    def __str__(self):
        return "ProcessModus"

    def __repr__(self):
        return vars(self)


# Beinhaltet alle Information welche für das Loggen benötigt werden
class Log(CreationTime, LogEntryIndex, Delimiter, Storage, ProcessModus, LogType):
    def __init__(self):
        super(Log, self).__init__()

    def __str__(self):
        return "Log"

    def __repr__(self):
        return vars(self)


# Beinhaltet die Information welche Adresse der REST Service Client aufrufen soll
# String
class URL:
    def __init__(self):
        super(URL, self).__init__()
        self.__url = "http://api.openweathermap.org/data/2.5/weather?q=Basel&appid=22ba180b36721054905c21878f73dafc"

    def __str__(self):
        return "URL"

    def __repr__(self):
        return vars(self)

    def getURL(self):
        return self.__url

    def setURL(self, value):
        if not isinstance(value, str):
            raise ValueError("URL is not String [{}]".format(type(value)))
        self.__url = value

    URL = property(getURL, setURL)


# Beinhaltet das Resultat des REST Service Calls
# Objekt
# Funktion: Gibt das Resultat Flachgedrückt zurück 1. Ebene: Datensets, 2. Ebene: Daten einer Sets
class Result:
    def __init__(self):
        super(Result, self).__init__()
        self.__result = None

    def __str__(self):
        return "Result"

    def __repr__(self):
        return vars(self)

    def getResult(self):
        return self.__result

    def setResult(self, value):
        self.__result = value

    Result = property(getResult, setResult)

    def flatten(self):
        def convert(obj, desc=""):
            if isinstance(obj, dict):
                for i in obj:
                    convert(obj[i], "_".join([desc, i]))
            elif isinstance(obj, list):
                for i in range(0, len(obj), 1):
                    convert(obj[i], desc)
            elif isinstance(obj, str):
                data.append({"key": str(desc), "value": obj})
            elif isinstance(obj, int):
                data.append({"key": str(desc), "value": obj})
            elif isinstance(obj, float):
                data.append({"key": str(desc), "value": obj})
            else:
                print(type(obj))
        var = self.__result
        dataset = list()
        if isinstance(var, list):
            for i in range(0, len(var), 1):
                data = list()
                convert(var[i])
                dataset.append(data.copy())
        else:
            data = list()
            convert(var)
            dataset.append(data.copy())
        return dataset


# Beinhaltet alle Information welche für den REST Service Client benötigt werden
class RESTClient(URL, Result, CreationTime):
    def __init__(self):
        super(RESTClient, self).__init__()

    def __str__(self):
        return "RESTClient"

    def __repr__(self):
        return vars(self)


# Beinhaltet die Information wie oft Iteriert werden soll
# Integer
# spezialcase: Bei 0 wird endlos iteriert
class IterationLimit:
    def __init__(self):
        super(IterationLimit, self).__init__()
        self.__iterationLimit = 100

    def __str__(self):
        return "IterationLimit"

    def __repr__(self):
        return vars(self)

    def getIterationLimit(self):
        return self.__iterationLimit

    def setIterationLimit(self, value):
        if not isinstance(value, int):
            raise ValueError("IterationLimit is not Integer [{}]".format(type(value)))
        if value < 0:
            raise ValueError("IterationLimit cannot be smaller zero")
        self.__iterationLimit = value

    IterationLimit = property(getIterationLimit, setIterationLimit)


# Beinhaltet die Information wie oft noch iteriert werde soll bis alle Iterationen durch sind (Rekursiv)
# Integer
class IterationPosition:
    def __init__(self):
        super(IterationPosition, self).__init__()
        self.__iterationPosition = None

    def __str__(self):
        return "IterationPosition"

    def __repr__(self):
        return vars(self)

    def getIterationPosition(self):
        return self.__iterationPosition

    def setIterationPosition(self, value):
        if value is None:
            self.__iterationPosition = None
            return
        if not isinstance(value, int):
            raise ValueError("IterationPosition is not Integer [{}]".format(type(value)))
        if value < 0:
            raise ValueError("IterationPosition cannot be smaller zero")
        self.__iterationPosition = value

    IterationPosition = property(getIterationPosition, setIterationPosition)


# Beinhaltet die Information wie viele Sekunden nach einer Iteration gewartet werde soll
# Integer
class TimeOut:
    def __init__(self):
        super(TimeOut, self).__init__()
        self.__timeOut = 0

    def __str__(self):
        return "TimeOut"

    def __repr__(self):
        return vars(self)

    def getTimeOut(self):
        return self.__timeOut

    def setTimeOut(self, value):
        if not isinstance(value, int):
            raise ValueError("TimeOut is not Integer [{}]".format(type(value)))
        if value < 0:
            raise ValueError("TimeOut cannot be smaller zero")
        self.__timeOut = value

    TimeOut = property(getTimeOut, setTimeOut)


# Beinhaltet alle Information welche die Iterationen benötigt werden
# Funktion: Mindert die Anzahl der Iterationen nach einer ganzen Iteration
class Iteration(TimeOut, IterationLimit, IterationPosition):
    def __init__(self):
        super(Iteration, self).__init__()

    def __str__(self):
        return "Iteration"

    def __repr__(self):
        return vars(self)

    def nextIteration(self):
        if self.IterationLimit == 0:
            self.IterationPosition = None
            return
        if self.IterationPosition == 0:
            return
        self.IterationPosition -= 1

    def resetIterationPostition(self):
        if self.IterationLimit > 0:
            self.IterationPosition = self.IterationLimit -1
        elif self.IterationLimit == 0:
            self.IterationPosition = None

    def showInterationPosition(self):
        if self.IterationLimit == 0:
            return "endless"
        if self.IterationPosition is None:
            if self.IterationLimit == 0:
                return "endless"
            elif self.IterationLimit > 0:
                self.IterationPosition = self.IterationLimit - 1
        return self.IterationPosition + 1


# Beinhaltet die Information ob ein Job ausgeführt wird
# Boolean
class Execution:
    def __init__(self):
        super(Execution, self).__init__()
        self.__execution = False

    def __str__(self):
        return "Execution"

    def __repr__(self):
        return vars(self)

    def getExecution(self):
        return self.__execution

    def setExecution(self, value):
        if not isinstance(value, bool):
            raise ValueError("Execution is not Boolean [{}]".format(type(value)))
        self.__execution = value

    Execution = property(getExecution, setExecution)


# Beinhaltet alle Informationen die zur Ausführung eines Jobs benötigt werden
class Task(Execution, CreationTime, Iteration):
    def __init__(self):
        super(Task, self).__init__()

    def __str__(self):
        return "Task"

    def __repr__(self):
        return vars(self)


# Beinhaltet die Information wie ein Test Set heissen soll
# String
class TestSetName:
    def __init__(self):
        super(TestSetName, self).__init__()
        self.__testSetName = None

    def __str__(self):
        return "TestSetName"

    def __repr__(self):
        return vars(self)

    def getTestSetName(self):
        return self.__testSetName

    def setTestSetName(self, value):
        if not isinstance(value, str):
            raise ValueError("Test Set Name is not String [{}]".format(type(value)))
        self.__testSetName = value

    TestSetName = property(getTestSetName, setTestSetName)


# Beinhaltet alle Informationen über den Erfolg & Misserfolg der Test Cases eines Test Sets
# Liste mit Boolean Werten
# Funktion: Anzahl Test Case Resultate welche sich im Test Set befinden
# Funktion: Anzahl der Erfolgreichens Resultate der Test Cases in einem Test Set
# Funktion: Prozentualer Ateil der Erfolgreichen Test Case Resultate im Verhältnis zu den gesammten Resultaten
class TestCaseResult:
    def __init__(self):
        super(TestCaseResult, self).__init__()
        self.__testCaseResult = []

    def __str__(self):
        return "TestCaseResult"

    def __repr__(self):
        return vars(self)

    def getTestCaseResult(self):
        return self.__testCaseResult

    def setTestCaseResult(self, value):
        if not isinstance(value, bool):
            raise ValueError("Test Case Result is not Boolean [{}]".format(type(value)))
        self.__testCaseResult.append(value)

    TestCaseResult = property(getTestCaseResult, setTestCaseResult)

    def getTestCasesCount(self):
        return len(self.TestCaseResult)

    def getSuccessfulTestCasesCount(self):
        return sum(self.TestCaseResult)

    def getSuccessfulTestCasesInPercent(self):
        return int(self.getSuccessfulTestCasesCount() / self.getTestCasesCount() * 100)


# Beinhaltet alle Informationen welche für die Test Sets benötigt werden
# Funktion: Ausgabe des Test Sets Resultat als String
class TestSet(TestSetName, TestCaseResult):
    def __init__(self):
        super(TestSet, self).__init__()

    def __str__(self):
        return "TestSet"

    def __repr__(self):
        return vars(self)

    def result(self):
        return "{}, {} / {} [{}%], {}".format(self.TestSetName, self.getSuccessfulTestCasesCount(), self.getTestCasesCount(), self.getSuccessfulTestCasesInPercent(), str(self.TestCaseResult))


# Beinhaltet alle Resultate der einzelnen Test Sets
# Liste mit Objekten
# Funktion: Löscht alle Resultate
class TestResult:
    def __init__(self):
        super(TestResult, self).__init__()
        self.__testResult = []

    def __str__(self):
        return "TestResult"

    def __repr__(self):
        return vars(self)

    def getTestResult(self):
        return self.__testResult

    def setTestResult(self, value):
        self.__testResult.append(value)

    TestResult = property(getTestResult, setTestResult)

    def resetTestResult(self):
        self.__testResult = []


# Beinhaltet die Methoden / Use Cases um den Output (File) zu steuern
class FileProcessor:

    file = File()

    # File Einstellungen setzten
    @classmethod
    def setProperty(cls, path=None, name=None, fileType=None, fileOverwrite=None, fileExtention=None, runOnce=None):
        if path is not None:
            cls.file.FilePath = path
        if name is not None:
            cls.file.FileName = name
        if fileType is not None:
            cls.file.FileType = fileType
        if fileOverwrite is not None:
            cls.file.FileOverwrite = fileOverwrite
        if fileExtention is not None:
            cls.file.FileExtension = fileExtention
        if runOnce is not None:
            cls.file.RunOnce = runOnce

    # File Einstellungen lesen
    @classmethod
    def getProperties(cls, path=False, name=False, fileType=False, fileOverwrite=False, header=False, fileExtention=False, runOnce=False):
        if path:
            return cls.file.FilePath
        elif name:
            return cls.file.FileName
        elif fileType:
            return cls.file.FileType
        elif fileOverwrite:
            return cls.file.FileOverwrite
        elif header:
            return "<FileName>{f}</FileName><StartTime>{t}</StartTime>".format(f=cls.file.getFileLocation(),t=JobProcessor.getProperties(creationTime=True))
        elif fileExtention:
            return cls.file.FileExtension
        elif runOnce:
            return cls.file.RunOnce

    # Erstellt das File falls nicht vorhanden
    # Bei Overwrite False wird ein neuer Filename generiert
    @classmethod
    def createFile(cls):
        if cls.file.RunOnce:
            if not cls.file.FileOverwrite:
                cnt = 1
                while cls.checkFile():
                    cls.file.FileExtension = cnt
                    cnt += 1
            open(cls.file.getFileLocation(), "w")
        cls.file.RunOnce = False

    # Prüft ob ein File existiert
    @classmethod
    def checkFile(cls):
        return os.path.exists(cls.file.getFileLocation())

    # Schreibt den Inhalt in das File
    # Die erste Zeile ist die Header Zeile mit Datum und File Informationen
    # Die zweite Zeile ist die Titel Zeile mit allen Attributen aus dem Webservice Calls
    # Jede weitere Zeile beinhaltet die Datensätze aus dem Webservice Call
    @classmethod
    def write(cls):
        cls.createFile()
        storageStart = LogProcessor.getProperties(start=True)
        storageSize = LogProcessor.getProperties(size=True)
        text = "{}".format(LogProcessor.getProperties(delimiter=True))
        try:
            with open(cls.file.getFileLocation(), "w", encoding='utf-8') as f:
                #f.write(''.join(FileProcessor.getFileHeader()) + "\n")
                f.write(''.join(FileProcessor.getProperties(header=True)) + "\n")
                f.write(text.join(LogProcessor.getProperties(labels=True)) + "\n")
                for i in range(storageStart, storageStart + storageSize, 1):
                    f.write(text.join(LogProcessor.getLogEntity(i)) + "\n")
                f.close()
        except Exception as e:
            print(e)
            JobProcessor.stop()

    # Prozessor komplett zurücksetzten
    @classmethod
    def reset(cls):
        cls.file = File()


# Beinhaltet die Methoden / Use Cases um den Input entgegenzunehmen
class RESTClientProcessor:

    client = RESTClient()

    # File Einstellungen setzten
    @classmethod
    def setProperty(cls, url=None):
        if url is not None:
            cls.client.URL = url

    # File Einstellungen lesen
    @classmethod
    def getProperties(cls, url=False):
        if url:
            return cls.client.URL

    # Ruft den REST Service aus und speichert das Resultat
    @classmethod
    def call(cls):
        r = requests.get(cls.client.URL)
        cls.client.Result = json.loads(r.text)
        return cls.client.Result

    # Auslesen des Resultat
    # Variante 1) As it is ; Variante 2: Flachgedrückt (steuern über mode Attribut)
    @classmethod
    def getResult(cls, mode=None):
        if mode == "flat":
            return cls.client.flatten()
        return cls.client.Result

    # Prozessor komplett zurücksetzten
    @classmethod
    def reset(cls):
        cls.client = RESTClient()


# Beinhaltet die Methoden / Use Cases um den Input zu verarbeiten und ihn an den Output Prozessor weiterzugeben
class LogProcessor:

    log = Log()

    # File Einstellungen setzten
    @classmethod
    def setProperty(cls, size=None, delimiter=None, logType=None, logModus=None):
        if size is not None:
            cls.log.StorageRangeSize = size
        if delimiter is not None:
            cls.log.Delimiter = delimiter
        if logType is not None:
            cls.log.LogType = logType
        if logModus is not None:
            cls.log.LogModus = logModus

    # File Einstellungen lesen
    @classmethod
    def getProperties(cls, size=False, delimiter=False, start=False, logType=False, logModus=False, indexCount=False, labels=False):
        if size:
            return cls.log.StorageRangeSize
        elif delimiter:
            return cls.log.Delimiter
        elif start:
            return cls.log.StorageRangeStart
        elif logType:
            return cls.log.LogType
        elif logModus:
            return cls.log.LogModus
        elif indexCount:
            return len(cls.log.LogEntryIndex)
        elif labels:
            return cls.log.LogEntryIndex

    # Log Statement abrufen gemäss dem Log Modus
    @classmethod
    def getLogEntity(cls, pos):
        if cls.log.LogModus == LogModi(0).name:
            return cls.getLogEntityFull(pos)
        elif cls.log.LogModus == LogModi(1).name:
            return cls.getLogEntityIncremental(pos)
        elif cls.log.LogModus == LogModi(2).name:
            return cls.getLogEntityDifferential(pos)
        else:
            raise Exception("LogModus not definied while getLogEntity")

    # Log Statement mit allen Informationen unverarbeitet (full)
    @classmethod
    def getLogEntityFull(cls, pos):
        if pos in cls.log.StorageSpace:
            return cls.log.StorageSpace[pos].getLogEntryValues()
        return ['']

    # Log Statement mit allen Informationen im Vergleich zum ersten Eintrag (incremental)
    @classmethod
    def getLogEntityIncremental(cls, pos):
        if not pos in cls.log.StorageSpace:
            return ['']
        if cls.log.BenchMark is None:
            cls.log.BenchMark = cls.log.StorageSpace[pos].getLogEntryValues().copy()
            return cls.log.BenchMark
        if pos == 2:
            return cls.log.BenchMark
        return cls.compare2Benchmark(pos)

    # Log Statement mit allen Informationen im Vergleich zum letzten Eintrag (differential)
    @classmethod
    def getLogEntityDifferential(cls, pos):
        if not pos in cls.log.StorageSpace:
            return ['']
        if pos == 2:
            cls.log.BenchMark = cls.log.StorageSpace[pos].getLogEntryValues().copy()
            return cls.log.BenchMark
        request = cls.compare2Benchmark(pos)
        cls.log.BenchMark = cls.log.StorageSpace[pos].getLogEntryValues().copy()
        return request

    # Vergleich mit dem Benchmark
    @classmethod
    def compare2Benchmark(cls, pos):
        data = []
        Obj = cls.log.StorageSpace[pos].getLogEntryValues()
        for i in range(0, len(cls.log.BenchMark), 1):
            try:
                data.append(str(float(Obj[i]) - float(cls.log.BenchMark[i])))
            except:
                if i in [cls.log.LogEntryIndex.index("CreationTime"), cls.log.LogEntryIndex.index("LogLevel")]:
                    data.append(Obj[i])
                else:
                    data.append("-")
        return data

    # Umwandlung des REST Service Resultat (Flach) zu einem Log Statement
    # Erste Iteration: Datensätze in einer Antwort; zweite Iteration Daten in einem Datensatz
    # Neue Attribute werden im Index angelegt und auf alle Log Statements im Speicher verteilt
    @classmethod
    def createLogEntry(cls, input):
        for items in input:
            logEntry = LogEntry()
            logEntry.add(pos=cls.log.LogEntryIndex.index("CreationTime"), data=TimeProcessor.now())
            logEntry.add(pos=cls.log.LogEntryIndex.index("LogLevel"), data=cls.log.LogType)
            for item in items:
                if not item["key"] in cls.log.LogEntryIndex:
                    cls.log.LogEntryIndex = str(item["key"])
                    for i in cls.log.StorageSpace:
                        i.addNewIndex(str(cls.log.LogEntryIndex.index(item["key"])))
                logEntry.add(pos=cls.log.LogEntryIndex.index(item["key"]), data=item["value"])
            cls.log + logEntry
            cls.log.nextStoragePosition()

    # Prozessor komplett zurücksetzten
    @classmethod
    def reset(cls):
        cls.log = Log()


# Beinhaltet die Methoden / Use Cases um die Ausführung zu steuern
class JobProcessor:

    task = Task()

    # File Einstellungen setzten
    @classmethod
    def setProperty(cls, timeOut=None, iterationLimit=None, iterationPosition=None):
        if timeOut is not None:
            cls.task.TimeOut = timeOut
        if iterationLimit is not None:
            cls.task.IterationLimit = iterationLimit
        if iterationPosition:
            cls.task.IterationPosition = iterationPosition

    # File Einstellungen lesen
    @classmethod
    def getProperties(cls, timeOut=False, creationTime=False, iterationLimit=False, execution=False, iterationPosition=False):
        if timeOut:
            return cls.task.TimeOut
        elif creationTime:
            return cls.task.CreationTime
        elif iterationLimit:
            return cls.task.IterationLimit
        elif iterationPosition:
            return cls.task.IterationPosition
        elif execution:
            return cls.task.Execution

    # Job Initieren
    @classmethod
    def start(cls):
        cls.task.Execution = True
        cls.task.CreationTime = TimeProcessor.now()
        Timer(0, cls.execute).start()

    # Der Execution Loop
    @classmethod
    def execute(cls):
        while cls.task.Execution:
            #print(cls.task.IterationPosition)
            RESTClientProcessor.call()
            LogProcessor.createLogEntry(RESTClientProcessor.getResult(mode="flat"))
            FileProcessor.write()
            if cls.task.IterationLimit == 0:
                time.sleep(cls.task.TimeOut)
            elif cls.task.IterationPosition >= 1:
                cls.task.nextIteration()
                time.sleep(cls.task.TimeOut)
            else:
                cls.stop()
                cls.task.resetIterationPostition()

    # Job beenden oder abbrechen
    @classmethod
    def stop(cls):
        cls.task.Execution = False

    # Prozessor komplett zurücksetzten
    @classmethod
    def reset(cls):
        cls.stop()
        RESTClientProcessor.reset()
        LogProcessor.reset()
        FileProcessor.reset()
        cls.task = Task()


# Beinhaltet die Methoden / Use Cases um weitere Klassen mit dem Aktuellen Datum zu unterstützen
class TimeProcessor:

    # Rückgabe des aktuellen Datum Zeit im Format: YYYY.MM.DD HH:MM:SS:FFFFF
    @classmethod
    def now(cls):
        return '{:%Y.%m.%d %H:%M:%S:%f}'.format(datetime.datetime.now())

    # Rückgabe des aktuellen Datum Zeit im Format: YYYY
    @classmethod
    def getYear(cls):
        return '{:%Y}'.format(datetime.datetime.now())

    # Rückgabe des aktuellen Datum Zeit im Format: MM
    @classmethod
    def getMonth(cls):
        return '{:%m}'.format(datetime.datetime.now())

    # Rückgabe des aktuellen Datum Zeit im Format: DD
    @classmethod
    def getDay(cls):
        return '{:%d}'.format(datetime.datetime.now())


# Beinhaltet die Methoden / Use Cases um die Applikation zu testen
class TestProcessor:

    test = TestResult()

    # Testlauf starten / durchführen
    @classmethod
    def run(cls):
        JobProcessor.reset()
        cls.test.resetTestResult()
        cls.test.TestResult = cls.run__str__()
        cls.test.TestResult = cls.run__repr__()
        cls.test.TestResult = cls.run_setter_getter()
        cls.test.TestResult = cls.run_model_functions()
        cls.test.TestResult = cls.run_processor_properties()
        JobProcessor.reset()

    # Test Resultat abfragen
    @classmethod
    def result(cls):
        result = []
        for i in cls.test.TestResult:
            result.append(i.result())
        return result

    # Test Set
    @classmethod
    def run__str__(cls):
        set = TestSet()
        set.TestSetName = "__str__"
        # Test Case: RunOnce
        try:
            testcase = RunOnce()
            set.TestCaseResult = str(testcase) == "RunOnce"
        except:
            set.TestCaseResult = False
        # Test Case: FileExtension
        try:
            testcase = FileExtension()
            set.TestCaseResult = str(testcase) == "FileExtension"
        except:
            set.TestCaseResult = False
        # Test Case: FileOverwrite
        try:
            testcase = FileOverwrite()
            set.TestCaseResult = str(testcase) == "FileOverwrite"
        except:
            set.TestCaseResult = False
        # Test Case: FileType
        try:
            testcase = FileType()
            set.TestCaseResult = str(testcase) == "FileType"
        except:
            set.TestCaseResult = False
        # Test Case: FileName
        try:
            testcase = FileName()
            set.TestCaseResult = str(testcase) == "FileName"
        except:
            set.TestCaseResult = False
        # Test Case: FilePath
        try:
            testcase = FilePath()
            set.TestCaseResult = str(testcase) == "FilePath"
        except:
            set.TestCaseResult = False
        # Test Case: File
        try:
            testcase = File()
            set.TestCaseResult = str(testcase) == "File"
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangeStart
        try:
            testcase = StorageRangeStart()
            set.TestCaseResult = str(testcase) == "StorageRangeStart"
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangePosition
        try:
            testcase = StorageRangePosition()
            set.TestCaseResult = str(testcase) == "StorageRangePosition"
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangeSize
        try:
            testcase = StorageRangeSize()
            set.TestCaseResult = str(testcase) == "StorageRangeSize"
        except:
            set.TestCaseResult = False
        # Test Case: StorageSpace
        try:
            testcase = StorageSpace()
            set.TestCaseResult = str(testcase) == "StorageSpace"
        except:
            set.TestCaseResult = False
        # Test Case: Storage
        try:
            testcase = Storage()
            set.TestCaseResult = str(testcase) == "Storage"
        except:
            set.TestCaseResult = False
        # Test Case: Delimiter
        try:
            testcase = Delimiter()
            set.TestCaseResult = str(testcase) == "Delimiter"
        except:
            set.TestCaseResult = False
        # Test Case: LogEntryIndex
        try:
            testcase = LogEntryIndex()
            set.TestCaseResult = str(testcase) == "LogEntryIndex"
        except:
            set.TestCaseResult = False
        # Test Case: LogType
        try:
            testcase = LogType()
            set.TestCaseResult = str(testcase) == "LogType"
        except:
            set.TestCaseResult = False
        # Test Case: LogEntry
        try:
            testcase = LogEntry()
            set.TestCaseResult = str(testcase) == "LogEntry"
        except:
            set.TestCaseResult = False
        # Test Case: CreationTime
        try:
            testcase = CreationTime()
            set.TestCaseResult = str(testcase) == "CreationTime"
        except:
            set.TestCaseResult = False
        # Test Case: BenchMark
        try:
            testcase = BenchMark()
            set.TestCaseResult = str(testcase) == "BenchMark"
        except:
            set.TestCaseResult = False
        # Test Case: LogModus
        try:
            testcase = LogModus()
            set.TestCaseResult = str(testcase) == "LogModus"
        except:
            set.TestCaseResult = False
        # Test Case: ProcessModus
        try:
            testcase = ProcessModus()
            set.TestCaseResult = str(testcase) == "ProcessModus"
        except:
            set.TestCaseResult = False
        # Test Case: Log
        try:
            testcase = Log()
            set.TestCaseResult = str(testcase) == "Log"
        except:
            set.TestCaseResult = False
        # Test Case: URL
        try:
            testcase = URL()
            set.TestCaseResult = str(testcase) == "URL"
        except:
            set.TestCaseResult = False
        # Test Case: Result
        try:
            testcase = Result()
            set.TestCaseResult = str(testcase) == "Result"
        except:
            set.TestCaseResult = False
        # Test Case: RESTClient
        try:
            testcase = RESTClient()
            set.TestCaseResult = str(testcase) == "RESTClient"
        except:
            set.TestCaseResult = False
        # Test Case: IterationLimit
        try:
            testcase = IterationLimit()
            set.TestCaseResult = str(testcase) == "IterationLimit"
        except:
            set.TestCaseResult = False
        # Test Case: IterationPosition
        try:
            testcase = IterationPosition()
            set.TestCaseResult = str(testcase) == "IterationPosition"
        except:
            set.TestCaseResult = False
        # Test Case: Iteration
        try:
            testcase = Iteration()
            set.TestCaseResult = str(testcase) == "Iteration"
        except:
            set.TestCaseResult = False
        # Test Case: TimeOut
        try:
            testcase = TimeOut()
            set.TestCaseResult = str(testcase) == "TimeOut"
        except:
            set.TestCaseResult = False
        # Test Case: Execution
        try:
            testcase = Execution()
            set.TestCaseResult = str(testcase) == "Execution"
        except:
            set.TestCaseResult = False
        # Test Case: Task
        try:
            testcase = Task()
            set.TestCaseResult = str(testcase) == "Task"
        except:
            set.TestCaseResult = False
        # Test Case: TestSetName
        try:
            testcase = TestSetName()
            set.TestCaseResult = str(testcase) == "TestSetName"
        except:
            set.TestCaseResult = False
        # Test Case: TestCaseResult
        try:
            testcase = TestCaseResult()
            set.TestCaseResult = str(testcase) == "TestCaseResult"
        except:
            set.TestCaseResult = False
        # Test Case: TestSet
        try:
            testcase = TestSet()
            set.TestCaseResult = str(testcase) == "TestSet"
        except:
            set.TestCaseResult = False
        # Test Case: TestResult
        try:
            testcase = TestResult()
            set.TestCaseResult = str(testcase) == "TestResult"
        except:
            set.TestCaseResult = False
        return set

    # Test Set
    @classmethod
    def run__repr__(cls):
        set = TestSet()
        set.TestSetName = "__repr__"
        # Test Case: RunOnce
        try:
            testcase = RunOnce()
            testdata = False
            testcase.RunOnce = testdata
            set.TestCaseResult = testcase.__repr__() == {'_RunOnce__runOnce': False}
        except:
            set.TestCaseResult = False
        # Test Case: FileExtension
        try:
            testcase = FileExtension()
            testdata = 1
            testcase.FileExtension = testdata
            set.TestCaseResult = testcase.__repr__() == {'_FileExtension__fileExtension': 1}
        except:
            set.TestCaseResult = False
        # Test Case: FileOverwrite
        try:
            testcase = FileOverwrite()
            testdata = True
            testcase.FileOverwrite = testdata
            set.TestCaseResult = testcase.__repr__() == {'_FileOverwrite__fileOverwrite': True}
        except:
            set.TestCaseResult = False
        # Test Case: FileType
        try:
            testcase = FileType()
            testdata = ""
            testcase.FileType = testdata
            set.TestCaseResult = testcase.__repr__() == {'_FileType__fileType': ''}
        except:
            set.TestCaseResult = False
        # Test Case: FileName
        try:
            testcase = FileName()
            testdata = ""
            testcase.FileName = testdata
            set.TestCaseResult = testcase.__repr__() == {'_FileName__fileName': ''}
        except:
            set.TestCaseResult = False
        # Test Case: FilePath
        try:
            testcase = FilePath()
            testdata = ""
            testcase.FilePath = testdata
            set.TestCaseResult = testcase.__repr__() == {'_FilePath__filePath': ''}
        except:
            set.TestCaseResult = False
        # Test Case: File
        try:
            testcase = File()
            testdata = ""
            testcase.File = testdata
            set.TestCaseResult = testcase.__repr__() == {'_RunOnce__runOnce': True, '_FileExtension__fileExtension': None, '_FileOverwrite__fileOverwrite': True, '_FileType__fileType': 'csv', '_FileName__fileName': '%Y_%m_%d_REST_LOGGER', '_FilePath__filePath': './', 'File': ''}
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangeStart
        try:
            testcase = StorageRangeStart()
            testdata = 10
            testcase.StorageRangeStart = testdata
            set.TestCaseResult = testcase.__repr__() == {'_StorageRangeStart__storageRangeStart': 10}
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangePosition
        try:
            testcase = StorageRangePosition()
            testdata = 10
            testcase.StorageRangePosition = testdata
            set.TestCaseResult = testcase.__repr__() == {'_StorageRangePosition__storageRangePosition': 10}
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangeSize
        try:
            testcase = StorageRangeSize()
            testdata = 10
            testcase.StorageRangeSize = testdata
            set.TestCaseResult = testcase.__repr__() == {'_StorageRangeSize__storageRangeSize': 10}
        except:
            set.TestCaseResult = False
        # Test Case: StorageSpace
        try:
            testcase = StorageSpace()
            testdata = ""
            testcase.StorageSpace = testdata
            set.TestCaseResult = testcase.__repr__() == {'_StorageSpace__storageSpace': ''}
        except:
            set.TestCaseResult = False
        # Test Case: Storage
        try:
            testcase = Storage()
            testdata = ""
            testcase.Storage = testdata
            set.TestCaseResult = testcase.__repr__() == {'_StorageRangePosition__storageRangePosition': 2, '_StorageRangeStart__storageRangeStart': 2, '_StorageRangeSize__storageRangeSize': 100, '_StorageSpace__storageSpace': {}, 'Storage': ''}
        except:
            set.TestCaseResult = False
        # Test Case: Delimiter
        try:
            testcase = Delimiter()
            testdata = "&&"
            testcase.Delimiter = testdata
            set.TestCaseResult = testcase.__repr__() == {'_Delimiter__delimiter': '&&'}
        except:
            set.TestCaseResult = False
        # Test Case: LogEntryIndex
        try:
            testcase = LogEntryIndex()
            testdata = ""
            testcase.LogEntryIndex = testdata
            set.TestCaseResult = testcase.__repr__() == {'_LogEntryIndex__logEntryIndex': ['CreationTime', 'LogLevel', '']}
        except:
            set.TestCaseResult = False
        # Test Case: LogType
        try:
            testcase = LogType()
            testdata = 0
            testcase.LogType = testdata
            set.TestCaseResult = testcase.__repr__() == {'_LogType__logType': 0}
        except:
            set.TestCaseResult = False
        # Test Case: LogEntry
        try:
            testcase = LogEntry()
            testdata = ""
            testcase.LogEntry = testdata
            set.TestCaseResult = testcase.__repr__() == {'_LogEntry__logEntry': ''}
        except:
            set.TestCaseResult = False
        # Test Case: CreationTime
        try:
            testcase = CreationTime()
            testdata = "2021-11-30"
            testcase.CreationTime = testdata
            set.TestCaseResult = testcase.__repr__() == {'_CreationTime__creationTime': '2021-11-30'}
        except:
            set.TestCaseResult = False
        # Test Case: BenchMark
        try:
            testcase = BenchMark()
            testdata = ""
            testcase.BenchMark = testdata
            set.TestCaseResult = testcase.__repr__() == {'_BenchMark__benchMark': ''}
        except:
            set.TestCaseResult = False
        # Test Case: LogModus
        try:
            testcase = LogModus()
            testdata = 0
            testcase.LogModus = testdata
            set.TestCaseResult = testcase.__repr__() == {'_LogModus__logModus': 0}
        except:
            set.TestCaseResult = False
        # Test Case: ProcessModus
        try:
            testcase = ProcessModus()
            testdata = ""
            testcase.ProcessModus = testdata
            set.TestCaseResult = testcase.__repr__() == {'_BenchMark__benchMark': None, '_LogModus__logModus': 0, 'ProcessModus': ''}
        except:
            set.TestCaseResult = False
        # Test Case: Log
        try:
            testcase = Log()
            testdata = ""
            testcase.Log = testdata
            set.TestCaseResult = testcase.__repr__() == {'_LogType__logType': 1, '_BenchMark__benchMark': None, '_LogModus__logModus': 0, '_StorageRangePosition__storageRangePosition': 2, '_StorageRangeStart__storageRangeStart': 2, '_StorageRangeSize__storageRangeSize': 100, '_StorageSpace__storageSpace': {}, '_Delimiter__delimiter': '|', '_LogEntryIndex__logEntryIndex': ['CreationTime', 'LogLevel'], '_CreationTime__creationTime': '', 'Log': ''}
        except:
            set.TestCaseResult = False
        # Test Case: URL
        try:
            testcase = URL()
            testdata = "www.google.ch"
            testcase.URL = testdata
            set.TestCaseResult = testcase.__repr__() == {'_URL__url': 'www.google.ch'}
        except:
            set.TestCaseResult = False
        # Test Case: Result
        try:
            testcase = Result()
            testdata = ""
            testcase.Result = testdata
            set.TestCaseResult = testcase.__repr__() == {'_Result__result': ''}
        except:
            set.TestCaseResult = False
        # Test Case: RESTClient
        try:
            testcase = RESTClient()
            testdata = ""
            testcase.RESTClient = testdata
            set.TestCaseResult = testcase.__repr__() == {'_CreationTime__creationTime': '', '_Result__result': None, '_URL__url': 'http://api.openweathermap.org/data/2.5/weather?q=Basel&appid=22ba180b36721054905c21878f73dafc', 'RESTClient': ''}
        except:
            set.TestCaseResult = False
        # Test Case: IterationLimit
        try:
            testcase = IterationLimit()
            testdata = 100
            testcase.IterationLimit = testdata
            set.TestCaseResult = testcase.__repr__() == {'_IterationLimit__iterationLimit': 100}
        except:
            set.TestCaseResult = False
        # Test Case: IterationPosition
        try:
            testcase = IterationPosition()
            testdata = 99
            testcase.IterationPosition = testdata
            set.TestCaseResult = testcase.__repr__() == {'_IterationPosition__iterationPosition': 99}
        except:
            set.TestCaseResult = False
        # Test Case: Iteration
        try:
            testcase = Iteration()
            testdata = ""
            testcase.Iteration = testdata
            set.TestCaseResult = testcase.__repr__() == {'_IterationPosition__iterationPosition': None, '_IterationLimit__iterationLimit': 100, '_TimeOut__timeOut': 0, 'Iteration': ''}
        except:
            set.TestCaseResult = False
        # Test Case: TimeOut
        try:
            testcase = TimeOut()
            testdata = 1
            testcase.TimeOut = testdata
            set.TestCaseResult = testcase.__repr__() == {'_TimeOut__timeOut': 1}
        except:
            set.TestCaseResult = False
        # Test Case: Execution
        try:
            testcase = Execution()
            testdata = True
            testcase.Execution = testdata
            set.TestCaseResult = testcase.__repr__() == {'_Execution__execution': True}
        except:
            set.TestCaseResult = False
        # Test Case: Task
        try:
            testcase = Task()
            testdata = ""
            testcase.Task = testdata
            set.TestCaseResult = testcase.__repr__() == {'_IterationPosition__iterationPosition': None, '_IterationLimit__iterationLimit': 100, '_TimeOut__timeOut': 0, '_CreationTime__creationTime': '', '_Execution__execution': False, 'Task': ''}
        except:
            set.TestCaseResult = False
        return set

    # Test Set
    @classmethod
    def run_setter_getter(cls):
        set = TestSet()
        set.TestSetName = "setter_getter"
        # Test Case: RunOnce
        try:
            testdata = False
            testcase = RunOnce()
            testcase.RunOnce = testdata
            set.TestCaseResult = testcase.RunOnce == testdata
        except:
            set.TestCaseResult = False
        # Test Case: FileExtension
        try:
            testdata = 2
            testcase = FileExtension()
            testcase.FileExtension = testdata
            set.TestCaseResult = testcase.FileExtension == "_(2)"
        except:
            set.TestCaseResult = False
        # Test Case: FileOverwrite
        try:
            testdata = False
            testcase = FileOverwrite()
            testcase.FileOverwrite = testdata
            set.TestCaseResult = testcase.FileOverwrite == testdata
        except:
            set.TestCaseResult = False
        # Test Case: FileType
        try:
            testdata = "doc"
            testcase = FileType()
            testcase.FileType = testdata
            set.TestCaseResult = testcase.FileType == testdata
        except:
            set.TestCaseResult = False
        # Test Case: FileName
        try:
            testdata = "FileName"
            testcase = FileName()
            testcase.FileName = testdata
            set.TestCaseResult = testcase.FileName == "FileName"
        except:
            set.TestCaseResult = False
        # Test Case: FilePath
        try:
            testdata = "./Result"
            testcase = FilePath()
            testcase.FilePath = testdata
            set.TestCaseResult = testcase.FilePath == testdata
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangeStart
        try:
            testdata = 10
            testcase = StorageRangeStart()
            testcase.StorageRangeStart = testdata
            set.TestCaseResult = testcase.StorageRangeStart == testdata
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangePosition
        try:
            testdata = 9
            testcase = StorageRangePosition()
            testcase.StorageRangePosition = testdata
            set.TestCaseResult = testcase.StorageRangePosition == testdata
        except:
            set.TestCaseResult = False
        # Test Case: StorageRangeSize
        try:
            testdata = 55
            testcase = StorageRangeSize()
            testcase.StorageRangeSize = testdata
            set.TestCaseResult = testcase.StorageRangeSize == testdata
        except:
            set.TestCaseResult = False
        # Test Case: StorageSpace
        try:
            testdata = ['aaa', 'bbb', 'ccc']
            testcase = StorageSpace()
            testcase.StorageSpace = testdata
            set.TestCaseResult = testcase.StorageSpace == testdata
        except:
            set.TestCaseResult = False
        # Test Case: Delimiter
        try:
            testdata = "||"
            testcase = Delimiter()
            testcase.Delimiter = testdata
            set.TestCaseResult = testcase.Delimiter == testdata
        except:
            set.TestCaseResult = False
        # Test Case: LogEntryIndex
        try:
            testdata = "testcase"
            testcase = LogEntryIndex()
            testcase.LogEntryIndex = testdata
            set.TestCaseResult = testcase.LogEntryIndex == ['CreationTime', 'LogLevel', 'testcase']
        except:
            set.TestCaseResult = False
        # Test Case: LogType
        try:
            testdata = 1
            testcase = LogType()
            testcase.LogType = testdata
            set.TestCaseResult = testcase.LogType == "INFO"
        except:
            set.TestCaseResult = False
        # Test Case: LogEntry
        try:
            testdata = {"1": "Test"}
            testcase = LogEntry()
            testcase.LogEntry = testdata
            set.TestCaseResult = testcase.LogEntry == testdata
        except:
            set.TestCaseResult = False
        # Test Case: CreationTime
        try:
            testdata = "2021-11-30"
            testcase = CreationTime()
            testcase.CreationTime = testdata
            set.TestCaseResult = testcase.CreationTime == testdata
        except:
            set.TestCaseResult = False
        # Test Case: BenchMark
        try:
            testdata = {"1": "Test"}
            testcase = BenchMark()
            testcase.BenchMark = testdata
            set.TestCaseResult = testcase.BenchMark == testdata
        except:
            set.TestCaseResult = False
        # Test Case: LogModus
        try:
            testdata = 2
            testcase = LogModus()
            testcase.LogModus = testdata
            set.TestCaseResult = testcase.LogModus == "differential"
        except:
            set.TestCaseResult = False
        # Test Case: URL
        try:
            testdata = "http://api.openweathermap.org/data/2.5/weather?q=Basel&appid=22ba180b36721054905c21878f73dafc"
            testcase = URL()
            testcase.URL = testdata
            set.TestCaseResult = testcase.URL == testdata
        except:
            set.TestCaseResult = False
        # Test Case: Result
        try:
            testdata = '''{
                "userId": 1,
                "id": 1,
                "title": "delectus aut autem",
                "completed": false
            }'''
            testcase = Result()
            testcase.Result = testdata
            set.TestCaseResult = testcase.Result == testdata
        except:
            set.TestCaseResult = False
        # Test Case: IterationLimit
        try:
            testdata = 54
            testcase = IterationLimit()
            testcase.IterationLimit = testdata
            set.TestCaseResult = testcase.IterationLimit == testdata
        except:
            set.TestCaseResult = False
        # Test Case: IterationPosition
        try:
            testdata = 23
            testcase = IterationPosition()
            testcase.IterationPosition = testdata
            set.TestCaseResult = testcase.IterationPosition == testdata
        except:
            set.TestCaseResult = False
        # Test Case: TimeOut
        try:
            testdata = 44
            testcase = TimeOut()
            testcase.TimeOut = testdata
            set.TestCaseResult = testcase.TimeOut == testdata
        except:
            set.TestCaseResult = False
        # Test Case: Execution
        try:
            testdata = True
            testcase = Execution()
            testcase.Execution = testdata
            set.TestCaseResult = testcase.Execution == testdata
        except:
            set.TestCaseResult = False
        return set

    # Test Set
    @classmethod
    def run_model_functions(cls):
        set = TestSet()
        set.TestSetName = "model_functions"
        # File.getFileName()
        try:
            testcase = File()
            testcase.FileName = "test"
            testcase.FileType = "txt"
            set.TestCaseResult = testcase.getFileName() == "test.txt"
        except:
            set.TestCaseResult = False
        # File.getFileLocation()
        try:
            testcase = File()
            testcase.FileName = "TEST"
            testcase.FileType = "xls"
            testcase.FilePath = "./test/"
            set.TestCaseResult = testcase.getFileLocation() == "./test/TEST.xls"
        except:
            set.TestCaseResult = False
        # Storage.nextStoragePosition()
        try:
            testcase = Storage()
            testcase.StorageRangePosition = 5
            testcase.nextStoragePosition()
            set.TestCaseResult = testcase.StorageRangePosition == 6
        except:
            set.TestCaseResult = False
        # LogEntry.add()
        try:
            testcase = LogEntry()
            testcase.add(0, "data1")
            testcase.add(1, "data2")
            testcase.add(2, "data3")
            set.TestCaseResult = testcase.LogEntry == {0: 'data1', 1: 'data2', 2: 'data3'}
        except:
            set.TestCaseResult = False
        #LogEntry.getLogEntryValues()
        try:
            testcase = LogEntry()
            testcase.add(0, "data1")
            testcase.add(1, "data2")
            set.TestCaseResult = testcase.getLogEntryValues() == ['data1', 'data2']
        except:
            set.TestCaseResult = False
        #LogEntry.addNewIndex()
        try:
            testcase = LogEntry()
            testcase.add(0, "data1")
            testcase.add(1, "data2")
            testcase.addNewIndex(3)
            set.TestCaseResult = testcase.LogEntry == {0: 'data1', 1: 'data2', 3: ''}
        except:
            set.TestCaseResult = False
        #Result.flatten()
        try:
            input = {'coord': {'lon': 7.5733, 'lat': 47.5584},
             'weather': [{'id': 500, 'main': 'Rain', 'description': 'light rain', 'icon': '10n'}], 'base': 'stations',
             'main': {'temp': 276.3, 'feels_like': 276.3, 'temp_min': 274.08, 'temp_max': 278.47, 'pressure': 1017,
                      'humidity': 85}, 'visibility': 10000, 'wind': {'speed': 0.89, 'deg': 129, 'gust': 1.79},
             'rain': {'1h': 0.37}, 'clouds': {'all': 90}, 'dt': 1638294582,
             'sys': {'type': 2, 'id': 20828, 'country': 'CH', 'sunrise': 1638255346, 'sunset': 1638286885},
             'timezone': 3600, 'id': 2661604, 'name': 'Basel', 'cod': 200}
            output = [[{'key': '_coord_lon', 'value': 7.5733}, {'key': '_coord_lat', 'value': 47.5584},
              {'key': '_weather_id', 'value': 500}, {'key': '_weather_main', 'value': 'Rain'},
              {'key': '_weather_description', 'value': 'light rain'}, {'key': '_weather_icon', 'value': '10n'},
              {'key': '_base', 'value': 'stations'}, {'key': '_main_temp', 'value': 276.3},
              {'key': '_main_feels_like', 'value': 276.3}, {'key': '_main_temp_min', 'value': 274.08},
              {'key': '_main_temp_max', 'value': 278.47}, {'key': '_main_pressure', 'value': 1017},
              {'key': '_main_humidity', 'value': 85}, {'key': '_visibility', 'value': 10000},
              {'key': '_wind_speed', 'value': 0.89}, {'key': '_wind_deg', 'value': 129},
              {'key': '_wind_gust', 'value': 1.79}, {'key': '_rain_1h', 'value': 0.37}, {'key': '_clouds_all', 'value': 90},
              {'key': '_dt', 'value': 1638294582}, {'key': '_sys_type', 'value': 2}, {'key': '_sys_id', 'value': 20828},
              {'key': '_sys_country', 'value': 'CH'}, {'key': '_sys_sunrise', 'value': 1638255346},
              {'key': '_sys_sunset', 'value': 1638286885}, {'key': '_timezone', 'value': 3600},
              {'key': '_id', 'value': 2661604}, {'key': '_name', 'value': 'Basel'}, {'key': '_cod', 'value': 200}]]
            testcase = Result()
            testcase.Result = input
            set.TestCaseResult = testcase.flatten() == output
        except:
            set.TestCaseResult = False
        #Iteration.nextIteration()
        try:
            testcase = Iteration()
            testcase.IterationPosition = 100
            testcase.nextIteration()
            set.TestCaseResult = testcase.IterationPosition == 99
        except:
            set.TestCaseResult = False
        #Iteration.showIterationPosition
        try:
            testcase = Iteration()
            testcase.IterationPosition = 99
            set.TestCaseResult = testcase.showInterationPosition() == 100
        except:
            set.TestCaseResult = False
        return set

    # Test Set
    @classmethod
    def run_processor_properties(cls):
        set = TestSet()
        set.TestSetName = "processor_properties"
        # Test Case
        try:
            FileProcessor.setProperty(path="./Test/")
            set.TestCaseResult = FileProcessor.getProperties(path=True) == "./Test/"
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            FileProcessor.setProperty(name="REST_LOGGER")
            set.TestCaseResult = FileProcessor.getProperties(name=True) == "REST_LOGGER"
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            FileProcessor.setProperty(fileType="exe")
            set.TestCaseResult = FileProcessor.getProperties(fileType=True) == "exe"
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            FileProcessor.setProperty(fileOverwrite=False)
            set.TestCaseResult = FileProcessor.getProperties(fileOverwrite=True) == False
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            RESTClientProcessor.setProperty(
                url="http://api.openweathermap.org/data/2.5/weather?q=Basel&appid=22ba180b36721054905c21878f73dafc")
            set.TestCaseResult = RESTClientProcessor.getProperties(url=True) == "http://api.openweathermap.org/data/2.5/weather?q=Basel&appid=22ba180b36721054905c21878f73dafc"
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            LogProcessor.setProperty(size=11)
            set.TestCaseResult = LogProcessor.getProperties(size=True) == 11
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            LogProcessor.setProperty(delimiter=";")
            set.TestCaseResult = LogProcessor.getProperties(delimiter=True) == ";"
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            LogProcessor.setProperty(logType=1)
            set.TestCaseResult = LogProcessor.getProperties(logType=True) == "INFO"
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            LogProcessor.setProperty(logModus=1)
            set.TestCaseResult = LogProcessor.getProperties(logModus=True) == "incremental"
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            JobProcessor.setProperty(timeOut=10)
            set.TestCaseResult = JobProcessor.getProperties(timeOut=True) == 10
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            JobProcessor.setProperty(iterationLimit=12)
            set.TestCaseResult = JobProcessor.getProperties(iterationLimit=True) == 12
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            FileProcessor.setProperty(runOnce=True)
            set.TestCaseResult = FileProcessor.getProperties(runOnce=True) == True
        except:
            set.TestCaseResult = False
        # Test Case
        try:
            FileProcessor.setProperty(fileExtention=12)
            set.TestCaseResult = FileProcessor.getProperties(fileExtention=True) == "_(12)"
        except:
            set.TestCaseResult = False
        return set


# Beinhaltet die Methoden / Use Cases um die Applikation über die Command Line zu steuern
class CLIProcessor:
    exe = False

    @classmethod
    def main(cls):
        cls.exe = True
        text = '''
        ******************************************************************************
        Job Running: {}
        Remaining Iteration: {}

        Choose Action:
        ENTER = Update Status
        1 = Settings
        2 = Start / Stop Application
        3 = Rerun Application
        9 = Tests
        0 = Quit
        '''
        while cls.exe:
            print(text.format(
                JobProcessor.getProperties(execution=True),
                JobProcessor.task.showInterationPosition()
            ))
            i = input("Eingabe: ")
            # Quit
            if not i.isnumeric():
                pass
            elif int(i) == 0:
                cls.quit()
            # Settings
            elif int(i) == 1:
                cls.settings()
            # Run
            elif int(i) == 2:
                cls.run()
            # Rerun
            elif int(i) == 3:
                cls.rerun()
            # Test
            elif int(i) == 9:
                cls.test()
            else:
                pass

    @classmethod
    def quit(cls):
        JobProcessor.stop()
        cls.exe = False

    @classmethod
    def settings(cls):
        # File Path
        def path():
            try:
                print("File Path = {}\t(Mit ENTER überspringen)".format(FileProcessor.getProperties(path=True)))
                i = input("Eingabe: ")
                if not i == "":
                    FileProcessor.setProperty(path=str(i))
                    print("Eingabe gespeichert [Text]: {}".format(FileProcessor.getProperties(path=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                path()

        # File Name
        def fileName():
            try:
                print("File Name = {}\t(Mit ENTER überspringen)".format(FileProcessor.getProperties(name=True)))
                i = input("Eingabe [Text]: ")
                if not i == "":
                    FileProcessor.setProperty(name=str(i))
                    print("Eingabe gespeichert: {}".format(FileProcessor.getProperties(name=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                fileName()

        # File Typ
        def fileType():
            try:
                print("File Type = {}\t(Mit ENTER überspringen)".format(FileProcessor.getProperties(fileType=True)))
                i = input("Eingabe [Text]: ")
                if not i == "":
                    FileProcessor.setProperty(fileType=str(i))
                    print("Eingabe gespeichert: {}".format(FileProcessor.getProperties(fileType=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                fileType()

        # File Overwrite
        def fileOverwrite():
            try:
                print("File Overwrite = {}\t(Mit ENTER überspringen)".format(
                    FileProcessor.getProperties(fileOverwrite=True)))
                i = input("Eingabe [0;1]: ")
                if not i == "":
                    FileProcessor.setProperty(fileOverwrite=bool(int(i)))
                    FileProcessor.setProperty(runOnce=True)
                    print("Eingabe gespeichert: {}".format(FileProcessor.getProperties(fileOverwrite=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                fileOverwrite()

        # URL
        def url():
            try:
                print("URL = {}\t(Mit ENTER überspringen)".format(RESTClientProcessor.getProperties(url=True)))
                i = input("Eingabe [Text]: ")
                if not i == "":
                    RESTClientProcessor.setProperty(url=str(i))
                    settings = cls.getSettings()
                    JobProcessor.reset()
                    cls.setSettings(settings)
                    print("Eingabe gespeichert: {}".format(RESTClientProcessor.getProperties(url=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                url()

        # Log Size
        def size():
            try:
                print("Log Size = {}\t(Mit ENTER überspringen)".format(LogProcessor.getProperties(size=True)))
                i = input("Eingabe [Integer]: ")
                if not i == "":
                    LogProcessor.setProperty(size=int(i))
                    print("Eingabe gespeichert: {}".format(LogProcessor.getProperties(size=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                size()

        # Delmiter
        def delimiter():
            try:
                print("Delimiter = {}\t(Mit ENTER überspringen)".format(LogProcessor.getProperties(delimiter=True)))
                i = input("Eingabe [Text]: ")
                if not i == "":
                    LogProcessor.setProperty(delimiter=str(i))
                    print("Eingabe gespeichert: {}".format(LogProcessor.getProperties(delimiter=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                delimiter()

        # Log Type
        def logType():
            try:
                print("Log Type = {}\t(Mit ENTER überspringen)".format(LogProcessor.getProperties(logType=True)))
                i = input("Eingabe [0;1;2;3;4]: ")
                if not i == "":
                    LogProcessor.setProperty(logType=int(i))
                    print("Eingabe gespeichert: {}".format(LogProcessor.getProperties(logType=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                logType()

        # Log Modus
        def logModus():
            try:
                print("Log Modus = {}\t(Mit ENTER überspringen)".format(LogProcessor.getProperties(logModus=True)))
                i = input("Eingabe [0;1;2]: ")
                if not i == "":
                    LogProcessor.setProperty(logModus=int(i))
                    print("Eingabe gespeichert: {}".format(LogProcessor.getProperties(logModus=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                logModus()

        # Time Out
        def timeOut():
            try:
                print("Time Out = {}\t(Mit ENTER überspringen)".format(JobProcessor.getProperties(timeOut=True)))
                i = input("Eingabe [Integer]: ")
                if not i == "":
                    JobProcessor.setProperty(timeOut=int(i))
                    print("Eingabe gespeichert: {}".format(JobProcessor.getProperties(timeOut=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                timeOut()

        # Iteration Limit
        def interationLimit():
            try:
                print("Iteration limit = {}\t(Mit ENTER überspringen)".format(
                    JobProcessor.getProperties(iterationLimit=True)))
                i = input("Eingabe [Interger]: ")
                if not i == "":
                    JobProcessor.setProperty(iterationLimit=int(i))
                    JobProcessor.task.resetIterationPostition()
                    print("Eingabe gespeichert: {}".format(JobProcessor.getProperties(iterationLimit=True)))
            except Exception as e:
                print('\033[91m' + str(e) + '\033[0m')
                interationLimit()

        print("-----------------------------------------------------------------------------------------")
        path()
        print("-----------------------------------------------------------------------------------------")
        fileName()
        print("-----------------------------------------------------------------------------------------")
        fileType()
        print("-----------------------------------------------------------------------------------------")
        fileOverwrite()
        print("-----------------------------------------------------------------------------------------")
        url()
        print("-----------------------------------------------------------------------------------------")
        size()
        print("-----------------------------------------------------------------------------------------")
        delimiter()
        print("-----------------------------------------------------------------------------------------")
        logType()
        print("-----------------------------------------------------------------------------------------")
        logModus()
        print("-----------------------------------------------------------------------------------------")
        timeOut()
        print("-----------------------------------------------------------------------------------------")
        interationLimit()

    @classmethod
    def run(cls):
        try:
            if not JobProcessor.getProperties(execution=True):
                JobProcessor.start()
            elif JobProcessor.getProperties(execution=True):
                JobProcessor.stop()
        except Exception as e:
            print('\033[91m' + str(e) + '\033[0m')

    @classmethod
    def rerun(cls):
        try:
            settings = cls.getSettings()
            JobProcessor.reset()
            cls.setSettings(settings)
            cls.run()
        except Exception as e:
            print('\033[91m' + str(e) + '\033[0m')

    @classmethod
    def test(cls):
        try:
            settings = cls.getSettings()
            TestProcessor.run()
            print("\n".join(TestProcessor.result()))
            cls.setSettings(settings)
        except Exception as e:
            print('\033[91m' + str(e) + '\033[0m')

    @classmethod
    def getSettings(cls):
        settings = {}
        settings["path"] = FileProcessor.getProperties(path=True)
        settings["name"] = FileProcessor.getProperties(name=True)
        settings["fileType"] = FileProcessor.getProperties(fileType=True)
        settings["fileOverwrite"] = FileProcessor.getProperties(fileOverwrite=True)
        settings["url"] = RESTClientProcessor.getProperties(url=True)
        settings["size"] = LogProcessor.getProperties(size=True)
        settings["delimiter"] = LogProcessor.getProperties(delimiter=True)
        settings["logType"] = LogLevel[LogProcessor.getProperties(logType=True)].value
        settings["logModus"] = LogModi[LogProcessor.getProperties(logModus=True)].value
        settings["timeOut"] = JobProcessor.getProperties(timeOut=True)
        settings["iterationLimit"] = JobProcessor.getProperties(iterationLimit=True)
        return settings

    @classmethod
    def setSettings(cls, settings):
        FileProcessor.setProperty(path=settings["path"])
        FileProcessor.setProperty(name=settings["name"])
        FileProcessor.setProperty(fileType=settings["fileType"])
        FileProcessor.setProperty(fileOverwrite=settings["fileOverwrite"])
        RESTClientProcessor.setProperty(url=settings["url"])
        LogProcessor.setProperty(size=settings["size"])
        LogProcessor.setProperty(delimiter=settings["delimiter"])
        LogProcessor.setProperty(logType=LogLevel(settings["logType"]).value)
        LogProcessor.setProperty(logModus=LogModi(int(settings["logModus"])).value)
        JobProcessor.setProperty(timeOut=settings["timeOut"])
        JobProcessor.setProperty(iterationLimit=settings["iterationLimit"])


#-----------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    CLIProcessor.main()





