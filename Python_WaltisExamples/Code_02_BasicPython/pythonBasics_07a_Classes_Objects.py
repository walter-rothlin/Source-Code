#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_07a_Classes_Objects.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_07a_Classes_Objects.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

class DataLogger:
   'Common base class for all employees'
   loggerCount = 0

   def __init__(self, name, tolerance):
      self.name = name
      self.tolerance = tolerance
      DataLogger.loggerCount += 1
   
   def displayCount(self):
     print("Total DataLogger %d" % DataLogger.loggerCount)

   def displayDataLogger(self):
      print("Name: ",self.name + ", ","Tolerance: ",self.tolerance)

if __name__ == '__main__':
   logger1 = DataLogger("Vorlauf", 2)
   logger2 = DataLogger("Ruecklauf", 5)
   logger1.displayDataLogger()
   logger2.displayDataLogger()
   print("Total DataLogger:%d" % DataLogger.loggerCount)
