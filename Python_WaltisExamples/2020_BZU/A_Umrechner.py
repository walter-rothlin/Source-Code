#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Umrechner
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 29-Oct-2020   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------

pi = 3.1415926

doLoop = True
while doLoop:
    print('  Umrechnungen')
    print("  ============")
    print("  1: Grad in Bogenmass")  # rad  = grad*pi/180
    print("  2: Bogenmass in Grad")  # grad = rad*180/pi
    print()
    print("  3: Fahrenheit in Celsius")  # 32F -> 0°C    100F -> 38.8°C     °C = (°F - 32) / 1.8
    print("  4: Celsius in Fahrenheit")  # 32F -> 0°C    100F -> 38.8°C     °F = (°C * 1.8) - 32
    print()
    print("  0: Schluss")

    antwort = input("\n  Wähle:")
    if antwort == "1":
        print("Grad --> Radianten")
        gradValue = float(input("Grad:"))
        radValue = gradValue * pi / 180
        print("Lösung: ", radValue)

    if antwort == "2":
        print("Bogenmass --> Grad")
        radValue = float(input("Rad:"))
        gradValue = radValue * 180 / pi
        print("Lösung: ", gradValue)

    if antwort == "3":
        print("Fahrenheit in Celsius")
        fahrenheitValue = float(input("Fahrenheit:"))
        celsiusValue = (fahrenheitValue - 32) / 1.8
        print("Lösung: ", celsiusValue)

    if antwort == "4":
        print("Celsius in Fahrenheit")
        celsiusValue = float(input("Celsius:"))
        fahrenheitValue = (celsiusValue * 1.8) + 32
        print("Lösung: ", fahrenheitValue)

    if antwort == "0":
        doLoop = False

print("Vielen Dank für deinen Besuch")
