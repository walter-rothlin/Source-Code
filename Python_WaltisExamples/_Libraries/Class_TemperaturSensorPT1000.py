#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TemperaturSensorPT1000.py
#
# Description: Class for PT1000-Tempeture Sensors
#
#
# Autor: Walter Rothlin
#
# History:
# 10-Aug-2019	Initial Version
#
# ------------------------------------------------------------------

import piplates.DAQCplate as DAQC

class TemperaturSensorPT1000:

    def __init__(self,name, plateAdr ,pinNr, Temp_P1 = 25, U_P1 = 3.196, Temp_P2 = 48, U_P2 = 3.736, toleranz=1,vorkomma=10,nachkomma=2):
        self.name             = name
        self.plateAdr         = plateAdr
        self.pinNr            = pinNr
        self.toleranz         = toleranz
        self.vorkomma         = vorkomma
        self.nachkomma        = nachkomma
        self.pastTemp         = -300
        self.formatStr        = "{temperatur:"+str(self.vorkomma)+"."+str(self.nachkomma)+"f}"
        self.Temp_P1          = Temp_P1
        self.U_P1             = U_P1
        self.Temp_P2          = Temp_P2
        self.U_P2             = U_P2

    def getCurrentValue(self):
        measure = DAQC.getADC(self.plateAdr,self.pinNr)
        a = (self.Temp_P2 - self.Temp_P1) / (self.U_P2 - self.U_P1)
        c = self.Temp_P2 - a * self.U_P2
        retVal = a * measure + c
        return retVal

    def getName(self):
        return self.name

    def getValueIfOverToleranz(self,returnValueIfNotChanged=False):
        # print(self.name + ": currentTemp:", currentTemp)
        # print(self.name + ": pastTemp   :", self.pastTemp)
        deltaTemp   = abs(abs(self.pastTemp - currentTemp) * 100 / self.pastTemp)
        # print(self.name + ": deltaTemp  :", deltaTemp)
        # print(self.name + ": Toleranz   :", self.toleranz)

        if (deltaTemp > self.toleranz):
            self.pastTemp = currentTemp
            retValStr = self.formatStr.format(temperatur=currentTemp)
            # print(self.name + ": RetVal    :", retValStr)
            self.valueChanged = True
            return retValStr
        else:
            self.valueChanged = False
            if (returnValueIfNotChanged):
               retValStr = self.formatStr.format(temperatur=currentTemp)
               return retValStr
            else:
               formatStringEmpty = "{t:"+str(self.vorkomma)+"s}"
               return  formatStringEmpty.format(t=" ")

    def hasTempratureChanged(self):
        return self.valueChanged 

    def toString(self):
        return self.name + "::" + self.getCurrentValue() + "°C"