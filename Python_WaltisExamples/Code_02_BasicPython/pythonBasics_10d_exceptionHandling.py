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
# 10-Jun-2021   Walter Rothlin      Created readFloat()
# 17-Jun-2021   Walter Rothlin      Extended readFloat()
# ------------------------------------------------------------------

import math

# =========
# Functions
# =========
def readFloat(prompt="Input [Float]:",
              preErrorStr="Wrong Format:",
              postErrorStr="   Must be an FLOAT!!!!",
              min=None, minErrorStr="Value must be greater or equal than {mi:1d}",
              max=None, maxErrorStr="Value must less or equal than {ma:1d}"):

    error = True
    userInputStr = ""
    while error:
        try:
            userInputStr = input(prompt)
            userInputZahl = float(userInputStr)
            error = False
            if (min is None) and (max is None):
                error = False
            else:
                if min is not None:
                    if userInputZahl < min:
                        print(minErrorStr.format(mi=min))
                        error = True
                if max is not None:
                    if userInputZahl > max:
                        print(maxErrorStr.format(ma=max))
                        error = True
        except ValueError:
            print(preErrorStr + userInputStr + postErrorStr)
            error = True
    return userInputZahl

def calcNullstellen(a, b, c):
    """
    Berechnung der Nullstellen einer quadratischen Funktion der Form:
       y = ax\u00B2 + bx + c

       Mitternachtsformel: https://www.mathebibel.de/mitternachtsformel

       Positive Testfälle: a=2    b=1    c=-4      Diskriminante: 33    x1=-1.69  x2=1.19
       Positive Testfälle: a=1    b=0    c=0       Diskriminante:  0    x1,2=0
       Negative Testfälle: a=1    b=2    c=3       Diskriminante: -8    x1=----   x2=-----
    """
    diskriminante = b ** 2 - 4 * a * c
    if diskriminante < 0:
        return {"Diskriminante": diskriminante, "Solutions": 0, "Solution Text": "Keine Lösung"}
    elif diskriminante == 0:
        x1 = (-b) / (2 * a)
        return {"Diskriminante": diskriminante, "Solutions": 1, "Solution Text": "Eine Lösung", "x1": x1, "x2": x1}
    else:
        x1 = (-b + math.sqrt(diskriminante)) / (2 * a)
        x2 = (-b - math.sqrt(diskriminante)) / (2 * a)
        return {"Diskriminante": diskriminante, "Solutions": 2, "Solution Text": "Zwei Lösungen", "x1": x1, "x2": x2}


# ====
# Main
# ====

help(calcNullstellen)
a = readFloat("a=")
b = readFloat("b=")
c = readFloat("c=")

print("0 = ax^2 + bx + c  x12")
loesungen = calcNullstellen(a, b, c)
print(loesungen)




