#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: IoT_Steckdose.py
#
# Description: Class control (on/off) and monitor (energy consumtion,...)
#
#
# Autor: Walter Rothlin
#
# History:
# 31-May-2022   Walter Rothlin	Initial Version
#
# ------------------------------------------------------------------
from waltisLibrary import *
from threading import Timer
import time

class IoT_Steckdose:
    """
    A class to encapsulate a current switch using a SHELLY IoT switch.

    Usage:

    """

    def __init__(self, name, ipAdr):
        self.__name  = name
        self.__ipAdr = ipAdr
        self.__switchedOn = False
        self.__power = 0
        self.__energy = 0
        self.__doMeasure = False

    def __str__(self):
        strDict = {"Steckdose:": self.__name}
        strDict.update({"IP": self.__ipAdr})
        strDict.update({"State": self.__switchedOn})
        strDict.update({"Power [kWh]": self.__power})
        strDict.update({"Energy [Ws]": self.__energy})

        return json.dumps(strDict, indent=4)

    def switchOn(self):
        self.__switchedOn = True

    def switchOff(self):
        self.__switchedOn = False

    def startMeasureEnergy(self):
        self.__doMeasure = True
        self.__timeInterval = 1
        self.__t = Timer(self.__timeInterval, self.__executeMeasurement, args=[self.__timeInterval])
        self.__t.start()
        print("Measure started....")

    def __executeMeasurement(self, timeInterval=1):
        while self.__doMeasure:
            self.__energy += 2
            time.sleep(timeInterval)

    def stopMeasureEnergy(self):
        self.__doMeasure = False
        self.__t.join()
        print("...measure stopped!")

    def getCurrentPower(self):
        return self.__power

    def getEnergyUsed(self):
        return self.__energy

if __name__ == '__main__':
    eineSteckdose = IoT_Steckdose("Standlampe", "168.107.1.222")
    print(eineSteckdose)
    eineSteckdose.switchOn()
    print(eineSteckdose)
    eineSteckdose.switchOff()
    print(eineSteckdose)

    eineSteckdose.startMeasureEnergy()
    print("Start Messung", eineSteckdose)
    time.sleep(10)
    eineSteckdose.stopMeasureEnergy()
    print("Stop Messung", eineSteckdose)

