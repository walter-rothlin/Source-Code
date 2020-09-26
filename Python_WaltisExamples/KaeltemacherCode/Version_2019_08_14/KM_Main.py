#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KM_Main.py
#
# Description: Hauptsteurung der Kaelteanlage.
#
# Destination: ~/Documents/BZU_Code/ExamplesPython/KaeltemacherCode/Version_2019_06_24
# Autor: Walter Rothlin
#
# Used Libraries:
# https://pypi.org/project/simple-pid/       pip3 install simple-pid

# History:
# 24-Apr-2019	Initial Version
# 07-Jun-2019	2nd Version
# 26-Jun-2019	Reviewed Version
#
# ------------------------------------------------------------------

import math
import time
import datetime
import re
import piplates.DAQCplate as DAQC

from threading                  import Timer
from simple_pid                 import PID

from Class_Hysterese            import *
from Class_Tiefpass             import *
from Class_IncDec               import *
from Class_Verdichter           import *
from Class_KaelteMacherMaschine import *
from Class_TimerState           import *
from Class_WR_Logfile           import *
from waltisLibrary              import *

# Functions
# --------------------------------------------------
def f1x(vorhandeneEnergie):
    calculatedDrehzahl = vorhandeneEnergie * 2
    if (calculatedDrehzahl > 100):
        return 100
    if (calculatedDrehzahl < minVerdichterLeistung):
        return 0
    return calculatedDrehzahl

def f2x(vorhandeneEnergie):
    return f1x(vorhandeneEnergie - 50)

def T1Over(txState):
    oldState = txState.setState_TimeOver()
    print("-------------------------> T1Over called:",oldState," -->",txState.toString())

def T2Over(txState):
    oldState = txState.setState_TimeOver()
    print("-------------------------> T2Over called:",oldState," -->",txState.toString())


# command-Line parameters
# --------------------------------------------------
print("Argument List:", str(sys.argv),"(",len(sys.argv),")")
inTestMode = False
testMode   = ""
if (len(sys.argv) > 1):
    inTestMode = True
    testMode   = str(sys.argv)
    time.sleep(4)


logFilePath = "/var/www/html/KM/"
logFileName = "KM_Logfile.txt"

# Aktoren / Output
# --------------------------------------------------
# shutOffValve_open = False

speedComp_2     = 0
comp_2_on       = False

speedComp_1     = 0
comp_1_on       = False

waterPump_On    = False
mixingValve     = 0
fanSpeed_1      = False
fanSpeed_2      = False

t1State         = TimerState("T1")
t2State         = TimerState("T2")

# Set-Up Values
# --------------------------------------------------
schwellwert_N_On            =  2.5 # bar
schwellwert_N_Off           =  2.0 # bar

schwellwert_H_On            = 14.3 # bar
schwellwert_H_Off           = 14.8 # bar
schwellwert_H_OffImmediate  = 15.0 # bar

schwellwert_H1_On           =  9.0 # bar
schwellwert_H1_Off          =  8.0 # bar

schwellwert_H2_On           =  11.0 # bar
schwellwert_H2_Off          =  10.0 # bar

schwellwert_WaterPump_On    =  3  # % Eingangs-Energie (gefiltert)
schwellwert_WaterPump_Off   =  2  # % Eingangs-Energie (gefiltert)

waterMin   =  2 # Celsius
waterMax   = 40 # Celsius

wiedereinschaltverzoegerung = "0:01:00"
minVorhandeneEnergie        =   5 # %
minVerdichterLeistung       =  10 # %
maxVerdichterLeistung       = 100 # %

time_T1      =  10 # s    Bei PressureError wird sofort emergencyOff_2 = True und nach time_T1 emergencyOff_1 = True
time_T2      = 120 # s    Die Compressors werden time_T2 nach der waterPump eingeschaltet
if (inTestMode):
    time_T2                     =  5   # s
    schwellwert_H_OffImmediate  = 16.0 # bar

sampleTime   =  1 # s
lowPressureErrorShutOffValveReopenTime = 0.5 # s In a case of a LowPressureError reopen the shutOffValve for some time

sollTemp          = 20
currentTemp       =  0
pid               = PID(2, 0.1, 0.05, setpoint=sollTemp, output_limits=(0,100))
pid.sample_time   = sampleTime


