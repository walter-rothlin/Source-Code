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

from B_MyLib import *

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

    choice = input("\n   Wähle:")

    if choice == "1":
        inVal = float(input("Grad:"))
        print("{g:3.2f}Grad --> {r:3.2f}Radianten".format(g=inVal, r=gardToRad(inVal)))

    if choice == "2":
        inVal = float(input("Rad:"))
        print("{r:3.2f}Radianten --> {g:3.2f}Grad".format(r=inVal, g=radToGrad(inVal)))

    if choice == "3":
        inVal = float(input("Fahrenheit:"))
        print("{f:3.2f}Fahrenheit --> {g:3.2f}Celsius".format(f=inVal, g=fahrenheitToCelsius(inVal)))

    if choice == "4":
        inVal = float(input("Celsius:"))
        print("{g:3.2f}Celsius --> {f:3.2f}Fahrenheit".format(g=inVal, f=celsiusToFahrenheit(inVal)))

    if choice == "5":
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
        print("r={r:3.2f} d={d:3.2f}  Kreisfläche A={A:3.2f}   Umfang U={U:3.2f}".format(r=radius, A=A, U=U, d=2*radius))

    if choice == "0":
        doLoop = False
        print("Schade, dass du aufhörst!!!!!")
    else:
        print()
        halt()
print("Danke für deinen Besuch")