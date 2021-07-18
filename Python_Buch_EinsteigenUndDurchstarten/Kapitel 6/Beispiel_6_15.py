# Beispiel 6.15
#
# namedtuple
#
from collections import namedtuple

Ergebnis = namedtuple("Ergebnis", ["summe", "differenz", "produkt", "quotient"])


# Funktion, die mehrere Berechnungen durchführt
def mehrfachberechnung(x, y):
    return Ergebnis(x+y, x-y, x*y, x/y)


def main():
    neue_berechnung = mehrfachberechnung(15, 19)

    print("Ergebnis der Berechnung:")
    print("Summe:", neue_berechnung.summe)
    print("Differenz:", neue_berechnung.differenz)
    print("Produkt:", neue_berechnung.produkt)
    print("Quotient:", neue_berechnung.quotient)

    # Zugriff über Index funktioniert ebenfalls
    print("\nProdukt (Zugriff über Index):", neue_berechnung[2])

    # Ebenso wie Unpacking
    s, d, p, q = mehrfachberechnung(24, 18)
    print("\nAuch Unpacking funktioniert:")
    print("Summe: {0}, Diff.: {1}, Produkt: {2}, Quot.: {3}".format(s, d, p, q))

    print("\nTyp:", type(neue_berechnung))


main()
