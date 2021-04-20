#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Test_Kaeltemaschine.py
#
# Description: 
#
# Destination: ~/Documents/BZU_Code/ExamplesPython/KaeltemacherCode/Version_2019_06_24
# Autor: Walter Rothlin
#
# History:
# 28-Jun-2019	Initial Version
#
# ------------------------------------------------------------------

import math
import time
import datetime
import re
import piplates.DAQCplate as DAQC

from Class_KaelteMacherMaschine import *
from waltisLibrary              import *

print("Argument List:", str(sys.argv),"(",len(sys.argv),")")
inTestMode = False
testMode   = ""
if (len(sys.argv) > 1):
    inTestMode = True
    testMode   = str(sys.argv)
    time.sleep(4)


hsrKaelteMaschine = KaelteMacherMaschine(simulate = inTestMode)

# --------------------------------------------------
# main Loop
# --------------------------------------------------
doLoop            = True
hsrKaelteMaschine.setHeartbeatInicator(True)
while (doLoop):
    VT52_cls_home()
    print(hsrKaelteMaschine.toString())
    print()
    print("  Events")
    print("  ======")
    print("  1: Set Speed Compressor")
    print("  2: Set Fan Speed")
    print("  3: Set Water Pump on/off")
    print("  4: Set Mixing Valve")
    print("  5: Set ShutOff Valve on/off")
    print()
    print("  9: Not Aus")
    print()
    print("  0: Schluss")


    antwort = input("\n  Wähle:")
    hsrKaelteMaschine.toggleHeartbeatInicator()
    if (antwort == "1"):
        VT52_cls_home()
        print("Set Compressor Speed")
        compNr = int(input("Compressor Nr [1,2]:"))
        newSpeed = float(input("Speed [%]: "))
        newState = input("State [On,Off]: ")
        hsrKaelteMaschine.setSpeedComp(compNr,newSpeed)
        if (newState == "On"):
            hsrKaelteMaschine.setComp_On(compNr,True)
        if (newState == "Off"):
            hsrKaelteMaschine.setComp_On(compNr,False)
        halt("Continue?")

    if (antwort == "2"):
        VT52_cls_home()
        print("Set Fan Speed")
        newSpeed = int(input("Speed [0,1,2]: "))
        if (newSpeed == 0):
            hsrKaelteMaschine.setFanSpeed(False,False)
        elif (newSpeed == 1):
            hsrKaelteMaschine.setFanSpeed(True,False)
        elif (newSpeed == 2):
            hsrKaelteMaschine.setFanSpeed(True,True)
        halt("Continue?")

    if (antwort == "3"):
        VT52_cls_home()
        print("Set Water Pump on/off")
        newState = input("State [On,Off]: ")
        if (newState == "On"):
            hsrKaelteMaschine.setWaterPump_On(True)
        if (newState == "Off"):
            hsrKaelteMaschine.setWaterPump_On(False)
        halt("Continue?")

    if (antwort == "4"):
        VT52_cls_home()
        print("Set Mixing Valve")
        newPosition = float(input("Openess [%]: "))
        hsrKaelteMaschine.setMixingValve(newPosition)
        halt("Continue?")

    if (antwort == "5"):
        VT52_cls_home()
        print("Set ShutOff Valve on/off")
        newState = input("State [Closed,Opend]: ")
        if (newState == "Opend"):
            hsrKaelteMaschine.setShutOffValveToOpen(True)
        if (newState == "Closed"):
            hsrKaelteMaschine.setShutOffValveToOpen(False)
        halt("Continue?")

    if (antwort == "9"):
        hsrKaelteMaschine.doEmergencyStop()

    if (antwort == "0"):
        doLoop = False

hsrKaelteMaschine.doEmergencyStop()

    # Fan
    ### hsrKaelteMaschine.setFanSpeed(compressor_1_ready,compressor_2_ready)