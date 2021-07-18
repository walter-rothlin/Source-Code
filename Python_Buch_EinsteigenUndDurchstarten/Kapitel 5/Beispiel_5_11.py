# Beispiel 5.11
#
# None
#


# Klassendefinition (Autoradio)
class Autoradio:
    def __init__(self, marke):
        self.marke = marke
        print("Autoradio erstellt")

    def zeige_daten(self):
        print("Autoradio von", self.marke)


# Klassendefinition (Auto)
class Auto:
    def __init__(self, marke):
        self.marke = marke
        self.autoradio = None

        print("Neues Auto erstellt")

    def montiere_autoradio(self, autoradio):
        self.autoradio = autoradio

    def zeige_daten(self):
        print("\nMarke:", self.marke)

        if self.autoradio is None:
            print("Kein Autoradio verbaut!")
        else:
            self.autoradio.zeige_daten()


def main():
    # Hauptprogramm
    autoradio = Autoradio("JVC")

    auto = Auto("K.I.T.T.")
    auto.zeige_daten()

    auto.montiere_autoradio(autoradio)
    auto.zeige_daten()


main()
