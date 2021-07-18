# Beispiel 5.16
#
# Mehrdeutigkeiten bei der Mehrfachvererbung
#


# Klassendefinition (Tastatur)
class Tastatur:
    def taste_druecken(self, taste):
        print("Taste {0} wurde gedrückt. *Piepton*".format(taste))


# Klassendefinition (Telefon)
class Telefon(Tastatur):
    def taste_druecken(self, taste):
        print("Gewählte Taste wird zur Telefonnummer hinzugefügt")


# Klassendefinition (Taschenrechner)
class Taschenrechner(Tastatur):
    def taste_druecken(self, taste):
        print("Gewählte Taste wird zur aktuellen Berechnung hinzugefügt")


# Klassendefinition (Smartphone)
class Smartphone(Telefon, Taschenrechner):
    def __init__(self):
        print("Smartphone erstellt")


def main():
    # Hauptprogramm
    idroid = Smartphone()

    idroid.taste_druecken("9")


main()
