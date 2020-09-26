#!/usr/bin/python3

# ----------------------------------------
#
# Name:        BZU.py
# Description: Testet den print Befehl
# Author:      Walter Rothlin
#
# History:
# 28-Nov-2017	Walter Rothlin	Initial Version
# 
# ----------------------------------------

print("Hello","BZU",sep="")  # Das ist der erste Befehl
print("===========")
print("\n")
print("1:Kreisflaeche berechnen")


laenge=5.4
breite=2.5
print(laenge,"*",breite,"=",laenge*breite,sep="")
print("Laenge:",laenge,sep="",end=" ",flush=True)
print("Breite:",breite,sep="",end=" ",flush=True)
print("Fläche:",laenge*breite,sep="",end=" ",flush=True)

laenge_1=5.68
laenge_2="5.68"
laenge_3=3
laenge_4=3.0
text_1="Laenge"

print("\n",laenge_1 * laenge_3)
print(laenge_2 + "    " + text_1 + "  kkk " + text_1)

print(text_1 + ":" + str(laenge_1))

radius_1=453.53
radius_2=23.6
radius_3=1.567892
print("        :12345678901234567890")
print("Radius_1:{r1:15.2f}".format(r1=radius_1))
print("Radius_2:{r1:15.2f}".format(r1=radius_2))
print("Radius_3:{r1:15.2f}".format(r1=radius_3))

vorname=input("wie ist dein Name?")
print("Vorname:" + vorname)

radiusX=float(input("Radius:"))
print("Flaeche:",radiusX*radiusX*3.1415)


