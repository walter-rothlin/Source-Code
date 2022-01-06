# ------------------------------------------------------------------
# Name: WeatherLogger.py
#
# Description: Test-driven implementation of general class Logger
#
# Autor: Lorenzo L. Quadrelli
#
# History:
# 26-Nov-2021   Lorenzo L Q     Initial Version CLI
# 28-Nov-2021   Lorenzo L Q     Initial Version Logger & TestLogger
# 30-Nov-2021   Lorenzo L Q     Functions overworked. Reduced rendundance. Organized tests.
# ------------------------------------------------------------------
# Review-Results:
# Reference-Applikation:
#      + Funktioniert und User Input ist möglich
#      + User-Eingaben mit Vorschlägen/Auswahlmöglichkeiten
#      + Unsinnige User-Eingaben werden abgefangen
#
# Class Design und Implementation:
#      + Eigene Klasse has a csv (reuse)
#      + Notwendige (__eq__ __str__ ) Methoden  vorhanden
#      + __init__ wichtige parameter vorhanden (OnlyChanges, FixedSlices, New/Append,....) mit sinvollen Default values
#      + __init__ default valus nicht sprechend (nur ein Buchstaben)
#      + Alle Instance Variablen sind private / protected
#      + OnlyChanges funktioniert (ohne Toleranz)
#      + Ringbuffer implementiert (fixed Slices)
#      - Einigen Methoden könnten private sein (den Path on the fly zu ändern ist nicht sinnvoll)
#      + Exceptionhandling in der Klasse
#
# Test:
#      + Test implementiert mit statistics
#
# Note: 6.0
#
# Fragen:
#    Auf welcher Zeile wird das Objekt Ihrer Logger-Class kreiert?
#    Wann wird __init__ ihrer Klasse aufgerufen?
#    Wie kann ein Applikations-Entwickler seine eigenen AppId verwenden?
#    Wo wird unterschieden zwischen changesOnly True/False?
# ------------------------------------------------------------------
import os
import requests
import json
import time
from os import path
import csv
from datetime import datetime


class CLI:
    @staticmethod
    def get_varLoop(varType, text, allowed_dict=None, minimum=None):

        while True:
            try:
                if varType == 'str' and allowed_dict is not None:
                    toCheck = input(text).lower()

                    for i in allowed_dict.keys():
                        if toCheck in allowed_dict[i]:
                            return i

                    raise ValueError('Input is illegal!')

                elif varType == "float":
                    toCheck = float(input(text))

                    if toCheck < minimum:
                        raise ValueError('Value is smaller than allowed!')

                    return toCheck

            except ValueError as e:
                print((len(str(e))+4)*"=", "! " + str(e) + " !", (len(str(e))+4)*"=", sep="\n")

    @staticmethod
    def conc_url(apiKey, q="Uster", unit="metric", lang="de"):
        url = "https://api.openweathermap.org/data/2.5/weather"
        url += "?q=" + q + "&units=" + unit + "&lang=" + lang + "&appid=" + apiKey
        return url


