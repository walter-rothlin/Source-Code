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

from sense_hat import SenseHat
from time      import sleep


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

def getPrimezahlenListe(start, end, sep = ";"):
    retStr = ""
    for i in range(start,end+1):
        if (isPrimzahl(i)):
            retStr = retStr + sep + str(i)
    retStr = retStr[-(len(retStr) - 1):]
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
    return preStr + formatStr.format(datetime.datetime.now()) + postStr

# True if (old-young > limit)
def checkTimeDifference(oldTimestamp, youngTimestamp, limit, gt=True):
    timeDiff =  youngTimestamp - oldTimestamp
    secStr = str(timeDiff)[:7]
    if (gt):
        return (secStr > limit)
    else:
        return (secStr < limit)


# Sense-Hat
# ---------
def clearPixel(aSense,x,y):
    aSense.set_pixel(x,y,0,0,0)

def setPixel(aSense,x,y,r=255,g=255,b=255):
    if ((x>=0) and (x<=7) and (y>=0) and (y<=7)):
        aSense.set_pixel(round(x),round(y),r,g,b)

def drawLine(aSense,x1,y1,x2,y2,r=255,g=255,b=255):
    x1 = round(x1)
    y1 = round(y1)
    x2 = round(x2)
    y2 = round(y2)

    if (x1 == x2):
        if (y1 > y2):
            temp = y1
            y1 = y2
            y2 = temp
        for y in range(y1,y2+1):
            setPixel(aSense,x1,y,r,g,b)
    else:
        if (x1 > x2):
            temp = x1
            x1 = x2
            x2 = temp
            temp = y1
            y1 = y2
            y2 = temp
        a = (y1-y2)/(x1-x2)
        c = y1 - a*x1
        if ((a > 1) or (a < -1)):
            if (y1 > y2):
                temp = y1
                y1 = y2
                y2 = temp
            for y in range(y1,y2+1):
                x = (y - c)/a
                setPixel(aSense,x,y,r,g,b)
        else:
            for x in range(x1,x2+1):
                y = a*x + c
                setPixel(aSense,x,y,r,g,b)

def TEST_drawLine(aSense):
    print("Start TEST_drawLine")
    aSense.clear()
    drawLine(aSense,0,0,7,7,255,0,0)
    sleep(2)
    drawLine(aSense,0,7,7,0)
    sleep(2)
    drawLine(aSense,6,0,0,6,255,255,0)
    sleep(2)
    drawLine(aSense,1,4,6,4,0,0,255)
    sleep(2)
    drawLine(aSense,6,3,1,3,0,255,255)
    sleep(2)
    drawLine(aSense,5,0,5,7,255,0,255)
    sleep(2)
    drawLine(aSense,3,7,3,2,255,0,255)
    sleep(2)

    aSense.clear()
    drawLine(aSense,-1,-1,9,9,255,0,255)
    sleep(2)

    aSense.clear()
    drawLine(aSense,0,1,7,2,255,0,255)
    sleep(2)
    
    aSense.clear()
    drawLine(aSense,1,0,3,7,255,0,255)
    sleep(2)
    
    sleep(5)
    print("End TEST_drawLine")


def drawRectangle(aSense,x1,y1,x2,y2,borderRed=255, borderGreen=255,borderBlue=255, fillRed=0, fillGreen=0, fillBlue=255, doFill=False):
    drawLine(aSense,x1,y1,x2,y1,borderRed,borderGreen,borderBlue)
    drawLine(aSense,x1,y2,x2,y2,borderRed,borderGreen,borderBlue)
    drawLine(aSense,x2,y1,x2,y2,borderRed,borderGreen,borderBlue)
    drawLine(aSense,x1,y1,x1,y2,borderRed,borderGreen,borderBlue)
    if (doFill):
        if (x1 > x2):
            xTemp = x2
            x2 = x1
            x1 = xTemp
        if (y1 > y2):
            yTemp = y2
            y2 = y1
            y1 = yTemp
        for ix in range(x1+1,x2):
            drawLine(aSense,ix,y1+1,ix,y2-1,fillRed,fillGreen,fillBlue)

def TEST_drawRectangle(aSense):
    print("Start TEST_drawRectangle")
    drawRectangle(aSense,0,0,7,7)
    sleep(1)
    aSense.clear()
    drawRectangle(aSense,5,5,4,4)
    drawRectangle(aSense,1,2,7,6,doFill=True)
    sleep(1)
    aSense.clear()
    drawRectangle(aSense,7,6,1,2,fillRed=255,doFill=True)
    sleep(5)	
    aSense.clear()
    print("End TEST_drawRectangle")

# Sense-HAT grafic functions
# ==========================
def drawCircle(aSense, xCenter, yCenter, radius, redBorder=255, greenBorder=255, blueBorder=255, redFill=0, greenFill=0, blueFill=255, doFill=False, resolution=10):
    if (doFill == True):
       for countDown in range(radius, 0, -1):
           print("countDown: ",countDown)
           for alpha in range(0,360,resolution):
               bogenmass=grad2Rad(alpha)
               # print("alpha:",alpha," Bogenmass:",bogenmass," x:",xCenter," y:",yCenter)
               xDist=countDown*math.cos(bogenmass)
               xPixel=xCenter+xDist
               yDist=countDown*math.sin(bogenmass)
               yPixel=yCenter+yDist
               aSense.set_pixel(int(xPixel), int(yPixel), redFill, greenFill, blueFill)
               sleep(0.05)

    for alpha in range(0,360,resolution):
        bogenmass=grad2Rad(alpha)
        # print("alpha:",alpha," Bogenmass:",bogenmass)
        xDist=radius*math.cos(bogenmass)
        xPixel=xCenter+xDist
        yDist=radius*math.sin(bogenmass)
        yPixel=yCenter+yDist
        aSense.set_pixel(int(xPixel), int(yPixel), redBorder, greenBorder, blueBorder)
        sleep(0.05)

def TEST_drawCircle(aSense):
    print("Start TEST_drawCircle")
    aSense.clear()
    drawCircle(aSense,4,4,3)
    sleep(1)
    aSense.clear()
    drawCircle(aSense,4,4,3,doFill=True)
    sleep(1)
    print("End TEST_drawCircle")

def TEST_drawFunction(aSense):
    TEST_drawLine(aSense)
    TEST_drawRectangle(aSense)
    TEST_drawCircle(aSense)