# Beispiel 4.5
#
# Lesender Zugriff auf globale Variablen
#


# Zugriff auf die globale Variable "zahl"
def zahl_ausgeben():
    print("Funktion: Inhalt der Variablen", zahl)

    # Das wäre ein Fehler
    #print("Funktion: Inhalt der Variablen", zhal)

    # Das ebenfalls
    #zahl = 19


# Hauptprogramm
zahl = 17
zahl_ausgeben()
