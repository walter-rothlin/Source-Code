# Beispiel 4.3
#
# Weitere Möglichkeiten, Funktionen aufzurufen
#
from random import randint


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


# Verrechnen zweier Werte
def werte_verrechnen():
    wert1 = zahl_abfragen(0, 100)
    wert2 = zahl_abfragen(0, 100)

    print("Das Produkt lautet:", wert1 * wert2)
    print("Die Summe lautet:", wert1 + wert2)


# Hauptprogramm
werte_verrechnen()

# Rückgabewert einer Funktion als Argument verwenden
print("In einem Rutsch:", zahl_abfragen(0, randint(1, 1000)))
