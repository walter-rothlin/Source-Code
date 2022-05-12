#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: zahlenreihen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/zahlenreihen.py
#
#
# Description: Generiert Zahlenreihen
#
# Autor: Walter Rothlin
#
# History:
# 12-Dec-2019   Walter Rothlin      Initial Version

# ------------------------------------------------------------------
import math
from waltisLibrary import *

def createLine(laenge, ch="-"):
   aLine = ""
   for i in range(laenge):
      aLine = aLine + ch
   return aLine


title = "Zahlenreihen"
spBreite_1 = 20;
spBreite_2 = 12;
spBreite_3 = 15;
print(title)
print(createLine(len(title),"="))


tabellenRand = "+" + createLine(spBreite_1 + 1) + "+" + createLine(spBreite_2 + 2) + "+" + createLine(spBreite_3 + 2) + "+"

print(tabellenRand)
print(("|  {t1:" + str(spBreite_1 - 2) + "s} | {t2:" + str(spBreite_2) + "s} | {t3:" + str(spBreite_3) + "s} |").format(t1="i",t2="i*i",t3="2^i"))
print(tabellenRand)

formatStr = "|{i:" + str(spBreite_1) + "d} | {ii:" + str(spBreite_2) + "d} | {iii:" + str(spBreite_3 + 1) + "d}|"
for i in range(21):
    print(formatStr.format(i=i,ii=i*i,iii=2**i))

print(tabellenRand)


