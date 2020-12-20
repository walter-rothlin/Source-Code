#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: waltisLibrary.py
#
# Description: Library - Module (Source in ExamplesPyton/_Libraries/waltisLibrary.py)
#
# Autor: Walter Rothlin
#
# History:  
# 06-Dec-2017   Walter Rothlin      Initial Version (Eigene Funktions von umrechnen.py ausgelagert)
# 28-May-2019   Walter Rothlin      Added Primzahlen functions
# 07-Jun-2019   Walter Rothlin      Merged with littlePythonLib.py
# 09-Apr-2020   Walter Rothlin      Refactoring isPrimezahl()
# 28-Sep-2020   Walter Rothlin      Added equalsWithinTolerance
# 19-Nov-2020   Walter Rothlin      Added calcCircle mit None parameter
# 10-Dec-2020   Walter Rothlin      Added fakultaet
# 18-Dec-2020   Walter Rothlin      Added

# ------------------------------------------------------------------
import inspect
import math
import os
import sys
import time
import datetime
from pathlib import Path

from time import sleep

# Add dir to PYTHONPATH in a program
# ----------------------------------
# import sys
# sys.path.append('G:\_WaltisDaten\SourceCode\GitHosted\Python_WaltisExamples\_Libraries')
# https://www.datacamp.com/community/tutorials/modules-in-python?utm_source=adwords_ppc&utm_campaignid=898687156&utm_adgroupid=48947256715&utm_device=c&utm_keyword=&utm_matchtype=b&utm_network=g&utm_adpostion=&utm_creative=332602034343&utm_targetid=aud-299261629574:dsa-429603003980&utm_loc_interest_ms=&utm_loc_physical_ms=1030659&gclid=CjwKCAjw8MD7BRArEiwAGZsrBdWiIwMkjQ8l9_Gm52f1FEpiFVHlAgnMVf7UPzAtdNaeC7zq0691oRoC2D4QAvD_BwE#import

# Add dir to PYTHONPATH in PYCHARM
# --------------------------------
# Click an directory in project folders. Than Rigth Click in Project-Explorer  --> Mark Directory as --> Source Root
# https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000782850-How-to-set-up-working-directory-in-PyCharm-and-package-import-

# Library fucntions
# =================
def waltisPythonLib_Version():
    print("waltisLibrary.py: 1.0.0.3")

# Bildschirmsteuerung
# ===================
def VT52_cls():
    print("\033[2J",end="", flush=True)

def VT52_home():
    print("\033[H",end="", flush=True)

def VT52_cls_home():
    VT52_cls()
    VT52_home()

def halt(prompt="Weiter?"):
    ant=input(prompt)

# Pysikalische Umrechnungen
# =========================
def grad2Rad(grad):
    return math.pi*grad/180

def rad2Grad(rad):
    return 180*rad/math.pi

def fahrenheit2Celsius(fahrenheit):
    return (fahrenheit-32)/1.8

def celsius2Fahrenheit(celsius):
    return (celsius*1.8)+32

# Fakultät berechnen
# ==================
def fakultaet(obergrenze, untergrenze=1):
    fakultaet = -1
    if (obergrenze > 0):
        fakultaet = 1
        while obergrenze >= untergrenze:
            fakultaet = fakultaet * obergrenze
            obergrenze = obergrenze - 1
    return fakultaet


# Primzahlen Functions
# ====================
def isPrimzahl(aZahl):
    '''
    Returns True/False if a given integer is a prime figure (only dividable by 1 or itself.

            Parameters:
                    aZahl (int): A positive Integer

            Returns:
                    True / False
    '''
    isPrim = False
    if ((aZahl == 1) or (aZahl == 2)):
        isPrim = True
    else:
        isPrim = True
        obergrenze = int(aZahl / 2) + 1
        # print("Obergrenze:",obergrenze)
        for i in range(2,obergrenze + 1):
            # print("    Test: aZahl % i = ",aZahl,"%",i,"=",aZahl % i)
            if ((aZahl % i) == 0):
                isPrim = False
    return isPrim