class Logger:
    # import csv
    # import datetime

    __logLevels = ('DEBUG', 'INFO', 'WARNINGS', 'ERROR', 'CRITICAL')
    __allowedLogSett = {'a': 'append', 'w': 'overwrite'}
    __allowedLogStrat = {'s': 'standard', 'o': 'only changes'}
    __allowedFileType = ('txt', 'csv', 'log')

    def __init__(self, logfilename="log.csv", savePath="", logSetting="w", strategy="s", delimeter="|", maxLogs=100, columns=["data"]):

        self._filename = Logger._validateFileName(logfilename)

        # _________________ Validate path to save directory _________________
        if savePath != "":
            if not path.isdir(savePath):
                raise ValueError("Path to log directory not valid")
        # ____________________________________________________________________

        self._path = str(savePath)
        self.__fullpath = ""
        self._fullpathRefresh()                                       # concatenate to full path

        # _______________ Validate log strategy and setting __________________
        Logger._validateParameter(logSetting, Logger.__allowedLogSett.keys())
        self._logSetting = logSetting

        Logger._validateParameter(strategy, Logger.__allowedLogStrat.keys())
        self._strategy = strategy  # OnlyChanges or Standard
        # ____________________________________________________________________

        if len(delimeter) > 1:
            raise ValueError("Delimeter too long")
        self._delimeter = delimeter

        try:
            if int(maxLogs) < 1:
                raise ValueError
        except ValueError:
            raise ValueError("MaxLogs parameter not valid")

        self._maxLogs = maxLogs
        self._timestampFormat = '%d/%m/%Y %H:%M:%S'                # can be changed trough setter

        self._columns = ["timestamp", "level"] + columns           # as a list

        # _______________ Instance Variables for tracking __________________
        self.__linesLogged = 0
        self.__lastMsg = None
        self.__headerCreated = False
        # __________________________________________________________________

    def __str__(self):
        retStr =  f'Name:       {self._filename}\n'
        retStr += f'Full-path:  {self.__fullpath}\n'
        retStr += f'Setting:    {Logger.__allowedLogSett[self._logSetting]}\n'
        retStr += f'Strategy:   {Logger.__allowedLogStrat[self._strategy]}\n'
        retStr += f'Delimeter:  {self._delimeter}\n'
        retStr += f'Max Logs:   {self._maxLogs}\n'
        retStr += f'Columns:    {self._columns}'

        return retStr

    @property
    def filename(self):
        return self._filename

    @filename.setter
    def filename(self, newFilename):
        self._filename = Logger._validateFileName(newFilename)
        self._fullpathRefresh()

    @property
    def path(self):
        return self._path

    @path.setter
    def path(self, newPath):

        self._path = str(newPath)
        self._fullpathRefresh()

    @property
    def logSetting(self):
        return self._logSetting

    @logSetting.setter
    def logSetting(self, newSetting):
        if str(newSetting) in Logger.__allowedLogSett.keys():
            self._logSetting = newSetting
        else:
            raise ValueError("Not a valid Setting")

    @property
    def strategy(self):
        return self._strategy

    @strategy.setter
    def strategy(self, newStrategy):
        if str(newStrategy) in Logger.__allowedLogStrat.keys():
            self._strategy = newStrategy
        else:
            raise ValueError("Not a valid strategy")

    @property
    def delimeter(self):
        return self._delimeter

    @delimeter.setter
    def delimeter(self, newDelimeter):
        if len(newDelimeter) == 1:
            self._delimeter = newDelimeter
        else:
            raise ValueError("Delimeter can be only one symbol long")

    @property
    def maxLogs(self):
        return self._maxLogs

    @maxLogs.setter
    def maxLogs(self, newMax):
        try:
            if int(newMax) >= 1:
                self._maxLogs = int(newMax)
            else:
                raise ValueError    # Forces except block
        except ValueError:
            raise ValueError("Please use a valid integer")

    @property
    def timestampFormat(self):
        return self._timestampFormat

    @timestampFormat.setter
    def timestampFormat(self, newFormat):
        dateStr = datetime.now().strftime(newFormat)
        test = datetime.strptime(dateStr, newFormat)

        if str(test) == '1900-01-01 00:00:00':
            raise ValueError("Seems not a valid datetime Format")

        self._timestampFormat = newFormat


    @property
    def columns(self):
        return self._columns

    def _bootCheck(self):
        if path.exists(self.__fullpath) and self._logSetting == 'a':
            self._checkHeader()

        else:
            self._createHeader()

    def _checkHeader(self):
        # https://thispointer.com/python-read-csv-into-a-list-of-lists-or-tuples-or-dictionaries-import-csv-to-list/
        with open(self.__fullpath, 'r') as f:
            csv_reader = csv.reader(f)
            logList = list(csv_reader)
        if len(logList) <= 2:       # No Header yet
            self._createHeader()
        else:
            self.__linesLogged = len(logList) - 2       # Account for Headers
            self.__headerCreated = True

    def _createHeader(self):     # Does Create / Overwrite of file
        # https://www.geeksforgeeks.org/writing-csv-files-in-python/
        headerRows = [['<name>'+self.__fullpath+'</name>', '<timestamp>'+str(datetime.now().strftime(self._timestampFormat))+'</timestamp'],
                      [*self._columns]]

        with open(self.__fullpath, 'w') as f:
            dw = csv.writer(f, delimiter=self._delimeter)
            dw.writerows(headerRows)

        self.__headerCreated = True

    def _fullpathRefresh(self):     # Generates "full" path
        if self._path == "":
            self.__fullpath = self._filename
        else:
            if self._path[-1] == "/":
                self._path = self._path[:-1]

            if not path.isdir(self._path):
                raise ValueError("Path to non-existing directory")

            self.__fullpath = self._path + "/" + self._filename
        self.__headerCreated = False

    def _log2File(self, mode, row):

        if mode == 'single':
            with open(self.__fullpath, 'a') as f:
                dw = csv.writer(f, delimiter=self._delimeter)
                dw.writerow(row)
                self.__linesLogged += 1

        if mode == 'complete':
            # https://www.kite.com/python/answers/how-to-open-a-file-for-both-reading-and-writing-in-python
            with open(self.__fullpath, 'r+') as f:
                # ______________ ROLL LINES ON FILE ______________
                everyLine = list(csv.reader(f))  # load all rows
                # https://note.nkmk.me/en/python-list-clear-pop-remove-del/
                if self.__linesLogged == self._maxLogs:
                    print("INFO: Rolling activated -> deleting oldest row ::..")
                    del everyLine[2]
                else:
                    endIndex = self.__linesLogged - self._maxLogs + 3
                    print("INFO: Rolling activated -> deleting rows [2:" + str(endIndex) + "] ::..")
                    del everyLine[2:endIndex]  # Delete older Rows

                everyLine.append(row)

                # ______________ WRITE TO FILE ______________
                dw = csv.writer(f, delimiter=self._delimeter)
                f.seek(0)
                dw.writerows(everyLine)
                f.truncate()

            self.__linesLogged = self._maxLogs

    def postMessage(self, level='INFO', msg=["nothing"]):
        Logger._validateParameter(level, Logger.__logLevels)

        if not self.__headerCreated:            # Start boot check before first loop
            self._bootCheck()

        logMode = 'single'

        # ___________________________ Over Ringbuffer? ___________________________
        if self.__linesLogged >= self._maxLogs:
            logMode = 'complete'

        # ____________________________ Log Everything ____________________________
        if self._strategy == 's':
            self._log2File(logMode, [str(datetime.now().strftime(self._timestampFormat)), level, *msg])
            self.__lastMsg = msg

        # ___________________________ Log Only Changes ___________________________
        elif self._strategy == 'o':
            if self.__lastMsg is None or msg != self.__lastMsg:
                self._log2File(logMode, [str(datetime.now().strftime(self._timestampFormat)), level, *msg])
                self.__lastMsg = msg
        # ________________________________________________________________________

    @staticmethod
    def _validateParameter(par, allowed, errMsg="Illegal parameter"):
        if par not in allowed:
            raise ValueError(errMsg)

    @staticmethod
    def _validateFileName(toTest):
        toTest = str(toTest)
        if len(toTest) > 0:
            parts = toTest.split('.')
            if len(parts) == 1:
                if parts[0].isalnum():
                    return toTest + '.txt'
            else:
                if parts[0].isalnum() and parts[1] in Logger.__allowedFileType:
                    return parts[0] + '.' + parts[1]

        raise ValueError("Filename not allowed")


