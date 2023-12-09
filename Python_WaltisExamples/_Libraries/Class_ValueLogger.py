#!/usr/bin/python3

class DataLogger:
   loggerCount = 0

   def __init__(self, name, tolerance):
      self.name = name
      self.tolerance = tolerance
      DataLogger.loggerCount += 1
   
   def displayCount(self):
     print("Total DataLogger %d" % DataLogger.loggerCount)

   def displayDataLogger(self):
      print("Name: ", self.name + ", ", "Tolerance: ", self.tolerance)


logger1 = DataLogger("Vorlauf", 2)
logger2 = DataLogger("Ruecklauf", 5)
logger1.displayDataLogger()
logger2.displayDataLogger()
print("Total DataLogger:%d" % DataLogger.loggerCount)
