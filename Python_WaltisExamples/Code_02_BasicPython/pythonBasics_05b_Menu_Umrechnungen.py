#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_05b_Menu_Umrechnungen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_05b_Menu_Umrechnungen.py
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
def VT52_cls():
    print("\033[2J", end="", flush=True)


def VT52_home():
    print("\033[H", end="", flush=True)


def VT52_cls_home():
    VT52_cls()
    VT52_home()


def halt(prompt="Weiter?"):
    ant = input(prompt)


# Test-Funktionen
# ===============
def testFormatString():
    feldLength = int(input("Feld 1 Length:"))
    formatStr = "Art: {0:" + str(feldLength) + "d}, Price: {1:8.2f}"

    strOut_0 = formatStr.format(4523, 59.058)
    strOut_1 = formatStr.format(45, 1259.058)
    strOut_2 = formatStr.format(1241523, 12345679.0)

    print("12345678901234567890123456789012345678901234567890")
    print(strOut_0)
    print(strOut_1)
    print(strOut_2)


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


# =============
# Hauptprogramm
# =============
doLoop = True
while doLoop:
    VT52_cls_home()
    print("  Umrechnungen (V5b.0)")
    print("  ====================")
    print("  1: Grad in Bogenmass")  # rad  = grad*pi/180
    print("  2: Bogenmass in Grad")  # grad = rad*180/pi
    print()
    print("  3: Fahrenheit in Celsius")  # 32F -> 0°C    100F -> 37.78°C     °C = (°F - 32) / 1.8
    print("  4: Celsius in Fahrenheit")  # 32F -> 0°C    100F -> 37.78°C     °F = (°C * 1.8) + 32
    print()
    print("  9: Format_String Test")
    print()
    print("  0: Schluss")

    antwort = input("\n  Wähle:")
    if antwort == "1":
        VT52_cls_home()
        print("Grad --> Bogenmass")
        gradValue = float(input("Grad:"))
        print("Grad={grad:1.2f}  ==> Rad={rad:1.2f}".format(grad=gradValue, rad=grad2Rad(gradValue)))
        halt("Cont.?")

    if antwort == "2":
        VT52_cls_home()
        print("Bogenmass --> Grad")
        radValue = float(input("Rad:"))
        print("Rad={rad:1.2f}  ==> Grad={grad:1.2f}".format(rad=radValue, grad=rad2Grad(radValue)))
        halt()

    if antwort == "3":
        VT52_cls_home()  # http://www.metric-conversions.org/de/temperatur/fahrenheit-in-celsius.htm
        print("Fahrenheit in Celsius")
        fahrenheitValue = float(input("Fahrenheit:"))
        print("Fahrenheit={fahrenheit:1.2f}  ==> Celsius={celsius:1.2f}".format(fahrenheit=fahrenheitValue,
                                                                                celsius=fahrenheit2Celsius(
                                                                                    fahrenheitValue)))
        halt()

    if antwort == "4":
        VT52_cls_home()  # http://www.metric-conversions.org/de/temperatur/celsius-in-fahrenheit.htm
        print("Celsius in Fahrenheit")
        celsiusValue = float(input("Celsius:"))
        print("Celsius={celsius:1.2f}  ==> Fahrenheit={fahrenheit:1.2f}".format(celsius=celsiusValue,
                                                                                fahrenheit=celsius2Fahrenheit(
                                                                                    celsiusValue)))
        halt()

    if antwort == "9":
        testFormatString()

    if antwort == "0":
        doLoop = False

print("Ende....Done")
