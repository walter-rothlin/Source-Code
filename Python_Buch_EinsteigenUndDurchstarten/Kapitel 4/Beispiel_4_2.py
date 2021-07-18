# Beispiel 4.2
#
# Parameterübergabe und Rückgabewert bei Funktionen
#


# Abfragen einer Zahl innerhalb eines Wertebereichs
def zahl_abfragen(von, bis):
    text = "Bitte eine Zahl von {0} bis {1} eingeben: ".format(von, bis)

    # So lange Abfragen, bis eine gültige Zahl eingegeben wurde
    while True:
        try:
            zahl = int(input(text))

            # Wertebereich überprüfen
            if zahl >= von and zahl <= bis:
                return zahl
            else:
                print("Eingabe ist außerhalb des Wertebereichs")
        except ValueError:
            print("Falsche Eingabe!")


# Hauptprogramm
ergebnis = zahl_abfragen(10, 100)
print("Die Zahl lautet:", ergebnis)