def getNextPrimzahl(zahl):
    if ((zahl % 2) == 0):   # then Gerade
        aZahl = zahl + 1
    else:
        aZahl = zahl + 2
    # print("getNextPrimzahl::Startwert:",aZahl)
    while (isPrimzahl(aZahl) == False):
        aZahl = aZahl + 2
    return aZahl
  
def getPrevPrimzahl(zahl):
    if ((zahl % 2) == 0):   # then Gerade
        aZahl = zahl - 1
    else:
        aZahl = zahl - 2
    if (aZahl <= 1):
        return 1
    else:
        # print("getPrevPrimzahl::Startwert:",aZahl)
        while (isPrimzahl(aZahl) == False):
            aZahl = aZahl - 2
    return aZahl

def getPrimezahlenListe(start, end, sep = ";"):
    retStr = ""
    for i in range(start,end+1):
        if (isPrimzahl(i)):
            retStr = retStr + sep + str(i)
    retStr = retStr[-(len(retStr) - len(sep)):]
    return retStr

def getPrimfactors(zahl, sep = ";"):
    retStr = ""
    aZahl = abs(zahl)
    aDivisor = 2
    if (zahl == 1):
        retStr = "1"
    else:
        if (zahl == 2):
            retStr = "2"
        else:
            while (isPrimzahl(aZahl) == False):
                if ((aZahl % aDivisor) == 0):
                    if (aZahl > 1):
                        retStr = retStr + sep + str(aDivisor)
                    aZahl = int(aZahl / aDivisor)    # Ganzzahlige division
                else:
                    aDivisor = getNextPrimzahl(aDivisor)
            if (aZahl > 1):
                retStr = retStr + sep + str(aZahl)
            retStr = retStr[-(len(retStr) - len(sep)):]
    return retStr

def getDivisors(zahl, sep = ";"):
    retStr = ""
    aZahl = abs(zahl)
    aDivisor = 2
    while (aDivisor < aZahl):
      if ((aZahl % aDivisor) == 0):
         retStr = retStr + sep + str(aDivisor)
      aDivisor = aDivisor + 1

    retStr = retStr[-(len(retStr) - len(sep)):]
    return retStr

# Test der Functions primezahlen
# ------------------------------
def TEST_Primzahlen():
    for i in range(100):
        if (isPrimzahl(i)):
            print("{z:3d}: Ist eine Primzahl!!!".format(z=i))
        else:
            print("{z:3d}: Primzahlen:{s:30s}      Teiler    :{s1:30s}".format(z=i,s=getPrimfactors(i),s1=getDivisors(i)))

# String Functions
# ================
def left(s,amount):
    return s[:amount]

def right(s,amount):
    return s[-amount:]

def mid(s, offset, amount):
    return s[offset:offset+amount]

# Date and Timestamp
# ==================
def getTimestamp(preStr = "", postStr="", formatString="nice"):
    formatStr = '{:%Y-%m-%d %H:%M:%S}'
    if (formatString == ""):
        formatStr = '{:%Y%m%d%H%M%S}'
    elif (formatString == "nice"):
        formatStr = '{:%Y-%m-%d %H:%M:%S}'
    else:
        formatStr = formatString
    retStr = formatStr.format(datetime.datetime.now())
    # retStr = left(retStr,len(retStr)-2)
    return preStr + retStr + postStr

# True if (old-young > limit)
def checkTimeDifference(oldTimestamp, youngTimestamp, limit, gt=True):
    timeDiff =  youngTimestamp - oldTimestamp
    secStr = str(timeDiff)[:7]
    if (gt):
        return (secStr > limit)
    else:
        return (secStr < limit)

# Math functions
# --------------
def equalsWithinTolerance(ist,soll,abweichungProzent=0.001):
    if (soll==0) and (ist==0):
        return True
    else:
        if (abs(100-(ist*100/soll)) > abweichungProzent):
            return False
        else:
            return True

# Inspection functions
# ====================
def getMyFctName():
    return inspect.stack()[1][3]


# REST / JSON functions
# =====================
# https://stackoverflow.com/questions/7320319/xpath-like-query-for-nested-python-dictionaries
def xPath_Get(mydict, path):
     elem = mydict
     try:
         for x in path.strip("/").split("/"):
             try:
                 x = int(x)
                 elem = elem[x]
             except ValueError:
                 elem = elem.get(x)
     except:
         pass
     return elem


