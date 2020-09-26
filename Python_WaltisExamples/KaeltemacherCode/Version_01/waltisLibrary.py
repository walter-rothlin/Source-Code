#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: waltisLibrary.py
#
# Description: Library - Module (Source in ExamplesPyton/waltisLibrary.py)
#
# Autor: Walter Rothlin
#
# History:  
# 06-Dec-2017   Walter Rothlin      Initial Version (Eigene Funktions von umrechnen.py ausgelagert)
# 28-May-2019   Walter Rothlin      Added Primzahlen functions
# 07-Jun-2019   Walter Rothlin      Merged with littlePythonLib.py
#
# ------------------------------------------------------------------
import math
import os
import sys
import time
import datetime

# Library fucntions
# -----------------
def waltisPythonLib_Version():
    print("waltisLibrary.py: 1.0.0.1")

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
    isPrim = True
    if (aZahl == 1):
        isPrim = True
    else:
        if (aZahl == 2):
            isPrim = True
        else:
            obergrenze = int((aZahl / 2) + 2)
            for i in range(2,obergrenze):
                if ((aZahl % i) == 0):
                    isPrim = False
    return isPrim

def getNextPrimzahl(zahl):
    aZahl = zahl + 1
    while (isPrimzahl(aZahl) == False):
        aZahl = aZahl + 1
    return aZahl
  
def getPrevPrimzahl(zahl):
    aZahl = zahl - 1
    if (aZahl <= 1):
        return 1
    else:
        while (isPrimzahl(aZahl) == False):
            aZahl = aZahl - 1
    return aZahl
	
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
            retStr = retStr[-(len(retStr) - 1):]
    return retStr

def getDivisors(zahl, sep = ";"):
    retStr = ""
    aZahl = abs(zahl)
    aDivisor = 2
    while (aDivisor < aZahl):
      if ((aZahl % aDivisor) == 0):
         retStr = retStr + sep + str(aDivisor)
      aDivisor = aDivisor + 1

    retStr = retStr[-(len(retStr) - 1):]
    return retStr

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
    return preStr + formatStr.format(datetime.datetime.now()) + postStr

# True if (old-young > limit)
def checkTimeDifference(oldTimestamp, youngTimestamp, limit, gt=True):
    timeDiff =  youngTimestamp - oldTimestamp
    secStr = str(timeDiff)[:7]
    if (gt):
	    return (secStr > limit)
    else:
	    return (secStr < limit)
		
# Test der Functions
# ==================
for i in range(100):
  if (isPrimzahl(i)):
    print("{z:3d}: Ist eine Primzahl!!!".format(z=i))
  else:
    print("{z:3d}: Primzahlen:{s:30s}      Teiler    :{s1:30s}".format(z=i,s=getPrimfactors(i),s1=getDivisors(i)))