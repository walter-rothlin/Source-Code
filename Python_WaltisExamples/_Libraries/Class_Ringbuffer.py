#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Ringbuffer.py
#
# Description: Bildet einen Tiefpass mit unterschiedlichem Tau für steigend resp. abfallend ab.
#
#
# Autor: Walter Rothlin
#
# History:
# 13-Apr-2020	Initial Version
#
# ------------------------------------------------------------------
import math


class Ringbuffer:

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, initialList):
      self.internalList = initialList

   # Methoden (setter / getter)
   # --------------------------
   def setInitialList(self, initialList):
      self.internalList = initialList
      return self.internalList

   def getAsList(self):
      return self.internalList

   def appendElementAtEnd(self,newElement):
      self.internalList.append(newElement)
      return self.internalList

   def appendElementAtStart(self,newElement):
      self.internalList.insert(0, newElement)
      return self.internalList

   def shiftLeft(self, distance=1):
      # print("distance:", distance, "   length:", len(self.internalList))
      distance = distance % len(self.internalList)
      # print("distance:", distance, "   length:", len(self.internalList))

      firstElements = self.internalList[:distance]
      # print("firstElements:",firstElements)
      for aElement in firstElements:
         self.internalList.pop(0)
         self.internalList.append(aElement)
      return self.internalList

   def shiftRight(self, distance=1):
      lastElements = self.internalList[-distance:]
      # print("lastElements (original):", lastElements)
      lastElements.reverse()
      # print("lastElements (reversed):", lastElements)
      for aElement in lastElements:
         # print("aElement:", aElement)
         self.internalList.pop(-1)
         # print(self.internalList)
         self.internalList.insert(0, aElement)
         # print(self.internalList, "\n\n")
      return self.internalList

   def initList(self, lowChar='a', highChar='z'):
      self.internalList = []
      for aCharId in range(ord(lowChar), ord(highChar)+1):
          self.internalList.append(chr(aCharId))


# Test Program
# ============
print("Ringbuffer Test")
# asciiRingbuffer = Ringbuffer(['A', 'B', 'C', 'D'])
asciiRingbuffer = Ringbuffer(["A", "B", "C", "D"])
print(" ",asciiRingbuffer.getAsList())

# asciiRingbuffer.shiftRight()
# print(">", asciiRingbuffer.getAsList(), "\n")
# asciiRingbuffer.shiftRight()
# print(">", asciiRingbuffer.getAsList(), "\n")
#
# asciiRingbuffer.shiftLeft()
# print("<", asciiRingbuffer.getAsList(), "\n")

asciiRingbuffer.shiftRight(6)
print(">>", asciiRingbuffer.getAsList(), "\n")

asciiRingbuffer.shiftLeft(6)
print(">>", asciiRingbuffer.getAsList(), "\n")

asciiRingbuffer.appendElementAtStart("AA")
asciiRingbuffer.appendElementAtEnd("ZZ")
print("", asciiRingbuffer.getAsList(), "\n")

asciiRingbuffer.initList()
print("", asciiRingbuffer.getAsList(), "\n")
asciiRingbuffer.initList(lowChar=' ', highChar='~')
print("", asciiRingbuffer.getAsList(), "\n")
