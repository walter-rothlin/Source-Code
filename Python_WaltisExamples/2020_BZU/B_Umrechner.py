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

    choice = input("\n   Wähle:")

    if choice == "1":
        print("Grad --> Radianten")
        gradValue = float(input("Grad:"))
        radValue = gradValue * 3.1415926 / 180.0
        print(gradValue, "° --> ", radValue, "rad\n", sep="")

    if choice == "0":
        doLoop = False
        print("Schade, dass du aufhörst!!!!!")
print("Danke für deinen Besuch")