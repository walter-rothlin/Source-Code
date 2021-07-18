# Beispiel 4.9
#
# Shadowing aufgeräumt – oder?
#


# Eine Zahl ausgeben
def zahl_ausgeben(zahl):
    print("Die Zahl lautet:", zahl)
    doppelte_zahl = wert * 2
    print("Doppelt:", doppelte_zahl)


# Hauptprogramm
wert = 63

zahl_ausgeben(wert)
print("----------")
zahl_ausgeben(24)
