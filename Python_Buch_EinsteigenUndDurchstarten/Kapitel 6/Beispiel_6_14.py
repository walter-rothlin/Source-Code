# Beispiel 6.14
#
# Mehrere Rückgabewerte
#


# Funktion, die mehrere Berechnungen durchführt
def mehrfachberechnung(x, y):
    summe = x + y
    produkt = x * y
    return summe, produkt


# Hauptprogramm
def main():
    print("Bilde Summe und Produkt von 15 und 10")
    ergebnisse = mehrfachberechnung(15, 10)
    print("Das zurückgelieferte Objekt ist vom Typ:", type(ergebnisse))
    print(ergebnisse)

    # Zugriff per Index
    print("Die Summe lautet:", ergebnisse[0])
    print("Das Produkt lautet:", ergebnisse[1])

    # Unpacking
    print("\nBilde Summe und Produkt von 21 und 12")
    summe, produkt = mehrfachberechnung(21, 12)

    print("Die Summe lautet:", summe)
    print("Das Produkt lautet:", produkt)


main()
