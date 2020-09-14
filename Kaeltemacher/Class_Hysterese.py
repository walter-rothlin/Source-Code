#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Hysterese.py
#
# Description: Bildet eine Hysterese On/Off ab.
#
# Autor: Walter Rothlin
#
# History:
# 24-April-2019	Initial Version
#
# ------------------------------------------------------------------
class Hysterese:

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, levelOn, levelOff, onOff=False, inverse=False, name = "Unknown", OnStr = "ERROR!!!", OffStr = "o.k."):
      self.levelOn  = levelOn
      self.levelOff = levelOff
      self.onOff    = onOff
      self.inverse  = inverse
      self.name     = name
      self.lastVal  = -10000
      self.OnStr    = OnStr
      self.OffStr   = OffStr

   # Methoden (setter / getter)
   # --------------------------
   def toString(self):
      fField = "{e:4.1f}"
      dField = "{e:10d}"
      sField = "{s:15s}"
      errStr = self.OffStr
      retStr = ("  " + sField).format(s=self.name)
      if (self.inverse):
         retStr = ("!_" + sField).format(s=self.name)
      retStr = retStr + ("  :[" + fField).format(e=self.levelOn) + " .. " + fField.format(e=self.levelOff) + "]  " + fField.format(e=self.lastVal) + " ==> "

      if (((self.onOff == True) and (self.inverse == False)) or ((self.onOff == False) and (self.inverse == True))):
         errStr = self.OnStr
      return retStr + errStr

   def setState(self,inValue, verbal = False):
     self.lastVal = inValue
     if (verbal):
        print(self.toString())
     if (self.onOff):
        if (inValue < self.levelOff):
            self.onOff = False
     else:
        if (inValue > self.levelOn):
            self.onOff = True
            
     if (self.inverse):
         return not self.onOff
     else:
         return self.onOff

   def getValue(self):
      return self.onOff

   def setInverse(self,newValue):
      self.inverse = newValue

   def getInverse(self):
      return self.inverse

   def getOff(self):
      return self.levelOff

   def getOn(self):
      return self.levelOn


##hochDruckOff      = Hysterese(90,80)
##for aNumber in [50,70,80,90,91,100,91,90,81,80,79,50]:
##   print("{x1:4d}".format(x1=aNumber),hochDruckOff.setState(aNumber),"  (",hochDruckOff.getOn(),",",hochDruckOff.getOff(),")")      
##print()
##
##hochDruckOff      = Hysterese(80,90,inverse=True)
##for aNumber in [50,70,80,90,91,100,91,90,81,80,79,50]:
##   print("{x1:4d}".format(x1=aNumber),hochDruckOff.setState(aNumber),"  (",hochDruckOff.getOn(),",",hochDruckOff.getOff(),")")      
##print()