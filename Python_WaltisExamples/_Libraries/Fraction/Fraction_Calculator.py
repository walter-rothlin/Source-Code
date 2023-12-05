#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Bruch_Rechner.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Fraction/Fraction_Calulator.py
#
# Description: Reference application for Class_Bruch
#
#
# Autor: Walter Rothlin
#
# History:
# 25-Jan-2021	Walter Rothlin  Initial Version
# 22-Nov-2023   Walter Rothlin  Implemented TBI 21.11.23
#
# ------------------------------------------------------------------
from waltisLibrary import *
from Class_Fraction import *

help(Fraction)

print(unterstreichen("Test-Cases from Bruch_Rechner"))
bruch1 = Fraction()
print(bruch1)
print(bruch1.to_decimal().__doc__)
print(bruch1)

bruch_1 = Fraction(2, 3)
bruch_1.reciprocal()
print(bruch_1)


