#!/usr/bin/python3

# https://pypi.org/project/simple-pid/       pip3 install simple-pid

import piplates.DAQCplate   as DAQC
import piplates.RELAYplate  as RELAY
from time                       import sleep
from waltisLibrary              import *
from Class_4_20mA_Sensor        import *
from Class_KaelteMacherMaschine import *
from simple_pid                 import PID

hsrKaelteMaschine = KaelteMacherMaschine()
sollTemp          = 20
waterTemp         =  0
pid               = PID(2, 0.1, 0.05, setpoint=sollTemp, output_limits=(0,100))
pid.sample_time   = 1.00


while (True):
     waterTemp = hsrKaelteMaschine.getWaterTemp()
     control = pid(waterTemp)
     print("Soll Temp:{c0:5.2f}C  Ist Temp:{c1:5.2f}C   3-Weg Ventil:{c2:5.2f}%\n".format(c0=sollTemp, c1=waterTemp, c2=control))
     hsrKaelteMaschine.setMixingValve(control)
     sleep(1)




for inVal in [0,0,0,0,0,1,1,1,1,1,1,1,1,1]:
    print(inVal,pid(inVal))
    time.sleep(0.1)

print()
print()
pid.setpoint = 10
for inVal in [0,0,0,0,0,1,1,1,1,1,1,1,1,1]:
    print(inVal,pid(inVal))
    time.sleep(0.1)

