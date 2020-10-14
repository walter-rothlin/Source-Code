#!/usr/bin/python3

'''pruefung_0c_Menu.py'''

doLoop = True
while doLoop:
    print("Geometrische Flaechen")
    print("====================")
    print("1: Rechteck")
    print("2: Kreis")
    print("")
    print("0: Schluss")

    antwort = input("\n Wähle:")
    if (antwort == "1"):
        gradValue = float(input("Rechteck Laenge:"))
        radValue = float(input("Rechteck Breite:"))
        print("Rechteck Umfang:", gradValue + gradValue + radValue + gradValue)
        print("Rechteck Flaeche:", radValue * gradValue)

    if (antwort == "2"):
        gradValue = float(input("Rechteck Laenge:"))
        radValue = float(input("Rechteck Breite:"))
        print("Rechteck Umfang:", gradValue + gradValue + radValue + gradValue)
        print("Rechteck Flaeche:", radValue * gradValue)

    if antwort == "0":
        print("Schluss")
        doloop = False

print("Ende.....Done")