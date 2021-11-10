#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_CSV_Data.py
#
# Description: Bildet eine Hysterese On/Off ab.
#
# Autor: Walter Rothlin
#
# History:
# 10-Nov-2021   Walter Rothlin	Initial Version
#
# ------------------------------------------------------------------
from waltisLibrary import *

class CSV_Data:

   # Ctr (Konstruktor)
   # -----------------
   def __init__(self, fileNameOrURL=None, inputCsvStr=None, fieldDelimiter="|", hasHeader=True, recordDelimiter="\n"):
       self.__headerList = []
       self.__headerDict = {}
       self.__dataSets = []
       f = open(fileNameOrURL, "r")
       firstLine = True
       for line in f:
           line = line.rstrip()
           if firstLine and hasHeader:
               # print("Header :", line.split(fieldDelimiter))
               self.__headerList = line.split(fieldDelimiter)
               firstLine = False
           else:
                # print("Dataset:", line.split(fieldDelimiter))
               self.__dataSets.append(line.split(fieldDelimiter))
       f.close()
       ii = 0
       for aHeader in self.__headerList:
           self.__headerDict[aHeader] = ii
           ii += 1


   def __str__(self):
       retStr = """
        __headerList:
        """ + str(self.__headerList) + """
        
        __headerDict:
        """ + str(self.__headerDict) + """
        
        __dataSets[3]:
        """ + str(self.__dataSets[3])

       retStr += "\nCount of Datasets:" + str(len(self.__dataSets))
       return retStr


   def getValueByName(self, dataSetIndex, fieldName=None):
       if fieldName is not None:
           attributeIndex = self.__headerDict[fieldName]
           return self.__dataSets[dataSetIndex][attributeIndex]
       else:
           return self.__dataSets[dataSetIndex]

   def getValuesByName(self, listOfIndexes, fieldName=None):
       retList = []
       for aIndex in listOfIndexes:
           retList.append(self.getValueByName(aIndex, fieldName))
       return retList
   
   def getValueByFieldIndex(self, dataSetIndex, attributeIndex):
       return self.__dataSets[dataSetIndex][attributeIndex]

   def findDataSets(self, whereClause=None):
       retList = []
       if whereClause is None:
           retList = getRange(0, len(self.__dataSets)-1)
       else:
           ii = 0
           for aDataSet in self.__dataSets:
               if self.getValueByName(ii, 'Vorname') == 'Ruedi':
                   retList.append(ii)
               ii += 1
       return retList


if __name__ == '__main__':
   autoTest = False

   if not autoTest:
      pass  # NOP in Python
      print("Class_CSV_Data.py")
      adressen = CSV_Data(fileNameOrURL="G:\_WaltisDaten\SourceCode\GitHosted\DatenFiles\CSV_Excel\Adressliste_1.txt",
                          fieldDelimiter=";")
      print(adressen)
      print()
      print(adressen.getValueByName(3, "Vorname"))
      print(adressen.getValueByFieldIndex(3, 3))
      print(adressen.findDataSets())
      resSet = adressen.findDataSets("Vorname = 'Ruedi'")
      print("resSet:", resSet)
      for aRec in resSet:
          print("    :", adressen.getValueByName(aRec))
      print(" ;", adressen.getValuesByName(resSet))
