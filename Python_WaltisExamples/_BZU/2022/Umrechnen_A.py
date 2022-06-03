#!/usr/bin/python3

# ------------------------------------------------------------------
# Name:  Umrechnungen_A.py
# https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2022/Umrechnen_A.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 31-Mar-2022   Walter Rothlin      Initial Version
# 07-Apr-2022	Tobias Rothlin		Menu-Struktur, Loop, case
# 14-Apr-2022	Tobias Rothlin		Formeln implementiert, Eigene Funktionen
# 02-Jun-2022   Walter Rothlin      Eigenes Module
# 03-Jun-2022   Walter Rothlin      Kleine Aenderungen
# ------------------------------------------------------------------
from Library_A import *

# =============
# Hauptprogramm
# =============
doLoop = True
mode = "rad"
while doLoop:
    print("  Umrechnungen (V5b.0)")
    print("  ====================")
    print("  1: Grad in Bogenmass")  # rad  = grad*pi/180
    print("  2: Bogenmass in Grad")  # grad = rad*180/pi
    print()
    print("  3: Fahrenheit in Celsius")  # 32F -> 0°C    100F -> 38.8°C     °C = (°F - 32) / 1.8
    print("  4: Celsius in Fahrenheit")  # 32F -> 0°C    100F -> 38.8°C     °F = (°C * 1.8) - 32
    print()
    print("  5: Sin(x)", mode)  # 32F -> 0°C    100F -> 38.8°C     °F = (°C * 1.8) - 32
    print()
    print("  9: Format_String Test")
    print()
    print("  0: Schluss")

    antwort = input("\n  Wähle:")
    if antwort == "1":
        print("Grad --> Bogenmass")
        gradValue = float(input("Grad:"))
        print(f"Grad={gradValue:1.2f}  ==> Rad={grad2Rad(gradValue):1.2f}")
        halt()
    if antwort == "2":
        print("Bogenmass --> Grad")
        radValue = float(input("Rad:"))
        print(f"Rad={radValue:1.2f}  ==> Grad={rad2Grad(radValue):1.2f}")
        halt()
    if antwort == "3":
        print("Fahrenheit in Celsius")
        fahrenheitValue = float(input("Fahrenheit:"))
        print(f"Fahrenheit={fahrenheitValue:1.2f}  ==> Celsius={fahrenheit2Celsius(fahrenheitValue):1.2f}")
        halt()
    if antwort == "4":
        print("Celsius in Fahrenheit")
        inputValue = input("Celsius:")
        if isFloat(inputValue):
            celsiusValue = float(inputValue)
            print(f"Celsius={celsiusValue:1.2f}  ==> Fahrenheit={celsius2Fahrenheit(celsiusValue):1.2f}")
            halt()
        else:
            print("Input value not Float!")

    if antwort == "5":
        print("Sin(x)")
        inputStr = input("sin: ")
        if isFloat(inputStr):
            print(f"sin({float(inputStr):1.2f}) = {sin(float(inputStr), mode):1.2f}")
        else:
            if inputStr == "r":
                mode = "rad"
                print(f"Mode:{mode}")
            elif inputStr == "d":
                mode = "deg"
                print(f"Mode:{mode}")
            else:
                print("Error not valid code")
            inputStr = input("sin: ")
            if isFloat(inputStr):
                print(
                    f"sin({float(inputStr):1.2f}) = {sin(float(inputStr), mode):1.2f}")

        halt()
    if antwort == "0":
        doLoop = False

print("Ende....Done")
