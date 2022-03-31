#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: umrechnungen.py
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
    print("  3: Fahrenheit in Celsius")  #32F -> 0°C    100F -> 38.8°C     °C = (°F - 32) / 1.8
    print("  4: Celsius in Fahrenheit")  #32F -> 0°C    100F -> 38.8°C     °F = (°C * 1.8) - 32
    print()
    print("  0: Schluss")
    user_input = input("Waehle:")
    if user_input == "1":
        print("Grad --> Bogenmass")
        gradValue = int(input("Grad:"))
        radValue = gradValue * 3.1415926 / 180
        print(radValue)
    elif user_input == "2":
            print("Bogenmass --> Grad")
    elif user_input == "0":
            print("Programm wird beendet")
            doLoop = False
    else:
        print("Ungültige Auswahl")
print("Tschüssss!")


