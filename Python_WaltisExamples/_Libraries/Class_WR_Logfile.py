#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Logfile.py
#
# Description: Manages a Logfiles
#
# Autor: Walter Rothlin
#
# History:
# 13-Aug-2019	Initial Version
#
# ------------------------------------------------------------------

class WR_Logfile:


   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, aPath, fName):
      self.path             = aPath
      self.fName            = fName

   def addLogEntry(self, entry, doAppend = True):
       if (doAppend == False):
           f = open(self.path + self.fName, "w")
       else:
           f = open(self.path + self.fName, "a")
       f.write(entry + "\n")
       f.close()

