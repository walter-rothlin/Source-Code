#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: bzu_scratch.py
#
# Description: Demo
#
# Autor: Walter Rothlin
#
# History:
# ------------------------------------------------------------------

betrag = 12.5635
vorname = "Otto"

print("Oh {v1:s}{v2:s}! Du schuldest mir {betrag:1.2f} CHF!".format(v1=vorname, v2=vorname, betrag=betrag))
