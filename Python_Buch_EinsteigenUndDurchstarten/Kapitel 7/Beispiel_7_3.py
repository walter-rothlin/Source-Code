# Beispiel 7.3
#
# Exceptions werfen und abfangen
#


# Eine einfache Funktion als Beispiel
def koordinaten_setzen(x, y):
    if x < 0 or y < 0:
        raise(ValueError("Ungültige Koordinaten:", x, y))

    print("Koordinaten gesetzt")


def main():
    # Hauptprogramm
    try:
        koordinaten_setzen(10, -5)
        print("Scheint geklappt zu haben!")
    except ValueError:
        print("Fehler abgefangen")


main()
