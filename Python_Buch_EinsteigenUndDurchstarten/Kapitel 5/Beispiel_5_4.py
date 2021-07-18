# Beispiel 5.4
#
# Dynamische Attribute
#


# Klassendefinition
class Auto:
    def __init__(self, marke, farbe):
        self.marke = marke
        self.farbe = farbe

        print("Hurra, ein Neuwagen!")

    def zeige_daten(self):
        print("Marke:", self.marke)
        print("Farbe:", self.farbe)


def main():
    # Hauptprogramm
    auto_eins = Auto("VW", "Blau")
    auto_zwei = Auto("Opel", "Gelb")

    print("\nDaten von Auto eins:")
    auto_eins.zeige_daten()

    print("\nDaten von Auto zwei:")
    auto_zwei.zeige_daten()

    # Einen Aufkleber anbringen
    auto_eins.aufkleber = "Baby an Bord!"

    print(auto_eins.aufkleber)

    # Das führt zu einem Fehler!
    #print(auto_zwei.aufkleber)


main()
