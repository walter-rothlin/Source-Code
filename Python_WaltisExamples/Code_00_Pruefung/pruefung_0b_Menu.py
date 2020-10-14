#!/usr/bin/python3

'''pruefung_0b_Menu.py'''

pi = 3.1415926


doLoop = True
while (doLoop):
    print("  Geometrische Flaechen")
    print("  =====================")
    print("  1: Rechteck")
    print("  2: Kreis")
    print()
    print("  0: Schluss")

    antwort = input("\n  Wähle:")
    if (antwort == "1"):
        laenge = float(input("Rechteck Laenge:"))
        breite = float(input("Rechteck Breite:"))
        flaeche = laenge * breite
        umfang = 2 * (laenge + breite)
        print("Umfang :{u:6.2f}".format(u=umfang))
        print("Flaeche:{f:6.2f}".format(f=flaeche))
    elif (antwort == "2"):
        radius = float(input("Kreis Radius:"))
        flaeche = radius * radius * pi
        umfang = 2 * radius * pi
        print("Umfang :{u:6.2f}".format(u=umfang))
        print("Flaeche:{f:6.2f}".format(f=flaeche))
    elif (antwort == "0"):
        doLoop = False

print("Ende....Done")