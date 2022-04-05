#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: umrechnungen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2022/Umrechnen_B.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 31-Mar-2022   Walter Rothlin      Initial Version (Menu-Text)
#
# ------------------------------------------------------------------

doLoop = True
while doLoop:
    print("  Umrechnungen")
    print("  ============")
    print("  1: Grad in Bogenmass")  # rad  = grad*pi/180
    print("  2: Bogenmass in Grad")  # grad = rad*180/pi
    print()
    print("  3: Fahrenheit in Celsius")  # 32F -> 0°C    100F -> 38.8°C     °C = (°F - 32) / 1.8
    print("  4: Celsius in Fahrenheit")  # 32F -> 0°C    100F -> 38.8°C     °F = (°C * 1.8) - 32
    print()
    print("  0: Schluss")

    antwort = input("  Wähle:")
    if antwort == "1":
        print("Grad --> Bogenmass")
        gradValue = float(input("Grad:"))
        radValue = gradValue * 3.1415 / 180 # rad = grad * pi / 180
        print(radValue)
    elif antwort == "2":
        print("Bogenmass --> Grad")
    elif antwort == "3":
        print("Fahrenheit --> Celsius")
    elif antwort == "4":
        print("Celsius --> Fahrenheit")
    elif antwort == "0":
        print("Programm wird beendet!!")
        doLoop = False
    else:
        print("ungültige Eingabe")

print("Tschüss!!!!!")


