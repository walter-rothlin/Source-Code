#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 28-Nov-2017   Walter Rothlin      Initial Version (Menu-Text)
# 29-Nov-2017   Walter Rothlin      Loop, input and case
# 30-Nov-2017   Walter Rothlin      Alle Umrechnungen implementiert
#
# ------------------------------------------------------------------
doLoop = True
while doLoop:
    print("  Umrechnungen")
    print("  ============")
    print("  1: Grad in Bogenmass")  # rad  = grad*pi/180
    print("  2: Bogenmass in Grad")  # grad = rad*180/pi
    print()
    print("  3: Fahrenheit in Celsius")  #32F -> 0°C    100F -> 38.8°C     °C = (°F - 32) / 1.8
    print("  4: Celsius in Fahrenheit")  #32F -> 0°C    100F -> 38.8°C     °F = (°C * 1.8) + 32
    print()
    print("  0: Schluss")


    antwort = input("\n  Wähle:")
    if (antwort == "1"):
        print("Grad --> Bogenmass")
        gradValue = float(input("Grad: "))
        radValue  = (gradValue * 3.1415926 / 180)
        print("Grad={grad:1.2f}  ==> Rad={rad:1.2f}".format(grad=gradValue,rad=radValue))

    if (antwort == "2"):
        print("Bogenmass --> Grad")
        radValue = float(input("Rad: "))
        gradValue  = (radValue * 180 / 3.1415926)
        print("Rad={rad:1.2f}  ==> Grad={grad:1.2f}".format(grad=gradValue,rad=radValue))

    if (antwort == "3"):
        print("Fahrenheit --> Celsius")
        fahrValue = float(input("Fahrenheit: "))
        gradValue  = (fahrValue-32)/1.8
        print("Fahrenheit={fahr:1.2f}  ==> Celsius={cel:1.2f}".format(cel=gradValue,fahr=fahrValue))

    if (antwort == "4"):
        print("Celsius --> Fahrenheit")
        gradValue = float(input("Celsius: "))
        fahrValue  = (gradValue * 1.8) + 32
        print("Celsius={cel:1.2f}  ==> Fahrenheit={fahr:1.2f}".format(cel=gradValue,fahr=fahrValue))
			
    if (antwort == "0"):
        doLoop = False

print("Ende....Done")