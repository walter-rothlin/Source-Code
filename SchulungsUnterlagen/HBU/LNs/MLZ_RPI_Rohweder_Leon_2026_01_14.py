#!/usr/bin/python

# ------------------------------------------------------------------
# Name: MLZ_RPI_Rohweder_Leon_2026_01_14.py
#
# Description: Logger Class
#
# Autor: Leon Rohweder
#
# History:
# 14-Jan-2026   Leon Rohweder Initial Version
#
# ------------------------------------------------------------------

#import datetime
    
#class wetterdienst:
#    zeilen_count = 0
    
#    def __init__ (self, fileName, pathName, zeilen = 0, delimiter = ";", Append = True):
#        self.__zeilen = zeilen
#        self.__delimiter = delimiter
#        self.__fileName = fileName
#        self.__pathName = pathName
#        self.__Append = Append
     
        
#       csv_datei = "wetterdienstMLZ.csv"
#       startzeit = datetime.datetime.now().strftime("%H:%M:%S")
        
#       with open(csv_datei, "a", encoding = "utf-8") as f: 
#           f.write(f"#<Filename>MLZ_RPI_Rohweder_Leon_2026_01_14.py</Filename><Created>{startzeit}</Created>\n")
#           f.write(f"Datum{self.__delimiter}Zeit{self.__delimiter}Temperatur{self.__delimiter}Luftdruck{self.__delimiter}Luftfeuchte{self.__delimiter}Log-Level\n")
#      
 
        
    
#   def get_zeilen(self):
#       return self.__zeilen
        
#   def set_zeilen(self, new_zeilen):
#       self.__zeilen = new_zeilen
     
#   def get_delimiter(self):
#       return self.__delimiter
     
#   def set_delimiter(self, new_delimiter):   
#       self.__delimiter = new_delimiter
    
#   def get_fileName(self):
#       return self.__fileName
        
#   def set_fileName(self, new_fileName):
#       self.__fileName = new_fileName
        
#   def get_pathName(self):
#       return self.__pathName
        
#   def set_pathName(self, new_pathName):
#       self.__pathName  = new_pathName   
        
#   def get_Append(self):
#       return self.__Append
        
#   def set_Append(self, new_Append):
#       self.__Append = new_Append
        

    #def __str__(self):     
    
    
    ############################################################
    #   1h Fehlersuche da "|" nich dargestellt wird im csv, neu angefangen 
    ############################################################

import datetime

csv_datei = "wetterdienstMLZ.csv"
startzeit = datetime.datetime.now().strftime("%H:%M:%S")     
    
with open (csv_datei, "w", encoding = "utf-8") as f:
     f.write(f"#<Filename>MLZ_RPI_Rohweder_Leon_2026_01_14.py</Filename><Created>{startzeit}</Created>\n")
    
class WetterLogger: 
    def __init__ (self, fileName, pathName = "", zeilen = 0, delimiter = "|", Append = True):
        self.__zeilen = zeilen
        self.__delimiter = delimiter
        self.__fileName = fileName
        self.__pathName = pathName
        self.__Append = Append
        
        appendStatus = "a" if Append else "w"
        full_path = self.__pathName + self.__fileName

        with open(full_path, appendStatus, encoding="utf-8") as f:
            f.write(f"Datum{self.__delimiter}Zeit{self.__delimiter}Temperatur"
                    f"{self.__delimiter}Luftdruck{self.__delimiter}Luftfeuchte"
                    f"{self.__delimiter}Log-Level\n")
            
            
            
            
        'Setter / Getter' 
        
    def get_zeilen(self):
        return self.__zeilen
        
    def set_zeilen(self, new_zeilen):
        self.__zeilen = new_zeilen
     
    def get_delimiter(self):
        return self.__delimiter
     
    def set_delimiter(self, new_delimiter):   
        self.__delimiter = new_delimiter
    
    def get_fileName(self):
        return self.__fileName
        
    def set_fileName(self, new_fileName):
        self.__fileName = new_fileName
        
    def get_pathName(self):
        return self.__pathName
        
    def set_pathName(self, new_pathName):
        self.__pathName = new_pathName   
        
    def get_Append(self):
        return self.__Append
        
    def set_Append(self, new_Append):
        self.__Append = new_Append

  if __name__ == "__main__":
    logger = WetterLogger(csv_datei)