# Beispiel 5.7
#
# Statische Methoden
#


# Klassendefinition (Auto)
class Auto:
    anzahl_automatik = 0
    anzahl_schaltgetriebe = 0

    def __init__(self, marke, automatik):
        self.marke = marke

        print("Neues Auto erstellt")

        if automatik:
            Auto.anzahl_automatik += 1
        else:
            Auto.anzahl_schaltgetriebe += 1

    @staticmethod
    def zeige_statistik():
        print("Autos mit Automatikgetriebe:", Auto.anzahl_automatik)
        print("Autos mit Schaltgetriebe", Auto.anzahl_schaltgetriebe)
        print("")


def main():
    # Hauptprogramm

    Auto.zeige_statistik()

    auto_eins = Auto("Fiat", True)
    auto_zwei = Auto("Honda", False)
    auto_drei = Auto("Daihatsu", True)
    auto_vier = Auto("Datsun", True)
    auto_fuenf = Auto("Kia", False)

    print("")

    Auto.zeige_statistik()

    # Auch das ist möglich, aber nicht zu empfehlen!
    auto_vier.zeige_statistik()


main()