def testLogger():
    allTests = {'Inst1': False, 'Inst2': False, 'Inst3': False, 'Inst4': False, 'Inst5': False, 'Inst6': False,
                'Inst7': False, 'Inst8': False, 'Inst9': False, 'Set1': False, 'Set2': False, 'Set3': False,
                'Set4': False, 'Set5': False, 'Set6': False, 'Set7': False, 'Set8': False, 'Set9': False,
                'Set10': False, 'Set11': False, 'Set12': False, 'Set13': False, 'Set14': False, 'Set15': False,
                'Set16': False, 'Set17': False, 'Set18': False, 'Set19': False, 'Set20': False, 'Set21': False}

    print('_______________________________________________________')
    print('+      T E S T I N G   L O G G E R   C L A S S        +')
    print('_______________________________________________________')

    # ============== INSTANZIERUNG-TESTS ============== INSTANZIERUNG-TESTS ============== INSTANZIERUNG-TESTS =========
    # Inst1     | Standard Parameters
    testLog = Logger()
    expectedOutput = """Name:       log.csv
Full-path:  log.csv
Setting:    overwrite
Strategy:   standard
Delimeter:  |
Max Logs:   100
Columns:    ['timestamp', 'level', 'data']"""
    if str(testLog) == expectedOutput:
        allTests['Inst1'] = True

    # Inst2     | Allowed Parameters
    testLog = Logger(savePath="", logSetting="a", strategy="o", delimeter=";", maxLogs=12, columns=["random", "stuff"])
    expectedOutput = """Name:       log.csv
Full-path:  log.csv
Setting:    append
Strategy:   only changes
Delimeter:  ;
Max Logs:   12
Columns:    ['timestamp', 'level', 'random', 'stuff']"""
    if str(testLog) == expectedOutput:
        allTests['Inst2'] = True

    # Inst3     | Illegal Filename
    try:
        testLog = Logger(logfilename=" ")
    except ValueError:
        allTests['Inst3'] = True

    # Inst4     | Incomplete Filename
    testLog = Logger(logfilename="b")
    if testLog.filename == "b.txt":
        allTests['Inst4'] = True

    # Inst5     | Invalid Directory Path
    try:
        testLog = Logger(savePath="C:/IdontExist")
    except ValueError:
        allTests['Inst5'] = True

    # Inst6     | Invalid LogSetting
    try:
        testLog = Logger(logSetting='10')
    except ValueError:
        allTests['Inst6'] = True

    # Inst7     | Invalid Strategy Error Message
    try:
        testLog = Logger(strategy='random')
    except ValueError as e:
        allTests['Inst7'] = str(e) == "Illegal parameter"

    # Inst8     | Invalid Parameter for MaxLogs
    try:
        testLog = Logger(maxLogs=-10)
    except ValueError as e:
        allTests['Inst8'] = str(e) == "MaxLogs parameter not valid"

    # Inst9     | Invalid Parameter for Delimeter
    try:
        testLog = Logger(delimeter='//')
    except ValueError:
        allTests['Inst9'] = True

    # ========== PROPERTY-TESTS ========== PROPERTY-TESTS ========== PROPERTY-TESTS ========== PROPERTY-TESTS ==========

    testLog = Logger()

    # Set1      | Set a new file name
    testLog.filename = 'str'
    if testLog.filename == 'str.txt' and testLog.path == '':
        allTests['Set1'] = True

    # Set2      | Set inavild file name (type)
    try:
        testLog.filename = 'invalid.json'
    except ValueError:
        allTests['Set2'] = True

    # Set3      | Set inavild file name (empty)
    try:
        testLog.filename = ''
    except ValueError:
        allTests['Set3'] = True

    # Set4      | Set inavild file name (non alpha-numeric)
    try:
        testLog.filename = ' '
    except ValueError:
        allTests['Set4'] = True

    # Set5      | Set new save folder
    try:
        testLog.path = str(os.getcwd())
    except:
        pass
    else:
        allTests['Set5'] = True

    # Set6      | Set invalid save folder
    try:
        testLog.path = 'random/stuff/'
    except ValueError:
        allTests['Set6'] = True

    # Set7      | Set a new log setting
    testLog.logSetting = 'a'
    if testLog.logSetting == 'a':
        allTests['Set7'] = True

    # Set8      | Set an invalid log setting
    try:
        testLog.logSetting = 'pr'
    except ValueError:
        allTests['Set8'] = True

    # Set9      | Set a new strategy
    testLog.strategy = 'o'
    if testLog.strategy == 'o':
        allTests['Set9'] = True

    # Set10     | Set an invalid strategy
    try:
        testLog.strategy = 'oops'
    except ValueError:
        allTests['Set10'] = True

    # Set11     | Set a new delimeter
    testLog.delimeter = '*'
    if testLog.delimeter == '*':
        allTests['Set11'] = True

    # Set12     | Set an invalid delimeter
    try:
        testLog.delimeter = '_-_'
    except ValueError:
        allTests['Set12'] = True

    # Set13     | Set a new maxLogs int
    testLog.maxLogs = 15
    if testLog.maxLogs == 15:
        allTests['Set13'] = True

    # Set14     | Set a new maxLogs string
    testLog.maxLogs = '19'
    if testLog.maxLogs == 19:
        allTests['Set14'] = True

    # Set15     | Set an invalid maxLogs
    try:
        testLog.maxLogs = -0.99
    except ValueError:
        allTests['Set15'] = True

    # Set16     | Set an invalid str maxLogs
    try:
        testLog.maxLogs = '_-_'
    except ValueError:
        allTests['Set16'] = True

    # Set17     | Access Columns
    x = testLog.columns
    if x == ["timestamp", "level", "data"]:
        allTests['Set17'] = True

    # Set18     | Try overwriting columns
    try:
        testLog.columns = ["not", "gonna", "work"]
    except AttributeError:
        allTests['Set18'] = True

    # Set19     | Try posting message on invalid level
    try:
        testLog.postMessage(level='TESTS')
    except ValueError:
        allTests['Set19'] = True

    # Set20     | Try setting a new timestamp format
    try:
        testLog.timestampFormat = '%b %d %Y %I:%M%p'
    except ValueError:
        pass
    else:
        allTests['Set20'] = True

    # Set21     | Try setting an invalid timestamp format
    try:
        testLog.timestampFormat = 'Should not work'
    except ValueError:
        allTests['Set21'] = True

    # _________________________________________ CALCULATION OF TEST RESULTS ____________________________________________
    totalTestsNr = len(allTests.keys())
    failedTestsNr = 0

    for i in allTests.values():
        if i is False:
            failedTestsNr += 1

    passedTestsNr = totalTestsNr - failedTestsNr
    passedQuote = passedTestsNr / totalTestsNr

    # __________________________________________ VISUAL OVERVIEW OF TESTS ______________________________________________
    OverviewTestsStr =   '_______________________________\n'
    OverviewTestsStr += f'|   {passedTestsNr:3} / {totalTestsNr:3} Tests Passed    |\n'
    OverviewTestsStr +=  '_______________________________\n'
    OverviewTestsStr += f'|    Passing Rate: {(passedQuote*100):6.2f}%    |\n'
    OverviewTestsStr += '_______________________________\n'

    if failedTestsNr > 0:
        OverviewTestsStr += '|    List of failed tests:    |\n'
        OverviewTestsStr += '|                             |\n'
        for i in allTests.keys():
            if not allTests[i]:
                OverviewTestsStr += f'| # {i:6}                    |\n'
        OverviewTestsStr += '_______________________________\n'

    print(OverviewTestsStr)


