#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_WR_Logger.py
#
# Description: Manages a Logfiles
#
# Autor: Walter Rothlin
#
# History:
# 20-Apr-2021	Initial Version
# 13-Nov-2023   Refactoring with HBU students
#
# ------------------------------------------------------------------

from waltisLibrary import *

class WR_Logger:
    """
    WR_Logger Class:


    """
    def __init__(self, fName='./logger.txt',
                 delimiter="|",
                 headerStr=None,
                 titleStr="Title",
                 withTimeStamp=True,
                 withLevel=True,
                 doVerbal=True,
                 timeFormatString="nice",
                 onlyChanges=False,
                 ringbufferSize=-1,
                 cWidth_TimeStamp = 22,
                 cWidth_Level = 8):
        self.__fName = fName
        self.__delimiter = delimiter
        self.__withTimeStamp = withTimeStamp
        self.__withLevel = withLevel
        self.__doVerbal = doVerbal
        self.__timeFormatString = timeFormatString
        self.__onlyChanges = onlyChanges
        self.__ringbufferSize = ringbufferSize
        self.__cWidth_TimeStamp = cWidth_TimeStamp
        self.__cWidth_Level = cWidth_Level
        self.__countOfLines = 0
        self.lastValues = ""
        if headerStr is None:
            headerStr = "# <Name>" + fName + "</Name>"

        preTitleStr = ""
        if self.__withTimeStamp:
            preTitleStr = ("{le:" + str(self.__cWidth_TimeStamp) + "s}").format(le="Timestamp") + self.__delimiter
        if self.__withLevel:
            preTitleStr += ("{le:" + str(self.__cWidth_Level) + "s}").format(le="Level") + self.__delimiter
        titleStr = preTitleStr + titleStr

        createNewFile = True
        if headerStr != "":
            self.addLogEntry(headerStr, doAppend=False, isHeader=True)
            createNewFile = True
        if titleStr != "":
            self.addLogEntry(titleStr, doAppend=createNewFile, isHeader=True)

    # toString()
    # ----------
    def __str__(self):
        retStr =  "fName             :" + self.__fName                  + "\n"
        retStr += "delimiter         :" + self.__delimiter              + "\n"
        retStr += "withTimeStamp     :" + str(self.__withTimeStamp)     + "\n"
        retStr += "withLevel         :" + str(self.__withLevel)         + "\n"
        retStr += "doVerbal          :" + str(self.__doVerbal)          + "\n"
        retStr += "onlyChanges       :" + str(self.__onlyChanges)       + "\n"
        retStr += "useRingbufferSize :" + str(self.__ringbufferSize)    + "\n"
        retStr += "Count of Lines    :" + str(self.__countOfLines) + "\n"
        return retStr

    # overload == (equal to) operator
    # -------------------------------
    def __eq__(self, anOtherLogger):
        return self.__fName == anOtherLogger.__fName

    # main business methods()
    # -----------------------
    def addLogEntry(self, aLogEntry, level="INFO", doAppend=True, isHeader=False):
        valueIsTheSame = False
        if self.lastValues == aLogEntry:
            valueIsTheSame = True
        self.lastValues = aLogEntry
        preEntry = ""
        if isHeader == False:
            if self.__withTimeStamp:
                preEntry = ("{le:" + str(self.__cWidth_TimeStamp) + "s}").format(le=getTimestamp(formatString=self.__timeFormatString)) + self.__delimiter
            if self.__withLevel:
                preEntry += ("{le:" + str(self.__cWidth_Level) + "s}").format(le=level) + self.__delimiter
        aLogEntry = preEntry + aLogEntry
        if self.__doVerbal:
            print(aLogEntry, end="")
        if not (self.__onlyChanges and valueIsTheSame):
            if self.__doVerbal:
                if not isHeader:
                    if self.__onlyChanges:
                        print("     Changed!", end="")
            if doAppend == False:
                f = open(self.__fName, "w")
            else:
                f = open(self.__fName, "a")
            self.__countOfLines += 1
            f.write(aLogEntry + "\n")
            f.close()

        # Ringbuffer
        # ----------
        if self.__ringbufferSize > 0:
            fileSize = File_getCountOfLines(self.__fName)
            if fileSize > self.__ringbufferSize:
                File_deleteLines(self.__fName, deleteLineFrom=3, deleteLineTo=(fileSize-self.__ringbufferSize), verbal=True)

        if self.__doVerbal:
            print()


if __name__ == '__main__':
    data_logger_1 = WR_Logger()

    data_logger_1.addLogEntry('12.3|14.5|sun shine')
