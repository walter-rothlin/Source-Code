#======================================================================
# Name: Jim_Scheller_A19_DS.py
# Beschreibung: Polling REST Service and write values to CSV
# Author: Jim Scheller
# Verlauf:
# 29.11.2021 -  Initial Version
# 30.11.2021 -  Create whole Script
# 01.12.2021 -  Finalize
# 02.12.2021 -  Finalize 2.0
#======================================================================

#======================================================================
#Imports
#======================================================================
import requests
import json
import time
import datetime
#======================================================================

#======================================================================
#Functions
#======================================================================
#----------------------------------------------------------------------
#Funktion: für den Zeitstempel. Format wird definiert und Zeitstempel abgeholt(via datetime import).
def getMomentTimestamp(typeformat="normal"):
    if typeformat == "normal":                                                  #könnte man noch verschiedene Typen erfassen. Ein Switch-Case wäre dann besser.
        format = '{:%H:%M:%S_:%d.%m.%Y}'
    returnString = format.format(datetime.datetime.now())                       #Format in returnString einlesen
    return returnString
#----------------------------------------------------------------------
#======================================================================

#======================================================================
# Logger Klasse
#======================================================================
class ownLoggerClass:
    def __init__(self, filename, onlyChanges=False, spaceTimestamp = 30, spaceLevel = 20, delimiter="|", timedesign="normal" , titleCreate = "", newFile=False):
        self.spaceTimestamp = spaceTimestamp
        self.spaceLevel = spaceLevel
        self.rememberedLine = ""
        self.filename = filename
        self.delimiter = delimiter
        self.timeFormatString = timedesign
        self.onlyChanges = onlyChanges
        self.newFile = newFile
        mixtitle = ("{le:" + str(self.spaceTimestamp) + "s}").format(le="Zeit") + self.delimiter    #Teilobjekt für den Title
        mixtitle += ("{le:" + str(self.spaceLevel) + "s}").format(le="Type") + self.delimiter       #Teilobjekt für den Title
        titleCreate = mixtitle + titleCreate                                                        #Zusammenführung der Teilobjekte Title
        headerString = "# <Name>" + filename + "</Name>"                                            #XML String für den header
        self.newLog(headerString, Header=True)
        self.newLog(titleCreate, Header=True)
#----------------------------------------------------------------------
#Output Method
    def newLog(self, newLine, level="INFO", Header=False, onlyChanges=True):
        sameval = False
        if self.rememberedLine == newLine:
            sameval = True
        self.rememberedLine = newLine
        fixline = ""
        if Header == False:
            fixline = ("{le:" + str(self.spaceTimestamp) + "s}").format(le=getMomentTimestamp(typeformat=self.timeFormatString)) + self.delimiter
            fixline += ("{le:" + str(self.spaceLevel) + "s}").format(le=level) + self.delimiter
        newLine = fixline + newLine
        print(newLine)
        filesession = ""
        # Hilfe für Open File(Write und Append) von hier: https://www.w3schools.com/python/python_file_write.asp
        if (self.onlyChanges == False or sameval == False):
            if self.newFile == True:
                filesession = open(self.filename, "w")
            else:
                filesession = open(self.filename, "a")
            filesession.write(newLine + "\n")
            filesession.close()
        self.newFile = False
#----------------------------------------------------------------------
#======================================================================

#======================================================================
#Start des Skriptes
#======================================================================
#----------------------------------------------------------------------
#Konfiguration des Skriptes(defaults)
if __name__ == '__main__':
    appId = "appid=622498e56cc32977af3e2e474506ed5a" #diesen habe ich selbst generiert(ich hoffe es klappt bei Ihnen ebenfalls)
    url = "http://api.openweathermap.org/data/2.5/weather?"
    defPulltime = 1
    #Hilfe für JSON Spalten von hier: https://www.programiz.com/python-programming/json
    spalten = {"Luftfeuchte": {"field": "humidity", "spaltenbreite": max(len("xxxxxxxxxxxxxxxxxxxxxxxxxxx") + 1, 0)}, "Temparatur":    {"field": "temp", "spaltenbreite": max(len("xxxxxxxxxxxxxxxxxxxxxxxxxxx") + 1, 0)}, "Luftdruck":   {"field": "pressure", "spaltenbreite": max(len("xxxxxxxxxxxxxxxxxxxxxxxxxxx") + 1, 0)}}
    delimiter = "|"             #vorgegeben durch Prüfungsdok(nicht abändern zu ";"!!)
    decimalplaces = 4
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#User Eingabe
    newFile= ""
    newFile = input("Möchten Sie ein neues File erstellen?(y/n):")
    place = input("Standort(bsp. Zurich):")
    onlyChangesLog = input("Nur Änderungen speichern?(y/n):")
    apiurl = url + "q=" + place + "&" + appId
    defPulltime = input("Sekunden Takt für Updates:")
    title = ""


# ----------------------------------------------------------------------
# Testing
    print("Sie haben folgende Einstellungen für das Programm gewählt:")
    print("Nur Änderungen speicher?:" + onlyChangesLog)
    print("Ihr apiUrl:" + apiurl)
    print("Sekundentakt:" + defPulltime)
    print("Neues File erstellen:" + newFile)
#------------------------------------------------------------------------
#Umwandlung der Variablen
    defPulltime = float(defPulltime)
    if (newFile == "y"):
        newFile = True
    else:
        newFile = False
    if (onlyChangesLog == "y"):
        onlyChangesLog = True
    else:
        onlyChangesLog = False

    for line in spalten:
        title += ("{pl:" + str(spalten[line]["spaltenbreite"]) + "s}").format(pl=line) + delimiter
    apilogger = ownLoggerClass("Pull-WheaterUpdates.csv", onlyChanges=onlyChangesLog, titleCreate=title, delimiter=delimiter, newFile=newFile)
    designoutput = ""
    print("--------------------------------------------------------------------------------------------------------------------------------------------")
# ----------------------------------------------------------------------
# Start des eigentlichen Prozederes
    Loop = True
    while Loop:
        time.sleep(defPulltime)                                                                             # Sleep für den Takt
        StringforLog = ""
        answerapi = requests.get(apiurl)                                                                    #Hilfe von folgender Website genommen: https://www.w3schools.com/python/module_requests.asp
        answerjson = json.loads(answerapi.text)                                                             #Hilfe von folgender Website genommen: https://www.w3schools.com/python/python_json.asp
        for line in spalten:
            designoutput = "{vl:" + str(spalten[line]["spaltenbreite"]) + "." + str(decimalplaces) + "f}"
            valjson = answerjson['main'][spalten[line]["field"]]
            StringforLog += designoutput.format(vl=valjson) + delimiter                                     #Hilfe von folgender Website genommen: https://github.com/
        apilogger.newLog(StringforLog)                                                                      #Hier werden die gesammelten Infos an Funktion übergeben

#----------------------------------------------------------------------