def main():

    # ======================================= GET PARAMETERS FOR WEATHER API ===========================================
    # Polling Time
    runTime = CLI.get_varLoop(
        varType="float",
        text="Polling-Time in s. (min 1) \n-> ",
        minimum=1.0
    )

    # Place
    place = CLI.get_varLoop(
        varType="str",
        text="Select Place:    [U]ster     [Z]ürich    [B]ern \n-> ",
        allowed_dict={"Uster": ["u", "uster"], "Zurich": ["z", "zurich", "zürich"], "Bern": ["b", "bern"]}
    )

    # Unit Type
    scale = CLI.get_varLoop(
        varType="str",
        text="Select Unit:    [M]etric     [I]mperial \n-> ",
        allowed_dict={"metric": ["m", "metric"], "imperial": ["i", "imperial"]}
    )

    # Language
    language = CLI.get_varLoop(
        varType="str",
        text="Select Language:    [D]eutsch     [E]nglish \n-> ",
        allowed_dict={"de": ["d", "deutsch"], "en": ["e", "english"]}
    )

    #  ========= API SETUP =============================================
    key = "08cc96ba7656cce57df07b8ba26166a3"
    link = CLI.conc_url(apiKey=key, q=place, unit=scale, lang=language)
    # ==================================================================

    # ========================================== GET PARAMETERS FOR LOGGER =============================================
    weather_log = Logger(maxLogs=20, columns=["temp", "pressure", "humidity", "cloud"])

    print("____________________________________")
    print("vvvvv STANDARD LOGGER SETTINGS vvvvv\n")
    print(weather_log)
    print("____________________________________")

    standLog = CLI.get_varLoop(
        varType="str",
        text="Use standard log settings?:    [Y]es     [N]o \n-> ",
        allowed_dict={"y": ["y", "yes"], "n": ["n", "no"]}
    )

    if standLog == "n":
        while True:         # Get File Name
            try:
                weather_log.filename = str(input("Enter new file name (alphanumeric only). E.g.: log.txt \n-> "))
            except ValueError as e:
                print((len(str(e))+4)*"=", "! " + str(e) + " !", (len(str(e))+4)*"=", sep="\n")
            else:
                break

        while True:         # Get Path
            try:
                weather_log.path = str(input(
                    """Insert a valid path (to a directory) to save the file to. Leave empty for local \n-> """))
            except ValueError as e:
                print((len(str(e))+4)*"=", "! " + str(e) + " !", (len(str(e))+4)*"=", sep="\n")
            else:
                break

        while True:         # Get LogSetting
            try:
                weather_log.logSetting = str(input("Select the logging mode:    [A]ppend       [W]rite/Overwrite \n-> ")).lower()
            except ValueError as e:
                print((len(str(e))+4)*"=", "! " + str(e) + " !", (len(str(e))+4)*"=", sep="\n")
            else:
                break

        while True:         # Get Strategy
            try:
                weather_log.strategy = str(input("Select logging strategy to use:  [O]nlyChanges   [S]tandard \n-> ")).lower()
            except ValueError as e:
                print((len(str(e))+4)*"=", "! " + str(e) + " !", (len(str(e))+4)*"=", sep="\n")
            else:
                break

        while True:         # Get Delimeter
            try:
                weather_log.delimeter = str(input("Which symbol should be used as a delimeter? \n-> "))
            except ValueError as e:
                print((len(str(e))+4)*"=", "! " + str(e) + " !", (len(str(e))+4)*"=", sep="\n")
            else:
                break

        while True:         # Get MaxLogs
            try:
                weather_log.maxLogs = str(input("How many logs before rolling? \n-> "))
            except ValueError as e:
                print((len(str(e))+4)*"=", "! " + str(e) + " !", (len(str(e))+4)*"=", sep="\n")
            else:
                break

    # --------------- API LOOP --------------- API LOOP --------------- API LOOP --------------- API LOOP --------------
    while True:
        try:
            jsonResponse = json.loads(requests.get(link).text)
            temp = str(round(float(jsonResponse['main']['temp']), 1))
            pressure = str(jsonResponse['main']['pressure'])
            humidity = str(jsonResponse['main']['humidity'])
            cloud = str(jsonResponse['weather'][0]['description'])
            print('*', temp, pressure, humidity, cloud)
            weather_log.postMessage(msg=[temp, pressure, humidity, cloud])  # Log Data
            time.sleep(runTime)

        except KeyboardInterrupt:
            print('..:: Process Exited!')
            weather_log.postMessage(level='CRITICAL', msg=["Feed Interrupted", "Keyboard Interrupt"])
            break

        except KeyError as e:
            print('..:: Problem with the API! Process Exited!')
            weather_log.postMessage(level='CRITICAL', msg=["Feed Interrupted", str(e)])
            break


if __name__ == "__main__":

    testLogger()
    main()
