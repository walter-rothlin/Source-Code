# Beispiel 5.14
#
# Vererbung - Überschreiben von Methoden - 2
#


# Klassendefinition (Fahrzeug)
class Fahrzeug:
    def __init__(self, marke):
        self.marke = marke
        print("Neues Fahrzeug erstellt:", self.marke)

    def starten(self):
        print("Motor wird gestartet")

    def signal_geben(self):
        print("Kein Signalgeber verbaut!")


# Klassendefinition (Auto)
class Auto(Fahrzeug):
    def __init__(self, marke):
        super().__init__(marke)
        self.soundsystem = "Einfaches Radio"
        print("Neues Auto erstellt")

    def starten(self):
        print("Soundsystem {0} wird eingeschaltet".format(self.soundsystem))
        super().starten()  # Aufruf der Methode "starten" der Basisklasse
        print("Auto ist bereit zur Fahrt")

    def signal_geben(self):
        print("Auto hupt!")


# Klassendefinition (Motorrad)
class Motorrad(Fahrzeug):
    def __init__(self, marke):
        super().__init__(marke)
        self.fussrasten = "Aluminium"
        print("Neues Motorrad erstellt")

    def starten(self):
        print("Fußrasten aus {0} werden ausgeklappt". format(self.fussrasten))
        Fahrzeug.starten(self)  # Auch so kann die Basisklasse verwendet werden
        print("Motorrad ist bereit zur Fahrt")


def main():
    # Hauptprogramm
    auto = Auto("Chrysler")
    auto.starten()
    auto.signal_geben()

    print("")

    motorrad = Motorrad("Aprilia")
    motorrad.starten()
    motorrad.signal_geben()


main()
