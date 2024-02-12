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
   def __init__(self, fileNameOrURL=None, inputCsvStr=None, fieldDelimiter='|', hasHeader=True, recordDelimiter='\n', remove_emty_comment_lines=True, comment_str='#'):
       self.__headerList = []
       self.__headerDict = {}
       self.__dataSets = []
       if fileNameOrURL is not None:
           inputCsvStr = File_getFileContent(fileNameOrURL, returnType="String", lineEnd="\n")
       elif inputCsvStr is not None:
           inputCsvStr = inputCsvStr
       else:
           inputCsvStr = ""

       lines = inputCsvStr.split(recordDelimiter)
       if remove_emty_comment_lines:
           lines = remove_empty_line(lines)

       # for a_line in lines:
           # print('-->', a_line)

       firstLine = True
       for line in lines:
           line = line.rstrip()
           if firstLine and hasHeader:
               self.__headerList = [x.rstrip().lstrip() for x in line.split(fieldDelimiter)]
               firstLine = False
           else:
               # print("Dataset:", line.split(fieldDelimiter))
               self.__dataSets.append([x.rstrip().lstrip() for x in line.split(fieldDelimiter)])
       ii = 0
       for aHeader in self.__headerList:
           self.__headerDict[aHeader] = ii
           ii += 1


   def __str__(self):
       retStr = f"""
        __headerList:
        {self.__headerList}
        
        __headerDict:
        {self.__headerDict}
        
        __dataSets[]:
        {self.__dataSets} 

       Count of Datasets:{len(self.__dataSets)}"""
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

   def getValues(self, whereClause=None, return_as_list=True):
       ret_indexes = self.findDataSets(whereClause=whereClause)
       ret_list = []
       for a_index in ret_indexes:
           if return_as_list:
               ret_list.append(self.__dataSets[a_index])
           else:
               ret_list.append(dict(zip(self.__headerList, self.__dataSets[a_index])))
       return ret_list

   def getValueByFieldIndex(self, dataSetIndex, attributeIndex):
       return self.__dataSets[dataSetIndex][attributeIndex]

   def findDataSets(self, whereClause=None):
       retList = []
       if whereClause is None:
           retList = getRange(0, len(self.__dataSets) - 1)
       else:
           ii = 0
           field_id, operator, value = whereClause.split(' ')
           # print(field_id, operator, value)
           for aDataSet in self.__dataSets:
               if operator == '==':
                   if self.getValueByName(ii, field_id) == value:
                       retList.append(ii)
               elif operator == '!=':
                   if self.getValueByName(ii, field_id) != value:
                       retList.append(ii)
               else:
                   print('ERROR: Unknown operator', field_id, operator, value)
               ii += 1
       return retList


if __name__ == '__main__':
    autoTest = False

    if False:
        pass  # NOP in Python
        print("Class_CSV_Data.py")
        adressen = CSV_Data(fileNameOrURL=r"C:\Users\Landwirtschaft\Documents\SoruceCode\DatenFiles\CSV_Excel\Adressliste_1.txt",
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
        halt()

    if not autoTest:
        testCases = f"""
        Nr    |Fct            |bis           |von           |Expected
        #-----+---------------+--------------+--------------+--------
        
        Type  |               |int           |int           |int
             1|summe          |9             |None          |45
             2|summe          |4             |None          |10
             3|summe          |20            |None          |210
             4|summe          |100           |None          |5050
             5|summe          |9             |4             |39
             6|summe          |4             |9             |39
             7|summe          |-1            |1             |0
        """
        test_cases = CSV_Data(inputCsvStr=testCases)
        print(test_cases)
        print()
        print(test_cases.getValueByName(3))
        print(test_cases.getValueByName(3, "bis"))

        print()
        print(test_cases.findDataSets())
        print(test_cases.findDataSets('Fct == summe'))
        print(test_cases.findDataSets('Nr == Type'))
        print(test_cases.findDataSets('Nr != Type'))

        print()
        print(test_cases.getValues('Nr != Type'))

        print()
        print(test_cases.getValues('Nr != Type', return_as_list=False))

        print()
        print(test_cases.getValues('Nr == Type', return_as_list=False))
