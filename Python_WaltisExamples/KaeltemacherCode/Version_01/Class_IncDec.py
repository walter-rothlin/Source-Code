#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_IncDec.py
#
# Description: Bildet eine Stepper ab.
#
# Autor: Walter Rothlin
#
# History:
# 24-April-2019	Initial Version
#
# ------------------------------------------------------------------
class IncDec:

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, currentValue=0, stepUp=1, stepDown=-1, max=1000, min=0):
      self.currentValue = currentValue
      self.stepUp = stepUp
      self.stepDown = stepDown
      self.max = max
      self.min = min

   # Methoden (setter / getter)
   # --------------------------   
   def inc(self):
      self.currentValue = self.currentValue + self.stepUp
      if (self.currentValue > self.max):
          self.currentValue = self.max
      return self.currentValue

   def dec(self):
      self.currentValue = self.currentValue - self.stepDown
      if (self.currentValue < self.min):
          self.currentValue = self.min
      return self.currentValue
    
   def getValue(self):
      return self.currentValue
    
   def setValue(self,newValue):
      self.currentValue = newValue
      return self.currentValue
