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
import random
import time
import datetime
import re

import piplates.DAQCplate as DAQC
#import class_DAQC_LedLine_pseudo as DAQC


from threading                  import Timer
from simple_pid                 import PID
# import PID

from Class_Hysterese            import *
from Class_Tiefpass             import *
from Class_IncDec               import *
from Class_Verdichter           import *
from Class_KaelteMacherMaschine import *
from Class_TimerState           import *
from Class_WR_Logfile           import *
from waltisLibrary              import *

import itertools
from time import localtime, gmtime, strftime

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

def T3Over(txState):
    oldState = txState.setState_TimeOver()
    # print("-------------------------> T3Over called:",oldState," -->",txState.toString())


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
actDateTime = strftime("%Y-%m-%d_%H-%M-%S", localtime())
logFileName = "KM_Logfile_" + actDateTime + ".txt"

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
t3State         = TimerState("T3")

# Get Set-Up Values from file. If not available, use passed default value.
d = {}
with open("/home/pi/Kaeltemacher/Set-Up_Values.txt") as f:
# with open("Set-Up_Values.txt") as f:
    for line in f:
        (key, val) = line.rstrip().split(" ")
        d[str(key)] = val

# --------------------------------------------------
schwellwert_N_On            =  float(d.get("schwellwert_N_On", "1.0")) # bar
schwellwert_N_Off           =  float(d.get("schwellwert_N_Off", "0.6")) # bar

schwellwert_H_On            =  float(d.get("schwellwert_H_On", "15.5")) # bar
schwellwert_H_Off           =  float(d.get("schwellwert_H_Off", "15.0")) # bar
schwellwert_H_OffImmediate  =  float(d.get("schwellwert_H_OffImmediate", "15.7")) # bar

schwellwert_H1_On           =  float(d.get("schwellwert_H1_On", "9.0")) # bar
schwellwert_H1_Off          =  float(d.get("schwellwert_H1_Off", "8.0")) # bar

schwellwert_H2_On           =  float(d.get("schwellwert_H2_On", "11.0")) # bar
schwellwert_H2_Off          =  float(d.get("schwellwert_H2_Off", "10.0")) # bar

schwellwert_WaterPump_On    =  int(d.get("schwellwert_WaterPump_On", "3")) # % Eingangs-Energie (gefiltert)
schwellwert_WaterPump_Off   =  int(d.get("schwellwert_WaterPump_Off", "2")) # % Eingangs-Energie (gefiltert)

waterMin_Off   =  int(d.get("waterMin_Off", "4")) # Celsius
waterMin_On   =  int(d.get("waterMin_On", "8")) # Celsius
waterMax_Off  =  int(d.get("waterMax_Off", "40")) # Celsius
waterMax_On   =  int(d.get("waterMax_On", "35")) # Celsius

# lowWaterTemp_ShutOff   =  int(d.get("lowWaterTemp_ShutOff", "4")) # Celsius
# lowWaterTemp_TurnOn    =  int(d.get("lowWaterTemp_TurnOn", "8")) # Celsius
# lowWaterTemp_ShutOff_active = False
# lowWaterTemp_decreaseStep = 10

wiedereinschaltverzoegerung = "0:01:00"
minVorhandeneEnergie        =   int(d.get("minVorhandeneEnergie", "5")) # %
minVerdichterLeistung       =   int(d.get("minVerdichterLeistung", "10")) # %
maxVerdichterLeistung       =   int(d.get("maxVerdichterLeistung", "100")) # %

time_T1      =  int(d.get("time_T1", "10")) # s    Bei PressureError wird sofort emergencyOff_2 = True und nach time_T1 emergencyOff_1 = True
# time_T2      = 120 # s    Die Compressors werden time_T2 nach der waterPump eingeschaltet
time_T2      =  int(d.get("time_T2", "80")) # s    Die Compressors werden time_T2 nach der waterPump eingeschaltet

time_T3      =  int(d.get("time_T3", "60")) # s    Regelung für Mixing Valve wird verzoegert zugeschaltet
if (inTestMode):
    time_T2                     =  int(d.get("time_T2_inTestMode", "5")) # s
    schwellwert_H_OffImmediate  =  int(d.get("schwellwert_H_OffImmediate_inTestMode", "16.0")) # bar

sampleTime   =  float(d.get("sampleTime", "1")) # s
lowPressureErrorShutOffValveReopenTime = float(d.get("lowPressureErrorShutOffValveReopenTime", "0.5")) # s In a case of a LowPressureError reopen the shutOffValve for some time

sollTemp          =  int(d.get("sollTemp", "20"))
currentTemp       =  int(d.get("currentTemp", "0"))
# pid               = PID(2, 0.1, 0.05, setpoint=sollTemp, output_limits=(0,100))
# pid               = PID(4, 30, 0, setpoint=sollTemp, output_limits=(0,100))
# pid               = PID(20, 160, 80, setpoint=sollTemp, output_limits=(0,100))
pid               = PID(float(d.get("pid_P", "20")), float(d.get("pid_I", "160")), float(d.get("pid_D", "80")), setpoint=sollTemp, output_limits=(0,100))
pid.sample_time   = sampleTime


