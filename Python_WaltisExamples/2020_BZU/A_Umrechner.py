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
# 05-Nov-2020   Walter Rothlin      Added Kreisberechnungen
# ------------------------------------------------------------------

import math

pi = math.pi

def celsiusToFahrenheit(celsiusValueParam):
    return (celsiusValueParam * 1.8) + 32


doLoop = True
while doLoop:
    print('  Umrechnungen')
    print("  ============")
    print("  1: Grad in Bogenmass")  # rad  = grad*pi/180
    print("  2: Bogenmass in Grad")  # grad = rad*180/pi
    print()
    print("  3: Fahrenheit in Celsius")  # 32F -> 0°C    100F -> 37.8°C     °C = (°F - 32) / 1.8
    print("  4: Celsius in Fahrenheit")  # 32F -> 0°C    100F -> 37.8°C     °F = (°C * 1.8) + 32
    print()
    print("  5: Kreis Berechnungen")  # A = r^2 * pi   A = d^2 * pi / 4     U = d * pi   U = 2 * r * pi
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
        print("Lösung: ", celsiusToFahrenheit(float(input("Celsius:"))))

    if antwort == "5":
        print("Berechnungen am Kreis")
        radius = float(input("Radius:"))
        if radius == 0:
            durchmesser = float(input("Durchmesser:"))
            radius = durchmesser / 2
        if radius == 0:
            A = float(input("Fläche:"))
            radius = math.sqrt(A/pi)
        if radius == 0:
            U = float(input("Umfang:"))
            radius = (U/pi)/2

        A = (radius**2) * pi
        U = 2 * radius * pi
        print("r=", radius, "d=", 2*radius)
        print("r={r:3.2f} d={d:3.2f}  Kreisfläche A={A:3.2f}   Umfang U={U:3.2f}".format(r=radius, A=A, U=U, d=2*radius))

    if antwort == "0":
        doLoop = False

print("Vielen Dank für deinen Besuch")
