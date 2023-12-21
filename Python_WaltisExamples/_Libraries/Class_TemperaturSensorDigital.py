#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TemperaturSensorDigital.py
#
# Description: Class for DigitalTempeture Sensors
#
# https://pi-plates.com/daqc-users-guide/
# https://pi-plates.com/downloads/DAQCplate%20Quick%20Reference%20Guide.pdf
#
# http://pi-plates.com/relayplate-users-guide
# https://pi-plates.com/downloads/RELAYplateQuickReferenceGuide.pdf
#
# Autor: Walter Rothlin
#
# History:
# 10-Aug-2019	Initial Version
#
# ------------------------------------------------------------------

import piplates.DAQCplate as DAQC

class TemperaturSensorDigital:

    def __init__(self, name, plateAdr,pinNr, toleranz=1, vorkomma=10, nachkomma=2):
        self.name             = name
        self.plateAdr         = plateAdr
        self.pinNr            = pinNr
        self.toleranz         = toleranz
        self.vorkomma         = vorkomma
        self.nachkomma        = nachkomma
        self.pastTemp         = -300
        self.formatStr        = "{temperatur:"+str(self.vorkomma)+"."+str(self.nachkomma)+"f}"

    def getCurrentValue(self):
        currentTemp = DAQC.getTEMP(self.plateAdr, self.pinNr, 'c')
        return self.formatStr.format(temperatur=currentTemp)

    def getName(self):
        return self.name

    def getValueIfOverToleranz(self,returnValueIfNotChanged=False):
        currentTemp = DAQC.getTEMP(self.plateAdr,self.pinNr,'c')
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