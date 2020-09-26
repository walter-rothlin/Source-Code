#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Test_TemperaturSensorDigital.py
#
# Description: Test-Programm for the corresponding class
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
import piplates.DAQCplate                       as DAQC
from   Class_TemperaturSensorDigital            import *


zimmerTemperatur = TemperaturSensorDigital("Zimmer-Temperatur",2,0)
print(zimmerTemperatur.getCurrentValue(),"°C")
print(zimmerTemperatur.toString())


wasserTemperatur = TemperaturSensorDigital("Wasser-Temperatur",2,0)
print(wasserTemperatur.getCurrentValue(),"°C")
print(wasserTemperatur.toString())

print("\n\n")

print("Thermometer 1\tThermometer 2")

print(str(DAQC.getTEMP(2,0,'c'))+"°C\t"+str(DAQC.getTEMP(2,1,'c'))+"°C")
print(str(DAQC.getTEMP(2,0,'k'))+"°K\t"+str(DAQC.getTEMP(2,1,'k'))+"°K")
print(str(DAQC.getTEMP(2,0,'f'))+"°F\t"+str(DAQC.getTEMP(2,1,'f'))+"°F")
