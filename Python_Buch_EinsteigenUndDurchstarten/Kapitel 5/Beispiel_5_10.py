# Beispiel 5.10
#
# Parameterübergabe im Detail
#


# Klassendefinition (Hund)
class Hund:
    def __init__(self, name):
        self.name = name

    def belle_namen(self):
        print("Wuff:", self.name)


# Name eines Hundes außerhalb der Klasse ändern
def name_aendern(hund):
    # Dem Hund einen neuen Namen geben und diesen anzeigen
    print("Name wird innerhalb einer Funktion geändert")
    hund.name = "Hasso"
    hund.belle_namen()

    # Einen neuen Hund erzeugen
    print("Identitätsdiebstahl bei Hunden!")
    hund = Hund("Bello")
    hund.belle_namen()


def main():
    # Hauptprogramm
    print("Ein Hund wird geboren")
    hund = Hund("Fluffy")
    hund.belle_namen()

    # Namen des Hundes ändern und anzeigen
    name_aendern(hund)

    print("Bin ich noch ich?")
    hund.belle_namen()


main()
