#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_10_exceptionHandling.py
#
# Description: Berechnet die Nullstellen einer quadratischen Funktion
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2021   Walter Rothlin      Initial Version
# 10-Jun-2021   Walter Rothlin      Created fct readFloat()
#
# ------------------------------------------------------------------

import math


def readFloat(prompt="Input [Float]:", preError="Wrong Format:", postError="   Must be a FLOAT!!!!"):
    error = True
    userInputStr = ""
    while error:
        try:
            userInputStr   = input(prompt)
            userInputFloat = float(userInputStr)
            error = False
        except ValueError:
            print(preError + userInputStr + postError)
            error = True
    return userInputFloat

help = '''
Berechnung der Nullstellen einer quadratischen Funktion der Form:
   y = ax^2 + bx + c

   Mitternachtsformel: https://www.mathebibel.de/mitternachtsformel

   Positive Testfälle: a=2    b=1    c=-4      Diskriminante: 33    x1=-1.69  x2=1.19
   Positive Testfälle: a=1    b=0    c=0       Diskriminante:  0    x1,2=0 
   Negative Testfälle: a=1    b=2    c=3       Diskriminante: -8    x1=----   x2=-----
'''

print(help)

a = readFloat("a=")
b = readFloat("b=")
c = readFloat("c=")

diskriminante = b**2 - 4*a*c
print("Diskriminante:", diskriminante)
if diskriminante < 0:
    print("Keine Lösung")
else:
    x1 = (-b + math.sqrt(diskriminante))/(2 * a)
    x2 = (-b - math.sqrt(diskriminante))/(2 * a)
    print("x1 =", x1, "    x1 =", x2)


