#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: bzu_scratch_1.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/bzu_scratch_1.py

#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 01-Apr-2022	Walter Rothlin		Initial Version mit Header
#
# ------------------------------------------------------------------

betrag = 12.5635
vorname = "Otto"

print("Oh {v1:s}{v2:s}! Du schuldest mir {betrag:1.2f} CHF!".format(v1=vorname, v2=vorname, betrag=betrag))
