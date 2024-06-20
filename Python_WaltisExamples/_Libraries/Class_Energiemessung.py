#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Energieberechnungen.py
#
# Description: Class to calculate power, energy ...
#
#
# Autor: Michael Federer
#
# History:
# 16-Sept-2019	Initial Version
#
# ------------------------------------------------------------------

class Energieberechnungen:

    def __init__(self, name, plateAdr ,pinNr, toleranz=1, vorkomma=10, nachkomma=2, voltage=0, current=0):
        self.name             = name
        self.plateAdr         = plateAdr
        self.pinNr            = pinNr
        self.toleranz         = toleranz
        self.vorkomma         = vorkomma
        self.nachkomma        = nachkomma
        self.voltage          = voltage
        self.current          = current

    def setCurrentVoltage(self, voltage):
        self.voltage(voltage)

    def setCurrentCurrent(self, current):
        self.current(current)

    def getCurrentPower(self):
        retVal = self.voltage * self.current
        return retVal

    def getName(self):
        return self.name

    def toString(self):
        return self.name + "::" + self.getCurrentPower() + "W"