# Objects
# --------------------------------------------------
energieFilter     = Tiefpass(0,1,1)
verdichter_1_TP   = Tiefpass(0,1,99)
#verdichter_1_TP   = Tiefpass(0,1,1)
verdichter_2_TP   = Tiefpass(0,1,99)
#verdichter_2_TP   = Tiefpass(0,1,1)
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

qVerstärkung = 1
qGedrosselt = 0
i = 0

toggle_verdichter = itertools.cycle(['Verdichter_1', 'Verdichter_2']).__next__
verdichter_toggled = False

waterTempOutOfRange = False

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
    
    #test = False
    #if (test == True):
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
            
        # hsrKaelteMaschine.setShutOffValveToOpen(True)

        if (pressureError):
            if (t1State.isState_NotStarted()):
                t1 = Timer(time_T1, T1Over, args=[t1State]) # timer Thread
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


        if(waterTemp < waterMin_Off or waterTemp > waterMax_Off):
            waterTempOutOfRange = True
            print("waterTempOutOfRange [",waterMin_Off,"..",waterMax_Off,"]:",waterTemp,"  !!")
        if(waterTempOutOfRange == True and waterTemp > waterMin_On and waterTemp < waterMax_On):
            waterTempOutOfRange = False


        compressorsReady = hsrKaelteMaschine.isCompressorReady(1) and hsrKaelteMaschine.isCompressorReady(2)
        if (compressorsReady == False):
            print("compressorsReady   :",compressorsReady,"  !!")

        # shutOffValve_open = compressorsReady and (hsrKaelteMaschine.isEmergencyOff_Active()  == False)
        # if (shutOffValve_open == False):
            # print("shutOffValve_open  :",shutOffValve_open,"  !!")

        emergencyOff_1 = (hsrKaelteMaschine.isCompressorReady(1) == False) or waterTempOutOfRange or pressureError or hsrKaelteMaschine.isEmergencyOff_Active()
        emergencyOff_2 = (hsrKaelteMaschine.isCompressorReady(2) == False) or waterTempOutOfRange or pressureError or hsrKaelteMaschine.isEmergencyOff_Active()

        #emergencyOff_1 = False
        #emergencyOff_2 = False

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
        # print("  qGefiltert       : {q:5.1f}%".format(q=qGefiltert))
        qGedrosselt = qVerstärkung * qGefiltert

        # WaterPump
        waterPump_On  = waterPumpHy.setState(qGefiltert,verbal = True)
        hsrKaelteMaschine.setWaterPump_On(waterPump_On)

        # neue Fan Variante
        if(waterPump_On == True and luefter_1_On.setState(hochdruck,verbal = True) == True and luefter_2_On.setState(hochdruck,verbal = True) == True):
            # Stufe 2
            # hsrKaelteMaschine.setFanSpeed(True, True)
            if(hsrKaelteMaschine.fanSpeed > 0):
                hsrKaelteMaschine.setFanSpeed(luefter_1_On.setState(hochdruck,verbal = True),luefter_2_On.setState(hochdruck,verbal = True))
            else:
                pass
        elif(waterPump_On == True):
            # Stufe 1
            hsrKaelteMaschine.setFanSpeed(True, False)
        else:
            # Stufe 0
            hsrKaelteMaschine.setFanSpeed(False, False)
 

        # Absperrventil_EVR_3
        
        # Wahrscheinlich wird die falsche Bedingung geprüft! .isCompressorOn() ungeeignet, da istSpeed verzögert kommt (wiederEinschaltungMoeglich)
        # if ((verdichter_1.isCompressorOn()) or (verdichter_2.isCompressorOn())):
        
        # prüft nur, ob verdichterOn ist -> müsste unverzögert kommen
        if ((verdichter_1.getVerdichterOn()) or (verdichter_2.getVerdichterOn())):
            ## print("Open ShutOff Valve!!!!")
            hsrKaelteMaschine.setShutOffValveToOpen(True)
        else:
            hsrKaelteMaschine.setShutOffValveToOpen(False)

        # Fan
        # hsrKaelteMaschine.setFanSpeed(luefter_1_On.setState(hochdruck,verbal = True),luefter_2_On.setState(hochdruck,verbal = True))
        #hsrKaelteMaschine.setFanSpeed(True,False)

        if (t3State.isState_TimeOver()):
            # MixingValve
            control = pid(waterTemp) # pid(current_value)
            print("  Water Ist-Temp   : {c0:4.1f}C (Soll:{c1:4.1f}C)  ==> 3-Weg Ventil:{c2:5.2f}%\n".format(c0=waterTemp, c1=sollTemp, c2=control))
            hsrKaelteMaschine.setMixingValve(control)

        # Timer status
        print("t1State:",t1State.toString())
        print("t2State:",t2State.toString())

        # startet Timer T2 (120s), falls qGefiltert > 5% und t2State.isState_NotStarted
        if ((qGefiltert > minVorhandeneEnergie) and (t2State.isState_NotStarted())):
            t3 = Timer(time_T3, T3Over, args=[t3State])
            t3State.setState_Ticking()
            t3.start()

            print("================> Set timer T2")
            t2 = Timer(time_T2, T2Over, args=[t2State])
            t2State.setState_Ticking()
            t2.start()

        # qGefiltert < 5%
        if (qGefiltert < minVorhandeneEnergie):
            t3State.setState_NotStarted()
            t2State.setState_NotStarted()
            
            verdichter_1.setValues(0, emergencyOff_1, hsrKaelteMaschine.isDelayedOn_Active())
            verdichter_2.setValues(0, emergencyOff_2, hsrKaelteMaschine.isDelayedOn_Active())

            # initialer Wert des Mischventils auf 80 gesetzt
            hsrKaelteMaschine.setMixingValve(80, False)

            # nach Abschaltung der Verdichter wird die Zuschaltreihenfolge der Verdichter vertauscht
            if(verdichter_toggled == False):
                toggle_verdichter()
                # verdichter_1 = Verdichter(toggle_verdichter(), minVorhandeneEnergie,maxVerdichterLeistung, verdichter_1_TP,hsrKaelteMaschine)
                # verdichter_2 = Verdichter(toggle_verdichter(), minVorhandeneEnergie,maxVerdichterLeistung, verdichter_2_TP,hsrKaelteMaschine)
                verdichter_toggled = True
        else:
            verdichter_toggled = False


        # wenn Timer Thread t2 (120s) abgelaufen
        if (t2State.isState_TimeOver()):
            # Verdichter
            verdichter_1.setValues(f1x(qGedrosselt), emergencyOff_1, hsrKaelteMaschine.isDelayedOn_Active())
            verdichter_2.setValues(f2x(qGedrosselt), emergencyOff_2, hsrKaelteMaschine.isDelayedOn_Active())
            print(verdichter_1.toString())
            print(verdichter_2.toString())

            hochdruckkorrektur = False

            # Hochdruckkorrekturen werden prioritär behandelt:
            if(hochdruck < float(d.get("HD_Schwelle_1", "14.0"))): # ist ok Zustand
                print("hochdruck < ", float(d.get("HD_Schwelle_1", "14.0")))
                """
                if-Bedingung 1.1
                
                if(hochdruck < 12.0):
                    print("hochdruck < 12.0")
                    if(qGedrosselt + (qGedrosselt * 0.05) <= qGefiltert):
                        qGedrosselt = qGedrosselt + (qGedrosselt * 0.05)
                        # hochdruckkorrektur = True
                        print("+5% HD")
                    else:
                        pass
                else:
                    pass
                """
            else:
                if(qGedrosselt - (qGedrosselt * float(d.get("drosselung_dekrement", "0.05"))) >= 0):
                    qGedrosselt = qGedrosselt - float((qGedrosselt * float(d.get("drosselung_dekrement", "0.05"))))
                    hochdruckkorrektur = True
                    print("-5% HD")

                    # erst nach Eintritt hier die if-Bedingung 1.1 oben zulassen
                else:
                    pass

            # Niederdruckkorrekturen, haben geringere Priorität
            if(hochdruckkorrektur != True):
                print("!hochdruckkorrektur")
                if(niederdruck > float(d.get("ND_Schwelle_1", "1.6"))):
                    print("niederdruck > ", float(d.get("ND_Schwelle_1", "1.6")))
                    if(niederdruck >= float(d.get("ND_Schwelle_2", "2.0")) and hochdruck <= 10.0):
                        i += 1
                        print("niederdruck >= ", float(d.get("ND_Schwelle_2", "2.0")))
                        print("i % 5", i % 5)
                        if((qGedrosselt + (qGedrosselt * float(d.get("drosselung_dekrement", "0.05"))) <= qGefiltert) and (i % 5 == 0)):
                            qGedrosselt = qGedrosselt + (qGedrosselt * float(d.get("drosselung_inkrement", "0.05")))
                            # hochdruckkorrektur = True <- auskommentiert am 7.10.2019
                            print("+5% ND")
                        else:
                            pass
                    else:
                        pass

                else:
                    if(qGedrosselt - (qGedrosselt * float(d.get("drosselung_dekrement", "0.05"))) >= 0):
                        qGedrosselt = qGedrosselt - (qGedrosselt * float(d.get("drosselung_dekrement", "0.05")))
                        # hochdruckkorrektur = True <- auskommentiert am 7.10.2019
                        print("-5% ND")
                    else:
                        pass

            else:
                pass

            qVerstärkung = qGedrosselt / qGefiltert

            print("  qGedrosselt       : {q:5.1f}%".format(q=qGedrosselt))
            print("i: ", i)


            #else:
            #    pass
        else:
            # initialer Wert des Mischventils auf 80 gesetzt
            hsrKaelteMaschine.setMixingValve(80, False)
            # pass

    print("================================================\n\n\n")
    time.sleep(sampleTime)
