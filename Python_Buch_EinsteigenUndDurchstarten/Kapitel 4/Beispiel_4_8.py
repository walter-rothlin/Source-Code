# Beispiel 4.8
#
# Shadowing
#


# Einen Wert ausgeben
def wert_ausgeben(wert):
    print("Der Wert lautet:", wert)
    doppelter_wert = wert * 2
    print("Doppelt:", doppelter_wert)


# Hauptprogramm
wert = 63

wert_ausgeben(wert)
print("----------")
wert_ausgeben(24)
