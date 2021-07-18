# Beispiel 5.8
#
# Lösungsvorschlag zur Aufgabenstellung
#


# Klassendefinition (Autoradio)
class Autoradio:
    def __init__(self, marke, cd):
        self.marke = marke
        self.cd = cd

        print("Autoradio erstellt")

    def zeige_daten(self):
        print("Autoradio von", self.marke)

        if self.cd == True:
            print("Mit CD-Player")
        else:
            print("Ohne CD-Player")


# Klassendefinition (Auto)
class Auto:
    def __init__(self, marke, farbe, autoradio):
        self.marke = marke
        self.farbe = farbe
        self.autoradio = autoradio

        print("Neues Auto erstellt")

    def zeige_daten(self):
        print("\nMarke:", self.marke)
        print("Farbe:", self.farbe)
        self.autoradio.zeige_daten()


def main():
    # Hauptprogramm
    autoradio_modell_a = Autoradio("Blaupunkt", True)
    autoradio_modell_b = Autoradio("Kenwood", False)
    autoradio_modell_c = Autoradio("Panasonic", True)

    auto_eins = Auto("Mercedes-Benz", "Silber", autoradio_modell_a)
    auto_zwei = Auto("Skoda", "Grün", autoradio_modell_b)
    auto_drei = Auto("Chevrolet", "Schwarz", autoradio_modell_c)

    auto_eins.zeige_daten()
    auto_zwei.zeige_daten()
    auto_drei.zeige_daten()


main()
