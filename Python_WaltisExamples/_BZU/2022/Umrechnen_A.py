#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_05b_Menu_Umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 26-Sep-2017   Walter Rothlin      Initial Version
# 24-Oct-2017	Walter Rothlin		Eigene Functions mit Parametern
#
# ------------------------------------------------------------------
import math

# Konstanten
# ==========
halbBogen = 180



# Bildschirmsteuerung
# ===================
def halt(prompt="Weiter?"):
    ants= input(prompt)


def isFloat(inputStirng):
    return inputStirng.replace('.','',1).replace('-','',1).isdigit()


# Umrechnungs-Funktionen
# ======================
def grad2Rad(grad):
    return math.pi * grad / halbBogen


def rad2Grad(rad):
    return halbBogen * rad / math.pi


def fahrenheit2Celsius(fahrenheit):
    return (fahrenheit - 32) / 1.8


def celsius2Fahrenheit(celsius):
    return (celsius * 1.8) + 32

def sin(x,einheit="rad"): #'deg'
    if einheit == "rad":
        return math.sin(x)
    else:
        return math.sin(grad2Rad(x))

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
    print("  5: Sin(x)",mode)  # 32F -> 0°C    100F -> 38.8°C     °F = (°C * 1.8) - 32
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
