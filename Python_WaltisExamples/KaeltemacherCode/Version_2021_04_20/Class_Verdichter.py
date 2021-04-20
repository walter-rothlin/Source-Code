#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Verdichter.py
#
# Description: Verdichterklasse der Kälteanlage.
#
# Autor: Walter Rothlin
#
# History:
# 24-Apr-2019	Initial Version
# 26-Jun-2019	Reviewed Version
#
# ------------------------------------------------------------------
import math
import time
import datetime

from waltisLibrary import *

class Verdichter:

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, name, pMin, pMax, outputTiefpass, hsrKaelteMaschine):
      self.name                        = name
      self.pMin                        = pMin
      self.pMax                        = pMax
      self.outputTiefpass              = outputTiefpass
      self.hsrKaelteMaschine           = hsrKaelteMaschine
      self.istSpeed                    = 0      
      self.sollSpeed                   = 0
      self.verdichterOn                = False
      self.isVerdichterOnState         = False
      self.wiederEinschaltenMoeglich   = False
      self.lastTimeOff                 = datetime.datetime.now()

   # Methoden (setter / getter)
   # --------------------------
   def setValues(self, sollSpeed, emergencyOff, einschaltverzoegert):
      currTime = datetime.datetime.now()
      wiedereinschaltverzoegerung = "0:00:30"
      print("==> setValues ({x1:1s})::sollSpeed:{x2:4.0f}%".format(x1=self.name,x2=sollSpeed),"  emergencyOff:",emergencyOff,"  einschaltverzoegert:",einschaltverzoegert)

      if (emergencyOff):
         self.sollSpeed    = 0
         self.verdichterOn = False
         self.resetRestartTime()
      else:
         if (sollSpeed > self.pMax):
            self.sollSpeed = self.pMax
            self.verdichterOn = True
         elif (sollSpeed < self.pMin):
            self.sollSpeed = 0
            if (self.verdichterOn):
                self.verdichterOn = False
                self.resetRestartTime()
         else:
            self.sollSpeed = sollSpeed
            self.verdichterOn = True

      if ((self.sollSpeed == 0) and (self.verdichterOn)):
         self.self.istSpeed = 0
         self.verdichterOn = False
         self.resetRestartTime()

      self.wiederEinschaltungMoeglich = ((einschaltverzoegert == False) or ((einschaltverzoegert == True) and (checkTimeDifference(self.lastTimeOff, currTime, wiedereinschaltverzoegerung))))
 
      if ((self.wiederEinschaltungMoeglich) and (self.verdichterOn)):
         self.istSpeed = self.outputTiefpass.setNewInValue(self.sollSpeed)
      else:
         self.istSpeed = self.outputTiefpass.setNewInValue(0)

      self.isVerdichterOnState = (self.verdichterOn and (self.istSpeed > 0))
      self.hsrKaelteMaschine.setSpeedComp(self.name[11:12],self.istSpeed)
      self.hsrKaelteMaschine.setComp_On(self.name[11:12],self.verdichterOn)

   def getVerdichterOn(self):
      return self.verdichterOn

   def isCompressorOn(self):
      return self.isVerdichterOnState

   def resetRestartTime(self):
      self.lastTimeOff = datetime.datetime.now()

   def doEmergencyStop(self, verbal = False):
      if (verbal):
          print("Emergency Off Class_Verdichter activated!!!")
      self.istSpeed                    = 0      
      self.sollSpeed                   = 0
      self.verdichterOn                = False
      self.isVerdichterOnState         = False
      self.wiederEinschaltenMoeglich   = False
      self.lastTimeOff                 = datetime.datetime.now()

   def toString(self):
      return self.name + ":: Soll:{x1:4.0f}%  Ist:{x2:4.0f}%  setOn:{x3:5s}  isOn:{x4:5s}".format(x1=self.sollSpeed, x2=self.istSpeed, x3=str(self.verdichterOn), x4=str(self.isVerdichterOnState)) + "  LastTimeOff:" + str(self.lastTimeOff)[11:19] + "  wiederEinschaltungMoeglich:" + str(self.wiederEinschaltungMoeglich)