# Objects
# --------------------------------------------------
energieFilter     = Tiefpass(0,1, 1)
verdichter_1_TP   = Tiefpass(0,1,99)
verdichter_2_TP   = Tiefpass(0,1,99)
hsrKaelteMaschine = KaelteMacherMaschine(simulate = inTestMode)
verdichter_1      = Verdichter("Verdichter_1",minVorhandeneEnergie,maxVerdichterLeistung,verdichter_1_TP,hsrKaelteMaschine)
verdichter_2      = Verdichter("Verdichter_2",minVorhandeneEnergie,maxVerdichterLeistung,verdichter_2_TP,hsrKaelteMaschine)

niederDruckOff    = Hysterese(schwellwert_N_On,          schwellwert_N_Off        , name="Niederdruck",inverse=True,)
hochDruckOff      = Hysterese(schwellwert_H_On,          schwellwert_H_Off        , name="Hochdruck")
luefter_1_On      = Hysterese(schwellwert_H1_On,         schwellwert_H1_Off       , name="Luefter_1" , OnStr = "Running", OffStr = "Stopped")
luefter_2_On      = Hysterese(schwellwert_H2_On,         schwellwert_H2_Off       , name="Luefter_2" , OnStr = "Running", OffStr = "Stopped")
waterPumpHy       = Hysterese(schwellwert_WaterPump_On,  schwellwert_WaterPump_Off, name="WaterPump" , OnStr = "Running", OffStr = "Stopped")
logFile           = WR_Logfile(logFilePath,logFileName)
# --------------------------------------------------
# main Loop
# --------------------------------------------------
doLoop            = True
vorhandeneEnergie = 0
startUpTime       = datetime.datetime.now()

VT52_cls_home()
hsrKaelteMaschine.setHeartbeatInicator(True)
logFile.addLogEntry(hsrKaelteMaschine.toStringForLog(onlyHeader = True), doAppend = False)

