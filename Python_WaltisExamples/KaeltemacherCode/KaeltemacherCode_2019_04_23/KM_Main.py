#!/usr/bin/python3
import math
import time
import datetime
import re
import piplates.DAQCplate as DAQC

from Class_Hysterese            import *
from Class_Tiefpass             import *
from Class_IncDec               import *
from Class_Verdichter           import *
from Class_KaelteMacherMaschine import *
from sense_hat                  import SenseHat

from littlePythonLib import *

# Set-Up Values
# --------------------------------------------------
schwellwert_N_On   = 20
schwellwert_N_Off  = 10

schwellwert_H_On   = 90
schwellwert_H_Off  = 80

schwellwert_H1_On  = 60
schwellwert_H1_Off = 50

schwellwert_H2_On  = 90
schwellwert_H2_Off = 80

wiedereinschaltverzoegerung = "0:00:10"
waterPumpAheadTime          = "0:00:05"
minVorhandeneEnergie        =   5 # %
minVerdichterLeistung       =  10 # %
maxVerdichterLeistung       = 100 # %

# Objects
# --------------------------------------------------
energieFilter     = Tiefpass(0,1,1)
verdichter_1_TP   = Tiefpass(0,1,99)
verdichter_2_TP   = Tiefpass(0,1,99)
hsrKaelteMaschine = KaelteMacherMaschine(1)
verdichter_1      = Verdichter("Verdichter_1",minVorhandeneEnergie,maxVerdichterLeistung,verdichter_1_TP,hsrKaelteMaschine)
verdichter_2      = Verdichter("Verdichter_2",minVorhandeneEnergie,maxVerdichterLeistung,verdichter_2_TP,hsrKaelteMaschine)

qIncDec           = IncDec()
niederDruckOff    = Hysterese(schwellwert_N_On,   schwellwert_N_Off)
hochDruckOff      = Hysterese(schwellwert_H_On,   schwellwert_H_Off,inverse=True)
luefter_1_On      = Hysterese(schwellwert_H1_On,  schwellwert_H1_Off)
luefter_2_On      = Hysterese(schwellwert_H2_On,  schwellwert_H2_Off)
sense             = SenseHat()


# Aktoren / Output
# --------------------------------------------------
drehzahlVerdichter_1     = 0
drehzahlVerdichter_2     = 0
absperrVentilEVR3_closed = True
wasserpumpe_On           = False
luefterDrehzahl_1        = False
luefterDrehzahl_2        = False


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


# --------------------------------------------------
# main Loop
# --------------------------------------------------
doLoop            = True
vorhandeneEnergie = 0
qIncDec.setValue(vorhandeneEnergie)
startUpTime = datetime.datetime.now()
minQTimer = ""

hsrKaelteMaschine.setHeartbeatInicator(True)
while (doLoop):
    hsrKaelteMaschine.toggleHeartbeatInicator()
    currTime = datetime.datetime.now()
    print("\n=====================================",currTime,"  Since(",startUpTime,")")
	
    # Sensorwerte / Input
    vorhandeneEnergie            = hsrKaelteMaschine.getVorhandeneEnergie()
    hochdruck                    = hsrKaelteMaschine.getHochdruck()
    niederdruck                  = hsrKaelteMaschine.getNiederdruck()
    compressor_1_ready           = hsrKaelteMaschine.getCompressor_1_Status()
    compressor_2_ready           = hsrKaelteMaschine.getSpannungVerdichter_2_ok()
    einschaltVerzoegerungAktiv   = hsrKaelteMaschine.getEinschaltVerzoegerung()
	waterTemp                    = 
    compressorsReady = (compressor_1_ready and compressor_2_ready)
    # print("verdichterReady                :",verdichterReady)
    print("---------------------------------------")

    # ----------------------------
    # Tiefpass vorhandeneEnergie q
    # ----------------------------
    qGefiltert = energieFilter.setNewInValue(vorhandeneEnergie)
    if (qGefiltert < minVorhandeneEnergie):
        qGefiltert = 0
        minQTimer = ""
    else:
        if (minQTimer == ""):
            minQTimer = datetime.datetime.now()
            qGefiltert = 0
        if (checkTimeDifference(minQTimer, currTime, waterPumpAheadTime)):
            qGefiltert = 0

	# -----------------
    # Anlaufbedingungen 
    # -----------------
    lowPressureError  = niederDruckOff.setState(niederdruck)
    highPressureError = hochDruckOff.setState(hochdruck)
    pressorError = (lowPressureError or highPressureError)
	
    # ------------
    # Verdichter_1
    # ------------
    verdichter_1.setValues(f1x(qGefiltert),((compressorsReady == False) or (pressorError)),einschaltVerzoegerungAktiv)
	
    # ------------
    # Verdichter_2
    # ------------
    verdichter_2.setValues(f2x(qGefiltert),((compressorsReady == False) or (pressorError)),einschaltVerzoegerungAktiv)
 
    print(verdichter_1.toString())
    print(verdichter_2.toString())
	
	# -------------------
    # Absperrventil_EVR_3
    # -------------------
    if (compressorsReady or ((verdichter_1.getVerdichterOn() == False) and (verdichter_2.getVerdichterOn() == False))):
        absperrVentilEVR3_closed = True
    else:
        absperrVentilEVR3_closed = False
    print("absperrVentilEVR3_closed:",absperrVentilEVR3_closed,"    verdichterReady:",verdichterReady,"    verdichter_1:",verdichter_1.getVerdichterOn(),"    verdichter_2:",verdichter_2.getVerdichterOn())
    hsrKaelteMaschine.closeAbsperrVentil(absperrVentilEVR3_closed)


	# ------
    # Lüfter
    # ------
    hsrKaelteMaschine.setLuefter(luefter_1_On.setState(hochdruck),luefter_2_On.setState(hochdruck))
	
	
	
    time.sleep(1)
                                                    