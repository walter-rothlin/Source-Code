# ------------------------------------------------------------------
# Name: A_MyLib
#
# Description: Meine Library.
#
# Autor: Walter Rothlin
#
# History:
# 10-Dec-2020   Walter Rothlin      Initial Version
#
# -----------------------------------------------------------------

import math

pi = math.pi

# physikalische Umrechnungen
# ==========================
def celsiusToFahrenheit(aCelsiusValue):
    return (aCelsiusValue * 1.8) + 32

def fahrenheitToCelsius(aFahrenheitValue):
    return (aFahrenheitValue - 32) / 1.8

def radToGrad(radVal):
    return radVal * 180 / pi

def gardToRad(gradVal):
    return gradVal * pi / 180

def halt(prompt = "Weiter?"):
    nop = input(prompt)

print(celsiusToFahrenheit(37.8))   # --> 100
print(celsiusToFahrenheit(0))      # --> 32

print(fahrenheitToCelsius(100))    # --> 37.8
print(fahrenheitToCelsius(32))     # --> 0



