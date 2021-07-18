# Beispiel 5.9
#
# Das Gleiche ist nicht dasselbe
#


# Klassendefinition (Autoradio)
class Autoradio:
    def __init__(self):
        self.lautstaerke = 10

    def zeige_daten(self):
        print("Lautstärke des Autoradios:", self.lautstaerke)


# Klassendefinition (Auto)
class Auto:
    def __init__(self, marke, autoradio):
        self.marke = marke
        self.autoradio = autoradio

        print("Neues Auto erstellt")

    def zeige_daten(self):
        print("Marke:", self.marke)
        self.autoradio.zeige_daten()

    def lautstaerke_anpassen(self):
        self.autoradio.lautstaerke += 2


def main():
    # Hauptprogramm
    autoradio = Autoradio()

    auto_eins = Auto("DeLorean", autoradio)
    auto_zwei = Auto("Pontiac", autoradio)

    print("\nVor der Anpassung:")
    auto_eins.zeige_daten()
    auto_zwei.zeige_daten()

    # Automatische Lautstärkeanpassung für das erste Auto
    auto_eins.lautstaerke_anpassen()

    print("\nNach der Anpassung:")
    auto_eins.zeige_daten()
    auto_zwei.zeige_daten()


main()
