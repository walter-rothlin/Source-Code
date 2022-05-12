#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : zahlenreihenSimple.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/zahlenreihenSimple.py
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

print("Zahlenreihen")



print("+------+--------+-----------+")
print("|   i  | i*i    |      2^i  |")
print("+------+--------+-----------+")

for i in range(21):
    print("|{i:5d} | {ii:6d} | {iii:10.0f}|".format(i=i,ii=i*i,iii=math.pow(2,i)))

print("+------+--------+-----------+")
print("\n\n")
