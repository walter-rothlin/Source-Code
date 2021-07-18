# Beispiel 5.13
#
# Vererbung – Überschreiben von Methoden - 1
#


# Klassendefinition (Fahrzeug)
class Fahrzeug:
    def __init__(self):
        self.baujahr = 2017
        print("Neues Fahrzeug erstellt")


# Klassendefinition (Auto)
class Auto(Fahrzeug):
    def __init__(self):
        self.soundsystem = "Einfaches Radio"
        print("Neues Auto erstellt")


def main():
    # Hauptprogramm
    auto = Auto()
    print(auto.baujahr)  # Fehler!


main()
