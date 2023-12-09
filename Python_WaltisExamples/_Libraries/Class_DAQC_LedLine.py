#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Class_DAQC_LedLine.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Class_DAQC_LedLine.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 01-Dec-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
import piplates.DAQCplate as DAQC

class DAQC_LedLine:

    def __init__(self, name, plateAdr):
        self.name = name
        self.plateAdr = plateAdr

    def setLED(self,ledNrStartsAtZero):
        DAQC.setDOUTbit(self.plateAdr, ledNrStartsAtZero)

    def unsetLED(self,ledNrStartsAtZero):
        DAQC.clrDOUTbit(self.plateAdr, ledNrStartsAtZero)

    def clearAll(self):
        self.anzahlLedOn = 0
        for i in range(0, 5):
            DAQC.clrDOUTbit(self.plateAdr, i)

    def drawBalken(self,anzahlLed):
        anzahlLed = anzahlLed - 1
        if (anzahlLed <= 0):
            self.clearAll()
        else:
            self.anzahlLedOn = anzahlLed
            for i in range(0, anzahlLed+1):
                DAQC.setDOUTbit(self.plateAdr, i)

    def incBalken(self):
        if (self.anzahlLedOn < 6):
            self.anzahlLedOn = self.anzahlLedOn + 1
            DAQC.setDOUTbit(self.plateAdr, self.anzahlLedOn)

    def decBalken(self):
        if (self.anzahlLedOn >= 0):
            DAQC.clrDOUTbit(self.plateAdr, self.anzahlLedOn)
            self.anzahlLedOn = self.anzahlLedOn - 1

