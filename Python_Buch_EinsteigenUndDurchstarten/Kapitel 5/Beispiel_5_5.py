# Beispiel 5.5
#
# Klassenattribute
#


# Klassendefinition
class Auto:
    # Klassenattribute
    intervall_erste_hu = 36
    intervall_zweite_hu = 24

    def __init__(self, marke):
        self.marke = marke

        print("Neues Auto erstellt")

    def zeige_daten(self):
        print("\nMarke:", self.marke)
        print("Intervall erste HU: {0} Monate".format(Auto.intervall_erste_hu))
        print("Intervall zweite HU: {0} Monate".format(Auto.intervall_zweite_hu))


def main():
    # Hauptprogramm
    auto_eins = Auto("Nissan")
    auto_zwei = Auto("Mitsubishi")

    auto_eins.zeige_daten()
    auto_zwei.zeige_daten()

    Auto.intervall_zweite_hu = 12

    auto_eins.zeige_daten()
    auto_zwei.zeige_daten()

    auto_drei = Auto("Batmobil")
    auto_drei.zeige_daten()

main()
