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

print(unterstreichen("Quadratische Gleichung"))
# help("waltisLibrary")
# help("waltisLibrary.calcNullstellen")
# help(get_sub)
help(getTimestamp)
help(calcNullstellen)

a = readFloat("a=")
b = readFloat("b=")
c = readFloat("c=")
print("0 = ax² + bx + c  ==> 0 = {a:1.2f}x\u00B2 + ({b:1.2f})x + ({c:1.2f})   x₁,₂=?".format(a=a, b=b, c=c))
loesungen = calcNullstellen(a, b, c)
print(loesungen)