while (doLoop):
    hsrKaelteMaschine.toggleHeartbeatInicator()
    # ----------------------------------------------
    # Status Anzeige
    # ----------------------------------------------
    VT52_cls_home()
    if (inTestMode):
        print("IN TEST-MODE")
        print("   time_T2                   : ",time_T2)
        print("   schwellwert_H_OffImmediate: ",schwellwert_H_OffImmediate)
        print()
        print("=====================\n")
    print(hsrKaelteMaschine.toString())
    logFile.addLogEntry(hsrKaelteMaschine.toStringForLog())
    if (hsrKaelteMaschine.isEmergencyOff_Active()):
        print("--------------------------------------1")
        print("Emergency Off pressed!! Will not start!!!")
        hsrKaelteMaschine.doEmergencyStop()
        verdichter_1.doEmergencyStop()
        verdichter_2.doEmergencyStop()
        # t2State.setState_NotStarted() # Waterpump steys on in EmercencyOff
    else:
        print("--------------------------------------2")
        vorhandeneEnergie           = hsrKaelteMaschine.getExistingEnergy()
        hochdruck                   = hsrKaelteMaschine.getHighPressure()
        niederdruck                 = hsrKaelteMaschine.getLowPressure()
        waterTemp                   = hsrKaelteMaschine.getWaterTemp_PT1000()
        envTemp                     = hsrKaelteMaschine.getEnvironmentTemp_PT1000()

        # ----------------------------------------------
        # Calculated values
        # ----------------------------------------------
        lowPressureError            = niederDruckOff.setState(niederdruck,verbal = True)
        highPressureError           = hochDruckOff.setState(hochdruck    ,verbal = True)
        pressureError = (lowPressureError or highPressureError)
        if (pressureError):
            if (t1State.isState_NotStarted()):
                t1 = Timer(time_T1, T1Over, args=[t1State])
                t1State.setState_Ticking()
                t1.start()
            print("pressureError      :",pressureError,end="")
            if (lowPressureError):
               print("  (lowPressureError)",end="")
               hsrKaelteMaschine.setShutOffValveToOpen(True)
               time.sleep(lowPressureErrorShutOffValveReopenTime)
               hsrKaelteMaschine.setShutOffValveToOpen(True)
            if (highPressureError):
               print("  (highPressureError)",end="")
            print("")
        else:
            t1State.setState_NotStarted()

        waterTempOutOfRange = False
        if ((waterTemp < waterMin) or (waterTemp > waterMax)):
            waterTempOutOfRange = True
        if (waterTempOutOfRange):
            print("waterTempOutOfRange [",waterMin,"..",waterMax,"]:",waterTemp,"  !!")

        compressorsReady = hsrKaelteMaschine.isCompressorReady(1) and hsrKaelteMaschine.isCompressorReady(2)
        if (compressorsReady == False):
            print("compressorsReady   :",compressorsReady,"  !!")

        # shutOffValve_open = compressorsReady and (hsrKaelteMaschine.isEmergencyOff_Active()  == False)
        # if (shutOffValve_open == False):
            # print("shutOffValve_open  :",shutOffValve_open,"  !!")

        emergencyOff_1 = (hsrKaelteMaschine.isCompressorReady(1) == False) or waterTempOutOfRange or pressureError or hsrKaelteMaschine.isEmergencyOff_Active()
        emergencyOff_2 = (hsrKaelteMaschine.isCompressorReady(2) == False) or waterTempOutOfRange or pressureError or hsrKaelteMaschine.isEmergencyOff_Active()
        if (emergencyOff_2):
            print("emergencyOff_2     :",emergencyOff_2,"  !!")
        if (emergencyOff_1):
            if (t1State.isState_Ticking()):
                if ( hochdruck > schwellwert_H_OffImmediate):
                    print("HighPressure over ",schwellwert_H_OffImmediate,"  Shutdown immediately!!!")
                else:
                    emergencyOff_1 = False
                    print("emergencyOff_1     : t1 is ticking to see if that lowers the highPressure!")
            else:
                print("emergencyOff_1     :",emergencyOff_1,"  !!")

        if (vorhandeneEnergie < minVorhandeneEnergie):
            vorhandeneEnergie = 0
        print("--------------------------------------3")
        # ----------------------------------------------
        # Set actor values
        # ----------------------------------------------

        # Tiefpass vorhandeneEnergie q
        qGefiltert = energieFilter.setNewInValue(vorhandeneEnergie)
        print("  qGefiltert       : {q:5.1f}%".format(q=qGefiltert))

        # WaterPump
        waterPump_On  = waterPumpHy.setState(qGefiltert,verbal = True)
        hsrKaelteMaschine.setWaterPump_On(waterPump_On)

        # Absperrventil_EVR_3
        if ((verdichter_1.isCompressorOn()) or (verdichter_2.isCompressorOn())):
            ## print("Open ShutOff Valve!!!!")
            hsrKaelteMaschine.setShutOffValveToOpen(True)
        else:
            hsrKaelteMaschine.setShutOffValveToOpen(False)

        # Fan
        hsrKaelteMaschine.setFanSpeed(luefter_1_On.setState(hochdruck,verbal = True),luefter_2_On.setState(hochdruck,verbal = True))

        # MixingValve
        control = pid(waterTemp)
        print("  Water Ist-Temp   : {c0:4.1f}C (Soll:{c1:4.1f}C)  ==> 3-Weg Ventil:{c2:5.2f}%\n".format(c0=waterTemp, c1=sollTemp, c2=control))
        hsrKaelteMaschine.setMixingValve(control)

        # Timer status
        print("t1State:",t1State.toString())
        print("t2State:",t2State.toString())

        if ((qGefiltert > minVorhandeneEnergie) and (t2State.isState_NotStarted())):
            print("================> Set timer T2")
            t2 = Timer(time_T2, T2Over, args=[t2State])
            t2State.setState_Ticking()
            t2.start()

        if (qGefiltert < minVorhandeneEnergie):
            t2State.setState_NotStarted()
            verdichter_1.setValues(0, emergencyOff_1, hsrKaelteMaschine.isDelayedOn_Active())
            verdichter_2.setValues(0, emergencyOff_2, hsrKaelteMaschine.isDelayedOn_Active())

        if (t2State.isState_TimeOver()):
            # Verdichter
            verdichter_1.setValues(f1x(qGefiltert), emergencyOff_1, hsrKaelteMaschine.isDelayedOn_Active())
            verdichter_2.setValues(f2x(qGefiltert), emergencyOff_2, hsrKaelteMaschine.isDelayedOn_Active())
            print(verdichter_1.toString())
            print(verdichter_2.toString())
    print("================================================\n\n\n")
    time.sleep(sampleTime)

