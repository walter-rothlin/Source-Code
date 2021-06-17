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
# 24-Jun_2021   Walter Rothlin      Use of own library
# ------------------------------------------------------------------
from waltisLibrary import *


# ====
# Main
# ====

# tba:
#   help text ausgeben
#   0 = ax^2 + ... ersetzen

print(unterstreichen("Quadratische Gleichung"))

a = readFloat("a=")
b = readFloat("b=")
c = readFloat("c=")
print("0 = ax^2 + bx + c  x12")
loesungen = calcNullstellen(a, b, c)
print(loesungen)




