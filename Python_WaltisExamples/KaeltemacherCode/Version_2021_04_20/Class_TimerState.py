#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_TimerState.py
#
# Description: 
#
# Autor: Walter Rothlin
#
# History:
# 26-Jun-2019	Initial Version
#
# ------------------------------------------------------------------
import datetime

class TimerState:

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, timerName, timerState="NotStarted"):
      self.timerName    = timerName
      self.timerState   = timerState
      self.tickingSince = ""

   # Methoden (setter / getter)
   # --------------------------   
   def isState_NotStarted(self):
      return (self.timerState == "NotStarted")

   def isState_Ticking(self):
      return (self.timerState == "Ticking")

   def isState_TimeOver(self):
      return (self.timerState == "TimeOver")

   def setState_NotStarted(self):
      oldState = self.timerState
      self.timerState = "NotStarted"
      self.tickingSince =  ""
      return oldState

   def setState_Ticking(self):
      oldState = self.timerState
      self.timerState = "Ticking"
      self.tickingSince =  str(datetime.datetime.now())
      return oldState

   def setState_TimeOver(self):
      oldState = self.timerState
      self.timerState = "TimeOver"
      self.tickingSince =  ""
      return oldState

   def toString(self):
      if (self.isState_Ticking()):
          return self.timerName + "::" + self.timerState + "   (since: " + self.tickingSince + ")"
      else:
          return self.timerName + "::" + self.timerState
