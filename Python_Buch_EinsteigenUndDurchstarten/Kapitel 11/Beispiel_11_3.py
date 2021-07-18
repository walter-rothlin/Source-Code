# Beispiel 11.3
#
# Next Step
#


# Ein paar Werte verrechnen
def werte_verrechnen(wert_1, wert_2, wert_3):
    ergebnis = wert_1 + wert_2
    ergebnis *= wert_3

    return ergebnis


# Eine Berechnungsreihe durchführen
def berechnungsreihe(durchlaeufe):
    for i in range(durchlaeufe):
        aktuelles_ergebnis = werte_verrechnen(i, i+1, i+2)
        print(aktuelles_ergebnis)

    print("Berechnungsreihe durchgeführt")


def main():
    while True:
        anzahl_durchlaeufe = int(input("Anzahl der Durchläufe: "))

        if anzahl_durchlaeufe < 5 or anzahl_durchlaeufe > 10:
            print("Anzahl der Durchläufe ungültig!")
        else:
            break

    berechnungsreihe(anzahl_durchlaeufe)


main()