def AUTO_TEST_xPath_Get(verbal=False):
    if verbal:
        print("==> ", getMyFctName())

    foo = {
         'spam': 'eggs',
         'morefoo': [{
             'bar': 'soap',
             'morebar': {
                 'bacon': {
                     'bla': '12345'
                 }
             }
         },
             'Walt'
         ]
    }

    testCasesExecuted = 5
    testCasesFailed   = 2
    testCases = """"
    Expected | Param_1                     
    1234     | /morefoo/0/morebar/bacon/bla
    Walti    | /morefoo/1
    """
    param1 = "/morefoo/0/morebar/bacon/bla"
    expextedVal1 = "1234"
    retVal = xPath_Get(foo, param1)
    if ( retVal != expextedVal1):
        print("   ERROR in TEST: xPath_Get(foo, ", param1, ") = ", retVal, "    ==> expected: ", expextedVal1, sep="")

    param1 = "morefoo/1"
    expextedVal1 = "Walti"
    retVal = xPath_Get(foo, param1)
    if ( retVal != expextedVal1):
        print("   ERROR in TEST: xPath_Get(foo, ", param1, ") = ", retVal, "    ==> expected: ", expextedVal1, sep="")

    if verbal:
        print("--> Test Cases Executed: {a:4d}".format(a=testCasesExecuted))
        print("--> Test Cases Failed  : {a:4d}".format(a=testCasesFailed))
    return {"TestName": getMyFctName(), "testCasesExecuted": testCasesExecuted, "testCasesFailed": testCasesFailed}

# File operationen
# ================
#    TBC verallgemeinern start
# Cleanup - Rule N°1 : Verzeichnis wird durchsucht und alle Files mit .csv werden gelöscht
def file_cleanup1():
    logfiles = Path('C:\\Users\charl\PycharmProjects\Python_HWZ\programming_tools\projektarbeit_python')
    for file in logfiles.glob('*.csv'):
        if file.is_file():
            try:
                file.unlink()
                print("Files gelöscht")
            except OSError as error:
                print("File {} konnte nicht gelöscht werden: {}".format(file, error))

# Cleanup - Rule N°2 : Verzeichnis wird durchsucht und alle Files(.csv) älter als 7 Tage werden gelöscht
def File_cleanup2():
    logfiles = Path('C:\\Users\charl\PycharmProjects\Python_HWZ\programming_tools\projektarbeit_python')
    for file in logfiles.glob('*.csv'):
        create_time = os.path.getctime(file)
        if (time.time() - create_time) // (24 * 3600) >= 7:
            os.unlink(file)
            print('{} removed'.format(file))

def File_getAllLogFiles(path):
    files = os.listdir(path)
    files = list(filter(lambda file: file.endswith('.csv'), files))
    return [path + file for file in files]  # append path to the file to delete it later


def File_removeOldLogs(files,maxLogFiles=10):
    while len(files) > maxLogFiles:
        oldestFile = min(files, key=os.path.getctime)
        os.remove(oldestFile)
        files = File_getAllLogFiles(".")

def File_cleanup(filename, directory, path_sign):
    """Cleanup Funktion löscht angegebene Dateien aus angegebenen Verzeichnisse"""
    path_sign = path_sign
    if directory == "":
        directory = os.curdir + path_sign
    if not filename == "":
        filename = str(directory) + path_sign + str(filename)
        if os.path.exists(filename):
            print("Datei {} löschen".format(filename))
            os.remove(filename)
        else:
            print("Die Datei {} existiert nicht".format(filename))
    else:
        for file in os.listdir(directory):
            if file.startswith("logger"):
                os.chdir(directory)
                print("Datei {} löschen".format(file))
                os.remove(file)

#    TBC verallgemeinern start


def File_getCountOfLines(sourceFileFN):
    lines = []
    with open(sourceFileFN, "r", encoding="utf-8") as f:
        lines = f.readlines()
    return len(lines)

