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
# 14-May-2020   Walter Rothlin      Added getPrimfactorsAsListe(zahl), getDivisorsAsListe(zahl)
# 28-May-2020   Walter Rothlin      Added toUpperCase,....
# 04-Jun-2020   Walter Rothlin      Added crypt functions
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
    print("waltisLibrary.py: 1.0.0.3")

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

def getPrimezahlenAsListe(start, end):
    retList = []

    i = start
    while i <= end:
        if (isPrimzahl(i)):
            retList.append(i)
        i = i + 1
    return retList

def getPrimfactorsAsListe(zahl):
    retList = []

    primezahl = 2
    gefunden = False
    while (gefunden == False):
      if (isPrimzahl(zahl)):
          retList.append(zahl)
          gefunden = True
      else:
          if (zahl % primezahl == 0):
              retList.append(primezahl)
              zahl = zahl // primezahl    # // ist ganzahlige Division
          else:
               primezahl = getNextPrimzahl(primezahl)
    return retList

def getPrimfactors(zahl, sep = "*"):
    # retStr = ""
    # for i in getPrimfactorsAsListe(zahl):
    #     if (retStr == ""):
    #         retStr = str(i)
    #     else:
    #         retStr = retStr + sep + str(i)
    # return retStr
    return sep.join([str(elem) for elem in getPrimfactorsAsListe(zahl)])

def getDivisorsAsListe(zahl):
    retList = []
    aZahl = abs(zahl)
    aDivisor = 2
    while (aDivisor < aZahl):
      if ((aZahl % aDivisor) == 0):
         retList.append(aDivisor)
      aDivisor = aDivisor + 1
    return retList

def getDivisors(zahl, sep = ";"):
    retStr = ""
    for i in getDivisorsAsListe(zahl):
        if (retStr == ""):
            retStr = str(i)
        else:
            retStr = retStr + sep + str(i)
    return retStr


# Test der Functions primezahlen
# ------------------------------
def TEST_Primzahlen():
    for i in range(100):
        if (isPrimzahl(i)):
            print("{z:3d}: Ist eine Primzahl!!!".format(z=i))
        else:
            print("{z:3d}: Primzahlen:{s:30s}      Teiler    :{s1:30s}".format(z=i,s=getPrimfactors(i),s1=getDivisors(i)))

def TEST_Primzahlen_1():
    lowLimit  = int(input("Low :"))
    highLimit = int(input("High:"))
    for i in range(lowLimit,highLimit):
        if (isPrimzahl(i)):
            print(i, "ist eine Primezahl!!")
        else:
            print(i,"=",getPrimfactors(i),"    ",getDivisorsAsListe(i))

# String Functions
# ----------------
def left(s,amount):
    return s[:amount]

def right(s,amount):
    return s[-amount:]

def mid(s, offset, amount):
    return s[offset:offset+amount]

def toUpperCase(inString):
    retString = ""
    for aChar in inString:
        if (aChar >= 'a') and (aChar <= 'z'):
            retString = retString + chr(ord(aChar) - (ord('a') - ord('A')))
        else:
            retString = retString + aChar
    return retString

def toLowerCase(inString):
    retString = ""
    for aChar in inString:
        if (aChar >= 'A') and (aChar <= 'Z'):
            retString = retString + chr(ord(aChar) + (ord('a') - ord('A')))
        else:
            retString = retString + aChar
    return retString

def toFirstUpperCase(inString):
    firstPart = inString[:1]
    endPart   = inString[1:]
    return toUpperCase(firstPart) + toLowerCase(endPart)

def TEST_stringFct():
    eingabeString = input("String:")
    print("toUpperCase(", eingabeString, ")           --> ", toUpperCase(eingabeString), sep="")
    print("toLowerCase(", eingabeString, ")           --> ", toLowerCase(eingabeString), sep="")
    print("toFirstUpperCase(", eingabeString, ")      --> ", toFirstUpperCase(eingabeString), sep="")

# symetrische Verschluesselung
# ---------------------------
def shiftChr(buchstabe,shift):
    # return chr(ord(buchstabe) + shift)
    return chr(((ord(buchstabe) - ord(' ') + shift)) % (ord('~') - ord(' ') + 1) + ord(' '))

def encrypt(klartext,key):
    geheimtext = ""
    keyIndex = 0
    for aChar in klartext:
        if (aChar >= " ") and (aChar <= "~"):
            aKeyChr = key[keyIndex]
            shifter = ord(aKeyChr)
            aSecretChr = shiftChr(aChar, shifter)
            geheimtext = geheimtext + aSecretChr
        else:
            geheimtext = geheimtext + aChr
        keyIndex = keyIndex + 1
        if (keyIndex >= len(key)):
            keyIndex = 0
    return geheimtext

def decrypt(geheimtext,key):
    klartext = ""
    keyIndex = 0
    for aSecretChr in geheimtext:
        if (aSecretChr >= " ") and (aSecretChr <= "~"):
            aKeyChr = key[keyIndex]
            shifter = ord(aKeyChr)
            aChar = shiftChr(aSecretChr, -shifter)
            klartext = klartext + aChar
        else:
            klartext = klartext + aSecretChr
        keyIndex = keyIndex + 1
        if (keyIndex >= len(key)):
            keyIndex = 0
    return klartext

def TEST_encryption_1():
    klartext = input("Klartext:")
    aKey = input("Key:")
    geheimtext = encrypt(klartext, aKey)
    print("encrypt(\"", klartext, "\",\"", aKey, "\") -->", geheimtext, "<--", sep="")
    print("decrypt(\"", geheimtext, "\",\"", aKey, "\") -->", decrypt(geheimtext, aKey), "<--", sep="")

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
