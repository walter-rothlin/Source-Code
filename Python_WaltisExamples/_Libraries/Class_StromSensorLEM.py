#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: StromSensorLEM.py
#
# Description: Class for current converter LEM LA 100-P with R = 100 Ohm
#
#
# Autor: Michael Federer
#
# History:
# 16-Sept-2019	Initial Version
#
# ------------------------------------------------------------------

import piplates.DAQCplate as DAQC

class StromSensorLEM:

    def __init__(self,name, plateAdr ,pinNr, toleranz=1, vorkomma=10, nachkomma=2, offset=-0):
        self.name             = name
        self.plateAdr         = plateAdr
        self.pinNr            = pinNr
        self.toleranz         = toleranz
        self.vorkomma         = vorkomma
        self.nachkomma        = nachkomma
        self.offset           = offset

    def getCurrentValue(self):
        measure = DAQC.getADC(self.plateAdr,self.pinNr)
        # 5V = 100A <=> 1V = 20A
        retVal = (measure * 20) + self.offset
        return retVal

    def getName(self):
        return self.name

    def toString(self):
        return self.name + "::" + self.getCurrentValue() + "A"
