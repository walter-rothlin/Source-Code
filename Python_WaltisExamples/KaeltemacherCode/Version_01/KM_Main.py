#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KM_Main.py
#
# Description: Hauptsteurung der Kälteanlage.
#
# Autor: Walter Rothlin
#
# History:
# 24-Apr-2019	Initial Version
# 07-Jun-2019	2nd Version
#
# ------------------------------------------------------------------

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
# from sense_hat                  import SenseHat

from waltisLibrary import *

# Set-Up Values
# --------------------------------------------------
schwellwert_N_On   = 20
schwellwert_N_Off  = 10

schwellwert_H_On   = 95
schwellwert_H_Off  = 85

schwellwert_H1_On  = 60
schwellwert_H1_Off = 50

schwellwert_H2_On  = 90
schwellwert_H2_Off = 80

wiedereinschaltverzoegerung = "0:00:10"
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

niederDruckOff    = Hysterese(schwellwert_N_On,   schwellwert_N_Off)
hochDruckOff      = Hysterese(schwellwert_H_On,   schwellwert_H_Off,inverse=True)
luefter_1_On      = Hysterese(schwellwert_H1_On,  schwellwert_H1_Off)
luefter_2_On      = Hysterese(schwellwert_H2_On,  schwellwert_H2_Off)
# sense             = SenseHat()


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
startUpTime       = datetime.datetime.now()

hsrKaelteMaschine.setHeartbeatInicator(True)
while (doLoop):
    hsrKaelteMaschine.toggleHeartbeatInicator()
    currTime = datetime.datetime.now()
    print("\n=====================================",currTime,"  Since(",startUpTime,")")
	
    # Sensorwerte / Input
    vorhandeneEnergie           = hsrKaelteMaschine.getVorhandeneEnergie()
    if (vorhandeneEnergie < minVorhandeneEnergie):
        vorhandeneEnergie = 0
    hochdruck                   = hsrKaelteMaschine.getHochdruck()
    niederdruck                 = hsrKaelteMaschine.getNiederdruck()
    hochdruckStoerung           = hsrKaelteMaschine.getHochdruckStoerung()
    niederdruckStoerung         = hsrKaelteMaschine.getNiederdruckStoerung()
    einschaltVerzoegerungAktiv  = hsrKaelteMaschine.getEinschaltVerzoegerung()
	
    stoerung = (niederdruckStoerung or hochdruckStoerung)
    # print("stoerung                :",stoerung)
    print("---------------------------------------")

    # ----------------------------
    # Tiefpass vorhandeneEnergie q
    # ----------------------------
    qGefiltert = energieFilter.setNewInValue(vorhandeneEnergie)
	
    # ------------
    # Verdichter_1
    # ------------
    ndOff = niederDruckOff.setState(niederdruck)
    verdichter_1.setValues(f1x(qGefiltert),((stoerung) or (ndOff)),einschaltVerzoegerungAktiv)
	
    # ------------
    # Verdichter_2
    # ------------
    hdOff = hochDruckOff.setState(hochdruck)
    verdichter_2.setValues(f2x(qGefiltert),((stoerung) or (hdOff)),einschaltVerzoegerungAktiv)
 
    print(verdichter_1.toString())
    print(verdichter_2.toString())
	
	# -------------------
    # Absperrventil_EVR_3
    # -------------------
    if (stoerung or ((verdichter_1.getVerdichterOn() == False) and (verdichter_2.getVerdichterOn() == False))):
        absperrVentilEVR3_closed = True
    else:
        absperrVentilEVR3_closed = False
    print("absperrVentilEVR3_closed:",absperrVentilEVR3_closed,"    stoerung:",stoerung,"    verdichter_1:",verdichter_1.getVerdichterOn(),"    verdichter_2:",verdichter_2.getVerdichterOn())
    hsrKaelteMaschine.closeAbsperrVentil(absperrVentilEVR3_closed)


	# ------
    # Lüfter
    # ------
    hsrKaelteMaschine.setLuefter(luefter_1_On.setState(hochdruck),luefter_2_On.setState(hochdruck))
	
	
	
    time.sleep(1)
                                                    