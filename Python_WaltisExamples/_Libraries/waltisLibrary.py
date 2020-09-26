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
# ------------------------------------------------------------------
import math
import os
import sys
import time
import datetime

from time import sleep


# Library fucntions
# -----------------
def waltisPythonLib_Version():
    print("waltisLibrary.py: 1.0.0.2")

# Bildschirmsteuerung
# -------------------
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
# -------------------------
def grad2Rad(grad):
    return math.pi*grad/180

def rad2Grad(rad):
    return 180*rad/math.pi

def fahrenheit2Celsius(fahrenheit):
    return (fahrenheit-32)/1.8

def celsius2Fahrenheit(celsius):
    return (celsius*1.8)+32


# Primzahlen Functions
# --------------------
def isPrimzahl(aZahl):
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
# ----------------
def left(s,amount):
    return s[:amount]

def right(s,amount):
    return s[-amount:]

def mid(s, offset, amount):
    return s[offset:offset+amount]

# Date and Timestamp
# ------------------    
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