def File_deleteLines(sourceFileFN, destinationFileFN=None, deleteLineFrom=None, deleteLineTo=None, verbal=False):
    if destinationFileFN is None:
        destinationFileFN = sourceFileFN

    if (deleteLineFrom is None) and (deleteLineTo is None):
        deleteLineFrom = 0
        deleteLineTo = 0
    elif (deleteLineFrom is not None) and (deleteLineTo is None):
        deleteLineTo = 1000000
    elif (deleteLineFrom is None) and (deleteLineTo is not None):
        deleteLineFrom = 0
    else:
        pass  # NOP

    if verbal:
        print("    Delete from", deleteLineFrom, "to", deleteLineTo, end="")
    with open(sourceFileFN, "r", encoding="utf-8") as f:
        lines = f.readlines()

    with open(destinationFileFN, "w", encoding="utf-8") as f:
        i = 1
        for line in lines:
            if (i < deleteLineFrom) or (i > deleteLineTo):
                f.write(line)
            i += 1


# Geometrische Formen berechnen
# =============================

#  Kreis
#  -----
def calcCircle_Flaeche(radius=None, durchmesser=None, flaeche=None, umfang=None):
    if radius is not None:
        return radius**2 * math.pi
    elif durchmesser is not None:
        return (durchmesser/2) ** 2 * math.pi
    elif flaeche is not None:
        return flaeche
    elif umfang is not None:
        return ((umfang/math.pi)/2) ** 2 * math.pi
    else:
        return 0

def TEST_calcCircle_Flaeche():
    radius = 10
    print(calcCircle_Flaeche(radius=radius))
    print(calcCircle_Flaeche(durchmesser=2 * radius))
    print(calcCircle_Flaeche(umfang=2 * radius * math.pi))
    print(calcCircle_Flaeche(flaeche=radius**2 * math.pi))

def calcCircle_Umfang(radius=None, durchmesser=None, flaeche=None, umfang=None):
    if radius is not None:
        return radius * 2 * math.pi
    elif durchmesser is not None:
        return durchmesser * math.pi
    elif flaeche is not None:
        return (math.sqrt(flaeche / math.pi)) * 2 * math.pi
    elif umfang is not None:
        return umfang
    else:
        return 0

def TEST_calcCircle_Umfang():
    radius = 10
    print(calcCircle_Umfang(radius=radius))
    print(calcCircle_Umfang(durchmesser=2 * radius))
    print(calcCircle_Umfang(umfang=2 * radius * math.pi))
    print(calcCircle_Umfang(flaeche=radius**2 * math.pi))


def calcCircle_Radius(radius=None, durchmesser=None, flaeche=None, umfang=None):
    if radius is not None:
        return radius
    elif durchmesser is not None:
        return durchmesser/2
    elif flaeche is not None:
        return math.sqrt(flaeche / math.pi)
    elif umfang is not None:
        return (umfang/math.pi)/2
    else:
        return 0

def TEST_calcCircle_Radius():
    radius = 10
    print(calcCircle_Radius(radius=radius))
    print(calcCircle_Radius(durchmesser=2 * radius))
    print(calcCircle_Radius(umfang=2 * radius * math.pi))
    print(calcCircle_Radius(flaeche=radius**2 * math.pi))

def calcCircle_Durchmesser(radius=None, durchmesser=None, flaeche=None, umfang=None):
    if radius is not None:
        return radius * 2
    elif durchmesser is not None:
        return durchmesser
    elif flaeche is not None:
        return math.sqrt(flaeche / math.pi) * 2
    elif umfang is not None:
        return umfang/math.pi
    else:
        return 0

def TEST_calcCircle_Durchmesser():
    radius = 10
    print(calcCircle_Durchmesser(radius=radius))
    print(calcCircle_Durchmesser(durchmesser=2 * radius))
    print(calcCircle_Durchmesser(umfang=2 * radius * math.pi))
    print(calcCircle_Durchmesser(flaeche=radius**2 * math.pi))

def TEST_CircleFct():
    TEST_calcCircle_Flaeche()
    TEST_calcCircle_Umfang()
    TEST_calcCircle_Radius()
    TEST_calcCircle_Durchmesser()


if __name__ == '__main__':
    AUTO_TEST_xPath_Get(verbal=True)