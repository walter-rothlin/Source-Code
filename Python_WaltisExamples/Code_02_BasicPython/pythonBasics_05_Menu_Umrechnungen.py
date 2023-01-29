#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_05_Menu_Umrechnungen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_05_Menu_Umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 26-Sep-2017   Walter Rothlin      Initial Version
# 05-Mar-2020   Walter Rothlin      Added Format-String Menu-Point
# ------------------------------------------------------------------

# Konstanten
# ==========
pi = 3.1415926
halbBogen = 180

# =============
# Hauptprogramm
# =============
doLoop = True
while doLoop:
    print()
    print()
    print()
    print("  Umrechnungen (V5.0)")
    print("  ===================")
    print("  1: Grad in Bogenmass")  # rad  = grad*pi/180
    print("  2: Bogenmass in Grad")  # grad = rad*180/pi
    print()
    print("  3: Fahrenheit in Celsius")  #32F -> 0°C    100F -> 38.8°C     °C = (°F - 32) / 1.8
    print("  4: Celsius in Fahrenheit")  #32F -> 0°C    100F -> 38.8°C     °F = (°C * 1.8) - 32
    print()
    print("  9: Format_String Test")
    print()
    print("  0: Schluss")

    antwort = input("\n  Wähle:")
    if antwort == "1":
        gradValue = float(input("Grad:"))
        print(gradValue, "Grad ==> ", gradValue*pi/halbBogen, "Rad")

    if antwort == "2":
        radValue = float(input("Rad:"))
        print(gradValue, "Rad ==> ", radValue*halbBogen/pi, "Grad")

    if antwort == "3":
        fahrenheitValue = float(input("Fahrenheit:"))
        print(fahrenheitValue, "Fahrenheit ==> ", (fahrenheitValue - 32) / 1.8, "Celsius")

    if antwort == "4":
        celsiusValue = float(input("Celsius:"))
        print(celsiusValue, "Celsius ==> ", (celsiusValue*1.8) - 32, "Fahrenheit")

    if antwort == "9":
        feldLength = int(input("Feld 1 Length:"))
        formatStr = "Art: {0:" + str(feldLength) + "d}, Price: {1:8.2f}"

        strOut_0 = formatStr.format(4523, 59.058)
        strOut_1 = formatStr.format(45, 1259.058)
        strOut_2 = formatStr.format(1241523, 12345679.0)

        print("12345678901234567890123456789012345678901234567890")
        print(strOut_0)
        print(strOut_1)
        print(strOut_2)

    if antwort == "0":
        doLoop = False

print("Ende....Done")
