#!/usr/bin/python3
import math

class Tiefpass:
   # Uc = Uo(1-e^(-t/Tau))
   def __init__(self, currentValue, tauUp, tauDown):
      self.currentValue = currentValue
      self.tauUp = tauUp     # t / Tau (je groesser desto schneller)
      self.tauDown = tauDown # bei 1 geht es ca 5 Schritte bis der Endwert erreicht ist
   
   def setNewInValue(self,inValue):
      if (inValue > self.currentValue):
          self.currentValue =((inValue - self.currentValue) * (1-math.exp(-self.tauUp))) + self.currentValue
      else:
          self.currentValue =((inValue - self.currentValue) * (1-math.exp(-self.tauDown))) + self.currentValue

      return self.currentValue

   def getValue(self):
      return self.currentValue