#!/usr/bin/python3
# ------------------------------------------------------------------
# Name: Class_4_20mA_Sensor.py
#
# Description: Abstracts an 4-20mA current loop sensor
#
# Autor: Walter Rothlin
#
# History:
# 17_Jul-2019	Initial Version
#
# ------------------------------------------------------------------
import math

class CurrentLoop_4_20mA_Sensor:
   # print(CurrentLoop_4_20mA_Sensor.__doc__)
   """
   A class for 4 to 20mA Sensor types.

   ...

   Attributes
   ----------
   name : str
       first name of the person
   surname : str
       family name of the person
   age : int
       age of the person

   Methods
   -------
   info(additional=""):
       Prints the person's name and age.
   """

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, sensorName, measurementUnit, valueAt_4mA, valueAt_20mA, R_shunt = 200, maxVoltageHigh = 4.092):
      """
      Constructs all the necessary attributes for the person object.

      Parameters
      ----------
          name : str
              first name of the person
          surname : str
              family name of the person
          age : int
              age of the person
      """
      self.val4mA             = 0.004
      self.val20mA            = 0.020
      self.sensorName         = sensorName
      self.measurementUnit    = measurementUnit
      self.valueAt_4mA        = valueAt_4mA
      self.valueAt_20mA       = valueAt_20mA
      self.maxVoltageHigh     = maxVoltageHigh
      self.R_shuntSoll        = self.maxVoltageHigh / self.val20mA    # R=U/I
      self.P_shuntSoll        = self.maxVoltageHigh * self.val20mA    # P=U*I
      self.R_shunt            = R_shunt                               # the closest in the resitor series
      self.voltageHigh        = self.val20mA * self.R_shunt
      self.voltageLow         = self.val4mA  * self.R_shunt         # Umin = IMin * RShunt
      self.a                  = (self.voltageHigh - self.voltageLow)/(valueAt_20mA - valueAt_4mA)  # U = f(physicalValue) = a*physicalValue + c
      self.c                  = self.voltageHigh - (self.a * self.valueAt_20mA)
      self.voltage            = 0
      self.physicalValue      = 0
      self.neverUsed          = True
      self.aSensorIsAttached  = False


   def calc_physicalValue(self, voltage):
      self.voltage           = voltage
      self.neverUsed         = False
      self.aSensorIsAttached = True
      # print("voltage: {f1:6.2f}".format(f1=voltage), "self.a: {f1:6.2f}".format(f1=self.a), "self.c: {f1:6.2f}".format(f1=self.c))
      if (voltage < (self.voltageLow * 0.9)):
         voltage = self.voltageLow
         self.aSensorIsAttached = False
      elif (voltage > self.voltageHigh):
         voltage > self.voltageHigh
      self.physicalValue = (self.voltage - self.c) / self.a   # physicalValue = (U - c) / a

      # print("self.physicalValue: {f1:6.2f}".format(f1=self.physicalValue), "self.neverUsed: " + str(self.neverUsed))
      return self.physicalValue

   def getPhysicalValue(self, withUnit = False):
      formatStr = "{f1:6.2f}"
      if (self.neverUsed):
         retStr = "Warning: Never set!"
      else:
         if (withUnit == False):
            retStr = formatStr.format(f1=self.physicalValue)
         else:
            retStr = formatStr.format(f1=self.physicalValue) + " " + self.getPhysicalUnit()
      return retStr

   def getVoltage(self, withUnit = False):
      if (withUnit):
         retStr = "{f1:3.2f} V".format(f1 = self.voltage)
      else:
         retStr = self.voltage
      return retStr

   def getPhysicalUnit(self):
      return self.measurementUnit

   def getR_ShuntSoll(self):
      return self.sensorName + ":Calculated Shunt: {f1:6.3f}".format(f1=self.R_shuntSoll) + " Ohm   {f1:2.5f}".format(f1=self.P_shuntSoll) + " Watt"

   def isSensorAttached(self):
      return self.aSensorIsAttached

   def toString(self, withVoltage = False, withVoltageBounderies = False, withSensorName = True, withUnit = True):
      retStr = self.getPhysicalValue(withUnit)
      if (withVoltage):
         retStr = retStr + " (" + self.getVoltage(True) + ")"

      if (withSensorName):
         retStr = self.sensorName + ":" + retStr

      if (withVoltageBounderies):
         retStr = retStr + " [{f1:4.1f}..{f2:4.1f}]".format(f1 = self.voltageLow, f2 = self.voltageHigh)

      if (not self.isSensorAttached()):
         retStr = retStr + " ERROR: No sensor attached!!!"

      return retStr
