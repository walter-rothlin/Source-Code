# Beispiel 5.12
#
# Vererbung - ein einfaches Beispiel
#


# Klassendefinition (Basisklasse "Fahrzeug")
class Fahrzeug:
    def __init__(self):
        print("Neues Fahrzeug erstellt")
        self.baujahr = 2010

    def fahren(self):
        print("Fahrzeug bewegt sich fort")


# Klassendefinition (Auto, erbt von "Fahrzeug")
class Auto(Fahrzeug):
    def schiebedach_oeffnen(self):
        print("Schiebedach des Autos öffnet sich")


# Klassendefinition (Motorrad, erbt von "Fahrzeug")
class Motorrad(Fahrzeug):
    def rasten_einklappen(self):
        print("Fußrasten werden eingeklappt")


def main():
    # Hauptprogramm

    # Ein Auto erzeugen
    auto = Auto()
    auto.schiebedach_oeffnen()
    auto.fahren()
    print("Baujahr des Autos:", auto.baujahr)

    print("")

    # Ein Motorrad erzeugen
    motorrad = Motorrad()
    motorrad.rasten_einklappen()
    motorrad.fahren()
    print("Baujahr des Motorrads:", motorrad.baujahr)


main()
